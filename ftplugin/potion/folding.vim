echom 'Fold Levels:'

function! GetPotionFoldLevel(lnum)
	let lineText = 'Line ' . a:lnum . ' ='

	" If the line is blank, return -1.
	if getline(a:lnum) =~? '\v^\s*$' " See NOTE 1
		"echom 'line ' . a:lnum . ' = -1'
		echom lineText '-1 blank'
		return '-1'
	endif

	" Get indent level of this line and the next non-blank line...
	let this_indent = IndentLevel(a:lnum)
	let next_indent = IndentLevel(NextNonBlankLine(a:lnum)) " See NOTE 2

	" Compare the indentlevel of the current line with that of the next
	" non-blank line in order to decide how to fold the current line.
	"
	" If both lines have the same indentation level, return that level
	" as the foldlevel!
	if next_indent == this_indent
		echom lineText this_indent '='
		return this_indent
	" If the next line has an indentation level that's less than that
	" of the current line, return the level of the current line as the
	" foldlevel.
	elseif next_indent < this_indent
		echom lineText this_indent '<'
		return this_indent
	" This is the case that Vim gets wrong that's our whole purpose in
	" writing this custom folding code!
	" If the next line has an indentation level that's greater than that
	" of the current line, return the level of the next line prepended
	" with '>' as the foldlevel.
	elseif next_indent > this_indent
		echom lineText next_indent '>'
		return '>' . next_indent " See NOTE 3
	endif
endfunction

" Calculate the indentation level for non-blank lines...
function! IndentLevel(lnum)
	return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
	let numlines = line('$') " See :h line()
	let i = a:lnum + 1

	" Walk through each subsequent line in the file...
	while i <= numlines
		if getline(i) =~? '\v\S' " If any character in the string is non-whitespace
			return i             " then we've found it, so return that line number!
		endif

		let i += 1
	endwhile

	" We use -2 to indicate a failure to find a non-blank line, since '0' and
	" -1 already have special meaning with regard to foldlevel code, although
	"  we could use either of those in this context if we really want to.
	return -2 " Arbitrary error code that's easy to spot visually.
endfunction

" Define the expression used to figure out the foldlevel of a line...
setlocal foldexpr=GetPotionFoldLevel(v:lnum)

" Let's use expression folding instead...
setlocal foldmethod=expr


" NOTE 1
" Match lines containing nothing or whitespace only (blank lines):

" getline(a:lnum) - Return the text of the current line.

" =~?             - Case-insensitive comparison.
"                   We could just use =~ since we're only matching on whitespace.

" '\v^\s*$'       - \v  - A very magic RegEx matching...
"                   ^   - the beginning of a line
"                   \s* - followed by 0 or more (*) whitespace characters (\s)
"                         (See :h /star (0 or more) versus :h /\+ (1 or more))
"                   $   - and then the end of the line.

" NOTE 2
" If NextNonBlankLine returns -2, then next_indent gets set
" to 0. This may seem like a problem, but it's not.
" We can verify this by running this command...
" :echo IndentLevel(-2)
"
" The way it works is that IndentLevel() takes that -2 and passes it to
" indent() which returns -1. Verify like this...
" :echo indent(-2)
"
" It then divides that -1 by &shiftwidth. -1 divided by any shiftwidth
" larger than 1 will return 0. Verify...
" :echo -1 / &shiftwidth

" NOTE 3
" Returning the indentation of the next line prepended with '>' gives
" us something like this...
" >1
" This is another one of Vim's "special" foldlevels. See :h fold-expr
" It tells Vim that "a fold with this level starts at this line".
" Remember, this is effectively saying something like...
" :setlocal foldexpr=>1
" ...i.e., a fold with the level of 1 starts at this line, even though
" this line itself only has an indentation level of 0.
" 
"

" INITIAL CODE
" When we started this file, it was the below simple code:
" But nah, let's not use indent folding...
" setlocal foldmethod=indent

" Although when we *were* using indent folding...
" By default Vim will ignore lines beginning with a # character when using indent
" folding. Therefore, our indented block in our factorial.pn file where the first
" line is commented (i.e., starts with a # character) will not fold because it gets
" ignored. However, we can locally set 'foldignore' to nothing in order to tell Vim
" that we don't want it to ignore anything when doing folding.
" setlocal foldignore=
" We comment out the line above because it's only relevant when using indent folding.

