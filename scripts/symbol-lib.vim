"0	    NUL (null)
"1	    SOH (start of header)
"2	    STX (start of text)
"3	    ETX (end of text)
"4	    EOT (end of transmission)
"5	    ENQ (enquiry)
"6	    ACK (acknowledge)
"7	    BEL (bell)
"8	    BS (backspace)
"9	    HT (horizontal tab)
"10	    LF (line feed - newline)
"11	    VT (vertical tab)
"12	    FF (form feed - newpage)
"13	    CR (carriage return)
"14	    SO (shift out)
"15	    SI (shift in)
"16	    DLE (data link escape)
"17	    DC1 (device control 1)
"18	    DC2 (device control 2)
"19	    DC3 (device control 3)
"20	    DC4 (device control 4)
"21	    NAK (negative acknowledge)
"22	    SYN (synchronous idle)
"23	    ETB (end of transmission block)
"24	    CAN (cancel)
"25	    EM (end of medium)
"26	    SUB (substitute)
"27	    ESC (escape)
"28	    FS (file separator)
"29	    GS (group separator)
"30	    RS (record separator)
"31	    US (unit separator)
"32	    (space)
"33	    !
"34	    "
"35	    #
"36	    $
"37	    %
"38	    &
"39	    '
"40	    (
"41     )
"42	    *
"43     +
"44	    ,
"45     -
"46     .
"47     /
"48	    0
"49	    1
"50	    2
"51	    3
"52	    4
"53     5
"54     6
"55	    7
"56	    8
"57	    9
"58	    :
"59	    ;
"60     <
"61     =
"62     >
"63     ?
"64	    @
"65	    A
"66	    B
"67	    C
"68	    D
"69	    E
"70	    F
"71	    G
"72	    H
"73	    I
"74	    J
"75	    K
"76	    L
"77	    M
"78	    N
"79	    O
"80	    P
"81	    Q
"82	    R
"83	    S
"84	    T
"85	    U
"86	    V
"87	    W
"88	    X
"89	    Y
"90	    Z
"91	    [
"92	    \
"93	    ]
"94	    ^
"95	    _
"96	    `
"97	    a
"98	    b
"99	    c
"100	d
"101	e
"102	f
"103	g
"104	h
"105	i
"106	j
"107	k
"108	l
"109	m
"110	n
"111	o
"112	p
"113	q
"114	r
"115	s
"116	t
"117	u
"118	v
"119	w
"120	x
"121	y
"122	z
"123	{
"124	|
"125	}
"126	~
"127	DEL (delete)

"

"text = '●',
"double_text = '●',
"text = '◆',
"double_text = '◆',
"text = '●',
"text = '▶',
"text = '●▶',
"double_text  = '▷',
"text=⬤
" ⭙   ⬤  ⏺  ⚑  ⛔

"all kinds of symbols here,  just paste them in
"https://www.w3schools.com/charsets/ref_utf_symbols.asp
"http://shapecatcher.com/
"https://unicode-table.com/en/
"https://unicode-table.com/en/blocks/dingbats/
"https://www.nerdfonts.com/cheat-sheet
"®
"‖ 🔎🕹🕴🕵💯    🔌
"📍
"📎
"📌  📊📈📋💬⏩ ⏰⏳ 😜⚡
"🔵⚿ 🔴⚫🌓🌕🏐🎱🌑🔮🔘📀💿💽📵⭕🍚⚪💩🌰♿ ✅✔✖❎❓🍒❗🍄🌡🌋👀👁👉 💎 💣💫💤💪  🔥💥
"◷💥⛪ ⛺🚧
"🏠
"🍺 🍻  ⛣⛢ ⛬⛭ ⛰ ◎◒◉◯ ∅     🚫🚀 🔶🔷🛑   🔳 🔲⬛⬜   □ ⧄ ⊡ ▪      🔼🔽     ↙↓ ← → ↑    ∘
"ꕕ✗❌⚠⌀
"↶↺◌
"◕◑◔
"◜◟◞◝◜
"◰◱◲◳ ◜
"◴◵◶◷ ◜
"▼
"🌑🌒🌓🌔🌕🌖🌗🌘}
"✶⨳⋆☆★❇🕸 ✳✨ ⭐🌀🌟🔆🌠
"❖
"▐
"
"
"ﰴ
function! IsSymbol(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n>32 && n<65 || n>=91 &&  n<=96 || n>122
    :return 1
  else
    :return 0
  endif
endfunction

function! IsBiSymbol(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n==91 || n==93 || n==123 || n==125 || n==40 || n==41 || n==34 || n==39 || n==96 || n==60 || n==62
    :return 1
  else
    :return 0
  endif
endfunction

function! IsLeftBiSymbol(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n==91 || n==123 || n==40 || n==34 || n==39 || n==96 || n==60
    :return 1
  else
    :return 0
  endif
endfunction

function! IsRightBiSymbol(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n==93 || n==125 || n==41 || n==39 || n==96 || n==60 || n==62
    :return 1
  else
    :return 0
  endif
endfunction


function! IsNumber(var)
  :return type(a:var) == type(0)
endfunction
function! IsString(var)
  return type(a:var)==type(" ")
endfunction
function! IsList(var)
  return type(a:var)==type([])
endfunction



function! IsSpace(c)
  if IsNumber(a:c)
    :let n = a:c
  else
    :let n=char2nr(a:c)
  endif
  :return n==32
endfunction

function! IsUnderscore(c)
  if IsNumber(a:c)
    :let n = a:c
  else
    :let n=char2nr(a:c)
  endif
  :return n==95
endfunction


function! IsExclamation(c)
  :let n=char2nr(a:c)
  :return n==33
endfunction

function! IsUpper(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n>=65 && n<=90
     :return 1
  else
    :return 0
  endif
endfunction

function! IsLower(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n>=97 && n<=122
     :return 1
  else
    :return 0
  endif
endfunction

function! IsSymbolOrCaps(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n>32 && n<97
     :return 1
  else
    :return 0
  endif
endfunction

function! IsAlpha(n)
  :let n=a:n
  if IsString(n)
    :let n=char2nr(n)
  endif
  if n>65 && n<91 || n>96 && n<123
    :return 1
  else
    :return 0
  endif
endfunction


function! GotoOppositeSymbol()
  :let n=char2nr(GetCharUnderCursor())
  if n==91 || n==93 || n==123 || n==125 || n==40 || n==41
    :exe 'norm! %'
  else
    if n==34 || n==39 || n==96 || n==60
      if n==60
        let n=62
      endif
      "if n==62
        "let n=60
      "endif
      :exe 'norm! l'
      :let n2=char2nr(GetCharUnderCursor())
      :let prev_was_escape = 0
      while n2!=n || prev_was_escape==1
        if n2!=92
          :let prev_was_escape = 0
        endif
        if CursorIsAtEndOfLine()
          :exe 'norm! j0'
        else
          :exe 'norm! l'
        endif
        :let n2=char2nr(GetCharUnderCursor())
        if n2==92
          :let prev_was_escape = 1
        endif
      endwhile
    endif
  endif
endfunction



