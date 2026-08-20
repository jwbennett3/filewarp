#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TESTS_DIR="$ROOT_DIR/tests"
MOCK_DIR="$TESTS_DIR/mocks"

PASS=0
FAIL=0
FAILED_TESTS=()

export ROOT_DIR MOCK_DIR

# Assertion helpers — called from within test subprocesses
assert_eq() {
  local expected=$1 actual=$2 label=$3
  if [[ "$expected" != "$actual" ]]; then
    echo "FAIL:$label:expected [$expected] actual [$actual]" >&2
    return 1
  fi
}

assert_file_contains() {
  local file=$1 expected=$2 label=$3
  if [[ ! -f "$file" ]]; then
    echo "FAIL:$label:file not found [$file]" >&2
    return 1
  fi
  local content
  content=$(cat "$file" 2> "$HOME"/null)
  if [[ "$content" != "$expected" ]]; then
    echo "FAIL:$label:file [$file] expected [$expected] actual [$content]" >&2
    return 1
  fi
}

assert_file_exists() {
  local file=$1 label=$2
  if [[ ! -f "$file" ]]; then
    echo "FAIL:$label:file not found [$file]" >&2
    return 1
  fi
}

assert_file_not_exists() {
  local file=$1 label=$2
  if [[ -f "$file" ]]; then
    echo "FAIL:$label:file should not exist [$file]" >&2
    return 1
  fi
}

run_one_test() {
  local test_name=$1
  local tmp_dir
  tmp_dir=$(mktemp -d "/tmp/filewarp_test.XXXXXX")

  local log_id="test_${test_name}"
  local cmd_log="$tmp_dir/called_commands"

  set +e
  (
    set -e
    export FILE_WARP_TMP_PATH="$tmp_dir"
    export PATH="$MOCK_DIR:$PATH"
    export MOCK_LOG_ID="$log_id"
    export TEST_TMP="$tmp_dir"
    export TEST_NAME="$test_name"

    cd "$tmp_dir"
    # Execute the test function; it must be defined by the sourced test file
    "$test_name"
  ) 2> "$tmp_dir/test_stderr"
  local exit_code=$?
  set -e

  if [[ $exit_code -eq 0 ]]; then
    echo "  PASS  $test_name"
    PASS=$((PASS + 1))
  else
    local err_detail
    err_detail=$(tr '\n' ';' < "$tmp_dir/test_stderr" 2> "$HOME"/null | sed 's/;$//')
    echo "  FAIL  $test_name"
    echo "        $err_detail"
    FAIL=$((FAIL + 1))
    FAILED_TESTS+=("$test_name")
  fi

  rm -rf "$tmp_dir"
}

echo "filewarp unit tests"
echo "-------------------"

source "$TESTS_DIR/filewarp_test.sh"

# Discover and run every function prefixed with test_
TEST_FUNCS=($(declare -F | awk '{print $3}' | grep '^test_'))
for tf in "${TEST_FUNCS[@]}"; do
  run_one_test "$tf"
done

echo "-------------------"
echo "Results: $PASS passed, $FAIL failed"
if [[ $FAIL -gt 0 ]]; then
  echo "Failed tests:"
  for t in "${FAILED_TESTS[@]}"; do
    echo "  - $t"
  done
  exit 1
fi
