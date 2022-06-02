" The if statement at the top and the let statement at the bottom are each
" part of a convention which ensures that this file is not loaded if syntax
" highlighting has already previously been enabled for this buffer.
if exists("b:current_syntax")
    finish
endif


" See :h syn-keyword :h group-name
" It's possible to define multiple keywords on a single line, such that
" you could group related keywords. However, defining only one Potion
" keyword per line is easier to read, and also makes diffs easier to read.
" Besides, 'syntax match' (see below) doesn't support multiple matches on
" a single line anyway, so let's be consistent and define everything one
" at a time on its own line.

" See :h syn-keyword
" Define a syntax group (potionKeyword)
syntax keyword potionKeyword loop
syntax keyword potionKeyword times
syntax keyword potionKeyword to
syntax keyword potionKeyword while 

syntax keyword potionKeyword if
syntax keyword potionKeyword elsif
syntax keyword potionKeyword else

syntax keyword potionKeyword class
syntax keyword potionKeyword return

" Define another syntax group (potionFunction) one Potion function name at a time...
syntax keyword potionFunction print
syntax keyword potionFunction join
syntax keyword potionFunction string

" See :h syn-match :h syn-pattern
" Define another syntax group (potionComment)
syntax match potionComment "\v#.*$"
" Notice here that we use 'syntax match' instead of 'syntax keyword'.
" That's because 'syntax keyword' won't work since # is not in 'iskeyword'.
" Therefore, we have to use 'syntax match' and define a RegEx in order to match a
" comment (which is a # character and everything else that follows it on that line).
"   \v - 'very magic' (not actually needed for hash, but we include it for consistency)
"    # - match this character
"  .*$ - match any character (.) as many times as possible (*) until the end of the line ($)
" In other words, match any line that starts with #

" Define another syntax group (potionOperator)
syntax match potionOperator "\v\*"
syntax match potionOperator "\v/"
syntax match potionOperator "\v\+"
syntax match potionOperator "\v-"
syntax match potionOperator "\v\?"
syntax match potionOperator "\v\="
syntax match potionOperator "\v\*\="
syntax match potionOperator "\v/\="
syntax match potionOperator "\v\+\="
syntax match potionOperator "\v-\="

" Define another syntax group (potionString)
" Losh's code with a . in the skip...
"syntax region potionString start=/\v"/ skip=/\v\\./ end=/\v"/
" Frankly, I believe the skip should have a " instead of a . in it.
" Let's try it...
syntax region potionString start=/\v"/ skip=/\v\\"/ end=/\v"/

" Link the syntax group potionKeyword to the highlighting group Keyword...
highlight link potionKeyword Keyword

" Link the syntax group potionFunction to the highlighting group Function...
highlight link potionFunction Function

" Link the syntax group potionComment to the highlighting group Comment...
highlight link potionComment Comment

" Link the syntax group potionOperator to the highlighting group Operator...
highlight link potionOperator Operator

highlight link potionString String


let b:current_syntax = "potion"

