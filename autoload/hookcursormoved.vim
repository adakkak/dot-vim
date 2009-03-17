" hookcursormoved.vim
" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-10-04.
" @Last Change: 2007-11-19.
" @Revision:    0.3.184

if &cp || exists("loaded_hookcursormoved_autoload")
    finish
endif
let loaded_hookcursormoved_autoload = 3


augroup HookCursorMoved
    autocmd!
augroup END


function! s:RunHooks(mode, condition) "{{{3
    if !exists('b:hookcursormoved_'. a:mode .'_'. a:condition)
        return
    endif
    if !exists('b:hookcursormoved_synname')
        let b:hookcursormoved_synname = ''
        let b:hookcursormoved_synpos  = []
    endif
    if !exists('b:hookcursormoved_char')
        let b:hookcursormoved_char     = ''
        let b:hookcursormoved_charpos  = []
    endif
    let b:hookcursormoved_currpos = getpos('.')
    " TLogVAR a:condition, g:hookcursormoved_{a:condition}
    if call(g:hookcursormoved_{a:condition}, [a:mode])
        let hooks = b:hookcursormoved_{a:mode}_{a:condition}
        for HookFn in hooks
            " TLogVAR HookFn
            try
                keepjumps keepmarks call call(HookFn, [a:mode])
            catch
                echohl Error
                echom v:errmsg
                echohl NONE
            endtry
            call setpos('.', b:hookcursormoved_currpos)
            unlet HookFn
        endfor
    endif
    let b:hookcursormoved_oldpos = b:hookcursormoved_currpos
endf


function! hookcursormoved#Enable(condition) "{{{3
    if !exists('b:hookcursormoved_enabled')
        let b:hookcursormoved_enabled = []
    endif
    if index(b:hookcursormoved_enabled, a:condition) == -1
        exec 'autocmd HookCursorMoved CursorMoved  <buffer> call s:RunHooks("n", '. string(a:condition) .')'
        exec 'autocmd HookCursorMoved CursorMovedI <buffer> call s:RunHooks("i", '. string(a:condition) .')'
        call add(b:hookcursormoved_enabled, a:condition)
    endif
endf


" :def: function! hookcursormoved#Register(condition, fn, ?mode='ni')
function! hookcursormoved#Register(condition, fn, ...) "{{{3
    let modes = a:0 >= 1 ? a:1 : 'ni'
    " TLogVAR a:condition, a:fn, mode
    " TLogDBG exists('*hookcursormoved#Test_'. a:condition)
    if exists('g:hookcursormoved_'. a:condition)
        call hookcursormoved#Enable(a:condition)
        for mode in split(modes, '\ze')
            if stridx(mode, 'i') != -1
                let var = 'b:hookcursormoved_i_'. a:condition
            endif
            if stridx(mode, 'n') != -1
                let var = 'b:hookcursormoved_n_'. a:condition
            endif
            if !exists(var)
                let {var} = [a:fn]
            else
                call add({var}, a:fn)
            endif
        endfor
    else
        throw 'hookcursormoved: Unknown condition: '. string(a:condition)
    endif
endf


function! hookcursormoved#Test_linechange(mode) "{{{3
    return exists('b:hookcursormoved_oldpos')
                \ && b:hookcursormoved_currpos[1] != b:hookcursormoved_oldpos[1]
endf


function! hookcursormoved#Test_parenthesis(mode) "{{{3
    return s:CheckChars(a:mode, '(){}[]')
endf


function! hookcursormoved#Test_parenthesis_round(mode) "{{{3
    return s:CheckChars(a:mode, '()')
endf


function! hookcursormoved#Test_parenthesis_round_open(mode) "{{{3
    return s:CheckChars(a:mode, '(')
endf


function! hookcursormoved#Test_parenthesis_round_close(mode) "{{{3
    return s:CheckChars(a:mode, ')')
endf


function! hookcursormoved#Test_syntaxchange(mode) "{{{3
    let syntax = s:SynId(a:mode, b:hookcursormoved_currpos)
    if exists('b:hookcursormoved_syntax')
        let rv = b:hookcursormoved_syntax != syntax
    else
        let rv = 0
    endif
    let b:hookcursormoved_syntax = syntax
    return rv
endf


function! hookcursormoved#Test_syntaxleave(mode) "{{{3
    let syntax = s:SynId(a:mode, b:hookcursormoved_oldpos)
    let rv = b:hookcursormoved_syntax != syntax && index(b:hookcursormoved_syntaxleave, syntax) != -1
    let b:hookcursormoved_syntax = syntax
    return rv
endf


function! hookcursormoved#Test_syntaxleave_oneline(mode) "{{{3
    if exists('b:hookcursormoved_oldpos')
        let syntax = s:SynId(a:mode, b:hookcursormoved_oldpos)
        " TLogVAR syntax
        if exists('b:hookcursormoved_syntax') && !empty(syntax)
            " TLogVAR b:hookcursormoved_syntax, syntax
            let rv = b:hookcursormoved_currpos[1] != b:hookcursormoved_oldpos[1]
            " TLogVAR rv, b:hookcursormoved_currpos[1], b:hookcursormoved_oldpos[1]
            if !rv && b:hookcursormoved_syntax != syntax
                let rv = index(b:hookcursormoved_syntaxleave, syntax) != -1
            endif
            " TLogVAR rv
        else
            let rv = 1
        endif
        let b:hookcursormoved_syntax = syntax
        " TLogVAR rv
        return rv
    endif
    return 0
endf


function! s:Col(mode, col) "{{{3
    " let co = a:col - 1
    let co = a:col
    if a:mode == 'i' && co > 1
        let co -= 1
    endif
    " TLogVAR co
    " TLogDBG getline('.')[co - 1]
    return co
endf


function! s:CheckChars(mode, chars) "{{{3
    if b:hookcursormoved_charpos != b:hookcursormoved_currpos
        let ln = b:hookcursormoved_currpos[1]
        let cn = b:hookcursormoved_currpos[2]
        let li = getline(ln)
        let co = s:Col(a:mode, cn)
        let b:hookcursormoved_char = li[co - 1]
        let b:hookcursormoved_charpos = b:hookcursormoved_currpos
    endif
    let rv = !empty(b:hookcursormoved_char) && stridx(a:chars, b:hookcursormoved_char) != -1
    " TLogVAR a:mode, li, co, rv, b:hookcursormoved_char
    return rv
endf


function! s:SynId(mode, pos) "{{{3
    if a:pos != b:hookcursormoved_synpos
        let li = a:pos[1]
        let co = s:Col(a:mode, a:pos[2])
        " let synid = synID(li, co, 1)
        let synid = synID(li, co, 0)
        let b:hookcursormoved_synname = synIDattr(synid, 'name')
        let b:hookcursormoved_synpos  = a:pos
        " TLogVAR li, co, synid, b:hookcursormoved_synname
        " TLogDBG synID(li, co, 0)
    endif
    return b:hookcursormoved_synname
endf

