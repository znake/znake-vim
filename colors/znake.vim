" znake - Full Colour and 256 Colour
" http://www.artathack.com
"
" Hex colour conversion functions borrowed from the theme "Desert256""
" Pretty much stolen from the Tomorrow theme https://github.com/chriskempson/tomorrow-theme

" Default GUI Colours
let s:white = "eaeaea"
let s:black = "000000"
let s:darkgrey = "2a2a2a"
let s:comment = "2a5680"
let s:red = "da4939"
let s:darkred = "1b000d"
let s:orange = "ffc66d"
let s:brown = "cc7833"
let s:highyellow = "ffff00"
let s:yellow = "ffc66d"
let s:green = "a5c261"
let s:highgreen = "abff00"
let s:darkgreen = "519f50"
let s:blue = "6d9cbe"
let s:purple = "c397d8"
let s:purplelight = "f5c5f1"
let s:middlegrey = "4d5057"
let s:pink = "ff0080"
let s:darkpink = "6f0037"
let s:grey1 = "535353"
let s:grey2 = "191919"
let s:grey3 = "868686"

let s:wikired    = "ff6666"
let s:wikiorange = "ff8000"
let s:wikiyellow = "ffff66"
let s:wikiaqua   = "66ffcc"
let s:wikigreen  = "008040"
let s:wikiblue   = "66ccff"

set background=dark
hi clear
syntax reset

let g:colors_name = "znake"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
	" Returns an approximate grey index for the given grey level
	fun <SID>grey_number(x)
		if &t_Co == 88
			if a:x < 23
				return 0
			elseif a:x < 69
				return 1
			elseif a:x < 103
				return 2
			elseif a:x < 127
				return 3
			elseif a:x < 150
				return 4
			elseif a:x < 173
				return 5
			elseif a:x < 196
				return 6
			elseif a:x < 219
				return 7
			elseif a:x < 243
				return 8
			else
				return 9
			endif
		else
			if a:x < 14
				return 0
			else
				let l:n = (a:x - 8) / 10
				let l:m = (a:x - 8) % 10
				if l:m < 5
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual grey level represented by the grey index
	fun <SID>grey_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 46
			elseif a:n == 2
				return 92
			elseif a:n == 3
				return 115
			elseif a:n == 4
				return 139
			elseif a:n == 5
				return 162
			elseif a:n == 6
				return 185
			elseif a:n == 7
				return 208
			elseif a:n == 8
				return 231
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 8 + (a:n * 10)
			endif
		endif
	endfun

	" Returns the palette index for the given grey index
	fun <SID>grey_colour(n)
		if &t_Co == 88
			if a:n == 0
				return 16
			elseif a:n == 9
				return 79
			else
				return 79 + a:n
			endif
		else
			if a:n == 0
				return 16
			elseif a:n == 25
				return 231
			else
				return 231 + a:n
			endif
		endif
	endfun

	" Returns an approximate colour index for the given colour level
	fun <SID>rgb_number(x)
		if &t_Co == 88
			if a:x < 69
				return 0
			elseif a:x < 172
				return 1
			elseif a:x < 230
				return 2
			else
				return 3
			endif
		else
			if a:x < 75
				return 0
			else
				let l:n = (a:x - 55) / 40
				let l:m = (a:x - 55) % 40
				if l:m < 20
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual colour level for the given colour index
	fun <SID>rgb_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 139
			elseif a:n == 2
				return 205
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 55 + (a:n * 40)
			endif
		endif
	endfun

	" Returns the palette index for the given R/G/B colour indices
	fun <SID>rgb_colour(x, y, z)
		if &t_Co == 88
			return 16 + (a:x * 16) + (a:y * 4) + a:z
		else
			return 16 + (a:x * 36) + (a:y * 6) + a:z
		endif
	endfun

	" Returns the palette index to approximate the given R/G/B colour levels
	fun <SID>colour(r, g, b)
		" Get the closest grey
		let l:gx = <SID>grey_number(a:r)
		let l:gy = <SID>grey_number(a:g)
		let l:gz = <SID>grey_number(a:b)

		" Get the closest colour
		let l:x = <SID>rgb_number(a:r)
		let l:y = <SID>rgb_number(a:g)
		let l:z = <SID>rgb_number(a:b)

		if l:gx == l:gy && l:gy == l:gz
			" There are two possibilities
			let l:dgr = <SID>grey_level(l:gx) - a:r
			let l:dgg = <SID>grey_level(l:gy) - a:g
			let l:dgb = <SID>grey_level(l:gz) - a:b
			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
			let l:dr = <SID>rgb_level(l:gx) - a:r
			let l:dg = <SID>rgb_level(l:gy) - a:g
			let l:db = <SID>rgb_level(l:gz) - a:b
			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
			if l:dgrey < l:drgb
				" Use the grey
				return <SID>grey_colour(l:gx)
			else
				" Use the colour
				return <SID>rgb_colour(l:x, l:y, l:z)
			endif
		else
			" Only one possibility
			return <SID>rgb_colour(l:x, l:y, l:z)
		endif
	endfun

	" Returns the palette index to approximate the 'rrggbb' hex string
	fun <SID>rgb(rgb)
		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

		return <SID>colour(l:r, l:g, l:b)
	endfun

	" Sets the highlighting for the given group
	fun <SID>X(group, fg, bg, attr)
		if a:fg != ""
			exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
		endif
		if a:bg != ""
			exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
		endif
		if a:attr != ""
			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
		endif
	endfun

	" Vim Highlighting
	call <SID>X("Normal", s:white, s:black, "")
	call <SID>X("darkgreyNr", s:grey1, "", "")
	call <SID>X("NonText", s:darkred, "", "")
	call <SID>X("SpecialKey", s:darkred, "", "")
	call <SID>X("Search", s:black, s:yellow, "")
	call <SID>X("Tabdarkgrey", s:white, s:black, "reverse")
	call <SID>X("Statusdarkgrey", s:grey2, s:yellow, "reverse")
	call <SID>X("StatusdarkgreyNC", s:grey2, s:grey3, "reverse")
	call <SID>X("VertSplit", s:middlegrey, s:middlegrey, "none")
  call <SID>X("Visual", "", s:darkpink, "")
	"call <SID>X("Visual", "", s:black, "reverse")
	call <SID>X("Directory", s:blue, "", "")
	call <SID>X("ModeMsg", s:green, "", "")
	call <SID>X("MoreMsg", s:green, "", "")
	call <SID>X("Question", s:green, "", "")
	call <SID>X("WarningMsg", s:red, "", "")
	call <SID>X("MatchParen", "", s:black, "reverse")
	call <SID>X("Folded", s:comment, s:black, "")
	call <SID>X("FoldColumn", "", s:black, "")
	if version >= 700
		call <SID>X("Cursor", "", s:pink, "none")
		call <SID>X("LineNr", s:grey3, "", "none")
		call <SID>X("Cursordarkgrey", "", s:darkred, "none")
		call <SID>X("CursorColumn", "", s:darkred, "none")
		call <SID>X("CursorLine", "", s:darkred, "none")
		call <SID>X("CursorLineNr", s:pink, "", "none")
		call <SID>X("PMenu", s:white, s:darkred, "none")
		call <SID>X("PMenuSel", s:white, s:darkred, "reverse")
	end
	if version >= 703
		call <SID>X("ColorColumn", "", s:darkred, "none")
	end

  call <SID>X("DiffAdd", s:black, s:green, "")
  call <SID>X("DiffChange", s:black, s:blue, "")
  call <SID>X("DiffText", s:black, s:white, "")
  call <SID>X("DiffDelete", s:black, s:red, "")


	" Standard Highlighting
	call <SID>X("Comment", s:comment, "", "")
	call <SID>X("Todo", s:comment, s:black, "")
	call <SID>X("Title", s:comment, "", "")
	call <SID>X("Identifier", s:blue, "", "none")
	call <SID>X("Statement", s:white, "", "")
	call <SID>X("Conditional", s:white, "", "")
	call <SID>X("Repeat", s:white, "", "")
	call <SID>X("Number", s:yellow, "", "")
	call <SID>X("Structure", s:red, "", "")
	call <SID>X("Function", s:orange, "", "")
	call <SID>X("Constant", s:blue, "", "")
	call <SID>X("String", s:green, "", "")
	call <SID>X("Special", s:red, "", "")
	call <SID>X("PreProc", s:brown, "", "")
	call <SID>X("Operator", s:brown, "", "none")
	call <SID>X("Type", s:blue, "", "none")
	call <SID>X("Define", s:brown, "", "none")
	call <SID>X("Include", s:blue, "", "")
  call <SID>X("Ignore", "666666", "", "")

	" Vim Highlighting
  call <SID>X("vimCommand", s:white, "", "none")

	" C Highlighting
	call <SID>X("cType", s:yellow, "", "")
	call <SID>X("cStorageClass", s:purple, "", "")
	call <SID>X("cConditional", s:purple, "", "")
	call <SID>X("cRepeat", s:purple, "", "")

	" PHP Highlighting
	call <SID>X("phpVarSelector", s:red, "", "")
	call <SID>X("phpKeyword", s:purple, "", "")
	call <SID>X("phpRepeat", s:purple, "", "")
	call <SID>X("phpConditional", s:purple, "", "")
	call <SID>X("phpStatement", s:purple, "", "")
	call <SID>X("phpMemberSelector", s:white, "", "")

	" Ruby Highlighting
	call <SID>X("rubySymbol", s:blue, "", "")
	call <SID>X("rubyConstant", s:red, "", "")
	call <SID>X("rubyAttribute", s:brown, "", "")
	call <SID>X("rubyInclude", s:blue, "", "")
	call <SID>X("rubyLocalVariableOrMethod", s:brown, "", "")
	call <SID>X("rubyCurlyBlock", s:red, "", "")
	call <SID>X("rubyStringDelimiter", s:green, "", "")
  call <SID>X("rubyInterpolation", s:darkgreen, "", "")
	call <SID>X("rubyInterpolationDelimiter", s:darkgreen, "", "")
	call <SID>X("rubyConditional", s:purple, "", "")
	call <SID>X("rubyRepeat", s:purple, "", "")
  call <SID>X("rubyBlockParameter", s:blue, "", "")
  call <SID>X("rubyClass", s:brown, "", "")
  call <SID>X("rubyFunction", s:orange, "", "")
  call <SID>X("rubyInstanceVariable", s:purplelight, "", "")
  "call <SID>X("rubyLocalVariableOrMethod", s:brown, "", "")
  "call <SID>X("rubyPredefinedConstant", s:brown, "", "")
  "call <SID>X("rubyPseudoVariable", s:brown, "", "")


	" Python Highlighting
	call <SID>X("pythonInclude", s:purple, "", "")
	call <SID>X("pythonStatement", s:purple, "", "")
	call <SID>X("pythonConditional", s:purple, "", "")
	call <SID>X("pythonFunction", s:blue, "", "")

	" JavaScript Highlighting
	"call <SID>X("javaScriptBraces", s:white, "", "")
  call <SID>X("javaScriptFunction", s:brown, "", "")
  call <SID>X("javaScriptNumber", s:yellow, "", "")
	"call <SID>X("javaScriptConditional", s:purple, "", "")
	"call <SID>X("javaScriptRepeat", s:purple, "", "")
	"call <SID>X("javaScriptNumber", s:orange, "", "")
	"call <SID>X("javaScriptMember", s:orange, "", "")

	" HTML Highlighting
	call <SID>X("htmlTag", s:orange, "", "")
	call <SID>X("htmlEndTag", s:orange, "", "")
	call <SID>X("htmlTagName", s:orange, "", "")
	call <SID>X("htmlArg", s:brown, "", "")
	call <SID>X("htmlScriptTag", s:orange, "", "")

	" Diff Highlighting
	call <SID>X("diffAdded", s:green, "", "")
	call <SID>X("diffRemoved", s:red, "", "")

  call <SID>X("VimwikiHeader1", s:wikired, "", "")
  call <SID>X("VimwikiHeader2", s:wikiorange, "", "")
  call <SID>X("VimwikiHeader3", s:wikiyellow, "", "")
  call <SID>X("VimwikiHeader4", s:wikiaqua, "", "")
  call <SID>X("VimwikiHeader5", s:wikigreen, "", "")
  call <SID>X("VimwikiHeader6", s:wikiblue, "", "")

	" Delete Functions
	delf <SID>X
	delf <SID>rgb
	delf <SID>colour
	delf <SID>rgb_colour
	delf <SID>rgb_level
	delf <SID>rgb_number
	delf <SID>grey_colour
	delf <SID>grey_level
	delf <SID>grey_number
endif

