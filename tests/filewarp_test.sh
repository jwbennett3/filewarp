# filewarp unit tests
#
# Each test_* function runs in a subshell with:
#   FILE_WARP_TMP_PATH -> fresh temp dir
#   PATH               -> MOCK_DIR prepended
#   TEST_TMP           -> same as FILE_WARP_TMP_PATH
#   MOCK_ABS_DIR, MOCK_NAME, MOCK_MIME_TYPE, INDEX, out_reg (set by test)
#
# Mock navdown2 writes MOCK_ABS_DIR / MOCK_NAME into state files, and
#   writes $id -> $FILE_WARP_TMP_PATH/.test_id for test assertions.
# Mock open/openFileForEditing/focusActiveEditor append to
#   $FILE_WARP_TMP_PATH/called_commands.
# Mock file returns MOCK_MIME_TYPE for --mime-type queries.

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

wait_for_called_commands() {
  local max=20 i=0
  while [[ $i -lt $max ]] && [[ ! -s "$FILE_WARP_TMP_PATH/called_commands" ]]; do
    sleep 0.05
    i=$((i + 1))
  done
}

# ---------------------------------------------------------------------------
# ID assignment
# ---------------------------------------------------------------------------

test_id_assignment_from_ide_0() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="foo" \
  source "$ROOT_DIR/filewarp" /tmp

  local recorded
  recorded=$(cat "$FILE_WARP_TMP_PATH/.test_id" 2>/dev/null)
  assert_eq "$$" "$recorded" "id should be \$\$ when from_ide=0"
}

test_id_assignment_from_ide_1() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="foo" \
  source "$ROOT_DIR/filewarp" /tmp normal 1

  local recorded
  recorded=$(cat "$FILE_WARP_TMP_PATH/.test_id" 2>/dev/null)
  assert_eq "0" "$recorded" "id should be 0 when from_ide=1"
}

# ---------------------------------------------------------------------------
# State directory creation
# ---------------------------------------------------------------------------

test_state_dir_contains_abs_dir_and_name() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="file.txt" \
  source "$ROOT_DIR/filewarp" /start/path

  local id_val
  id_val=$(cat "$FILE_WARP_TMP_PATH/.test_id" 2>/dev/null)

  assert_file_exists "$FILE_WARP_TMP_PATH/$id_val/abs_dir" "abs_dir file should exist"
  assert_file_exists "$FILE_WARP_TMP_PATH/$id_val/name" "name file should exist"

  local abs_dir name
  abs_dir=$(cat "$FILE_WARP_TMP_PATH/$id_val/abs_dir")
  name=$(cat "$FILE_WARP_TMP_PATH/$id_val/name")
  assert_eq "$TEST_TMP/target" "$abs_dir" "abs_dir content should match MOCK_ABS_DIR"
  assert_eq "file.txt" "$name" "name content should match MOCK_NAME"
}

# ---------------------------------------------------------------------------
# out_reg handling
# ---------------------------------------------------------------------------

test_out_reg_writes_curr_dir() {
  local reg_dir="$TEST_TMP/out_reg"
  mkdir -p "$reg_dir" "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="file" out_reg="$reg_dir" \
  source "$ROOT_DIR/filewarp" /tmp

  assert_file_exists "$reg_dir/curr_dir" "curr_dir written to out_reg"
  local curr_dir
  curr_dir=$(cat "$reg_dir/curr_dir")
  assert_eq "$TEST_TMP/target" "$curr_dir" "curr_dir should contain abs_dir"
}

test_out_reg_not_set_does_not_write() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="file" out_reg="" \
  source "$ROOT_DIR/filewarp" /tmp

  assert_file_not_exists "$TEST_TMP/curr_dir" "curr_dir should not be written when out_reg is unset"
}

# ---------------------------------------------------------------------------
# Non-kitty terminal — no file selected, normal mode -> cd only
# ---------------------------------------------------------------------------

test_non_kitty_no_file_normal_mode() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="nonexistent" TERM=xterm-256color \
  source "$ROOT_DIR/filewarp" /tmp

  assert_eq "$TEST_TMP/target" "$PWD" "should cd to abs_dir"
  assert_file_not_exists "$FILE_WARP_TMP_PATH/called_commands" "no open commands should be called"
}

# ---------------------------------------------------------------------------
# Non-kitty terminal — file exists, normal mode -> open + cd
# ---------------------------------------------------------------------------

test_non_kitty_file_exists_normal_mode() {
  mkdir -p "$TEST_TMP/target"
  local the_file="$TEST_TMP/target/existing.txt"
  touch "$the_file"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="existing.txt" TERM=xterm-256color \
  source "$ROOT_DIR/filewarp" /tmp

  assert_eq "$TEST_TMP/target" "$PWD" "should cd to abs_dir"
  wait_for_called_commands
  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  assert_eq "open:$the_file" "$calls" "open should be called with file path"
}

# ---------------------------------------------------------------------------
# Non-kitty terminal — file exists, view mode -> open only, no cd
# ---------------------------------------------------------------------------

test_non_kitty_file_exists_view_mode() {
  mkdir -p "$TEST_TMP/target"
  local the_file="$TEST_TMP/target/existing.txt"
  touch "$the_file"
  local start_dir="$PWD"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="existing.txt" TERM=xterm-256color \
  source "$ROOT_DIR/filewarp" /tmp view

  assert_eq "$start_dir" "$PWD" "should NOT cd in view mode"
  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  assert_eq "open:$the_file" "$calls" "open should be called with file path"
}

# ---------------------------------------------------------------------------
# Kitty terminal — text file -> openFileForEditing + cd
# ---------------------------------------------------------------------------

test_kitty_text_file() {
  mkdir -p "$TEST_TMP/target"
  local the_file="$TEST_TMP/target/readme.txt"
  touch "$the_file"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="readme.txt" \
  TERM=xterm-kitty MOCK_MIME_TYPE="text/plain" INDEX=42 \
  source "$ROOT_DIR/filewarp" /tmp

  assert_eq "$TEST_TMP/target" "$PWD" "should cd to abs_dir in normal mode"
  wait_for_called_commands
  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  assert_eq "openFileForEditing:42 $the_file" "$calls" "openFileForEditing with INDEX and file path"
}

# ---------------------------------------------------------------------------
# Kitty terminal — binary file -> open + cd
# ---------------------------------------------------------------------------

test_kitty_binary_file() {
  mkdir -p "$TEST_TMP/target"
  local the_file="$TEST_TMP/target/image.png"
  touch "$the_file"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="image.png" \
  TERM=xterm-kitty MOCK_MIME_TYPE="image/png" \
  source "$ROOT_DIR/filewarp" /tmp

  assert_eq "$TEST_TMP/target" "$PWD" "should cd to abs_dir"
  wait_for_called_commands
  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  assert_eq "open:$the_file" "$calls" "open should be called with binary file"
}

# ---------------------------------------------------------------------------
# Kitty terminal — no file (directory only) -> cd only
# ---------------------------------------------------------------------------

test_kitty_no_file_normal_mode() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="nonexistent" \
  TERM=xterm-kitty MOCK_MIME_TYPE="inode/directory" \
  source "$ROOT_DIR/filewarp" /tmp

  assert_eq "$TEST_TMP/target" "$PWD" "should cd to abs_dir"
  assert_file_not_exists "$FILE_WARP_TMP_PATH/called_commands" "no open commands for directory"
}

# ---------------------------------------------------------------------------
# Kitty terminal — text file, view mode -> openFileForEditing only, no cd
# ---------------------------------------------------------------------------

test_kitty_text_file_view_mode() {
  mkdir -p "$TEST_TMP/target"
  local the_file="$TEST_TMP/target/notes.txt"
  touch "$the_file"
  local start_dir="$PWD"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="notes.txt" \
  TERM=xterm-kitty MOCK_MIME_TYPE="text/plain" INDEX=7 \
  source "$ROOT_DIR/filewarp" /tmp view

  assert_eq "$start_dir" "$PWD" "should NOT cd in view mode"
  wait_for_called_commands
  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  assert_eq "openFileForEditing:7 $the_file" "$calls" "openFileForEditing in kitty+view mode"
}

# ---------------------------------------------------------------------------
# IDE mode — file exists -> openFileForEditing + focusActiveEditor
# ---------------------------------------------------------------------------

test_ide_mode_with_file() {
  mkdir -p "$TEST_TMP/target"
  local the_file="$TEST_TMP/target/project.py"
  touch "$the_file"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="project.py" \
  source "$ROOT_DIR/filewarp" /tmp normal 1 99

  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  local expected="openFileForEditing:99 $the_file normal"
  expected="$expected"$'\n'"focusActiveEditor:"
  assert_eq "$expected" "$calls" "openFileForEditing + focusActiveEditor in IDE mode"
}

# ---------------------------------------------------------------------------
# IDE mode — no file -> focusActiveEditor only
# ---------------------------------------------------------------------------

test_ide_mode_no_file() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="nonexistent" \
  source "$ROOT_DIR/filewarp" /tmp normal 1 42

  local calls
  calls=$(cat "$FILE_WARP_TMP_PATH/called_commands")
  assert_eq "focusActiveEditor:" "$calls" "only focusActiveEditor when no file in IDE mode"
}

# ---------------------------------------------------------------------------
# Default argument values
# ---------------------------------------------------------------------------

test_default_mode_is_normal() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="dummy" \
  source "$ROOT_DIR/filewarp" /tmp

  assert_eq "$TEST_TMP/target" "$PWD" "default mode should be normal (cd executed)"
}

test_default_from_ide_is_0() {
  mkdir -p "$TEST_TMP/target"

  MOCK_ABS_DIR="$TEST_TMP/target" MOCK_NAME="dummy" \
  source "$ROOT_DIR/filewarp" /tmp

  local recorded
  recorded=$(cat "$FILE_WARP_TMP_PATH/.test_id" 2>/dev/null)
  assert_eq "$$" "$recorded" "default from_ide should be 0 (id=\$\$)"
}
