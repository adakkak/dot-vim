"==================================================
" File:         code_complete.vim
" Brief:        complete code, and much more.
" Author:       Mingbai <mbbill AT gmail DOT com>
" Last Change:  2007-01-05 11:45:49
" Version:      2.1
"
" Install:      1. Put code_complete.vim to plugin 
"                  directory.
"               2. Use the command below to create tags 
"                  file including signature field.
"                  ctags --fields=+S .
"
" Usage:        
"               
"==================================================

" Variable Definations: {{{1
let s:expanded=0  "in case of insert char after expanded
let s:rs='`'    "region start
let s:re='`'    "region stop
let s:signature_list=[]

" Autocommands: {{{1
autocmd BufReadPost * call CodeCompleteStart()

" Menus:
menu <silent>       &Tools.Code\ Complete\ Start          :call CodeCompleteStart()<CR>
menu <silent>       &Tools.Code\ Complete\ Stop           :call CodeCompleteStop()<CR>

" Function Definations: {{{1

function! CodeCompleteStart()
    silent! iunmap  <buffer>    <c-tab>
    inoremap        <buffer>    <c-tab>   <c-r>=ExpandTemplate()<cr><c-r>=SwitchRegion('<c-tab>')<cr>
    " someone might have mapped <space> to / or others
    silent! sunmap  <buffer>    <space>
endfunction

function! CodeCompleteStop()
    silent! iunmap      <buffer>    (
    silent! iunmap      <buffer>    <c-tab>
endfunction

function! FunctionComplete()
    let fun=substitute(getline('.')[:(col('.')-1)],'\zs.*\W\ze\w*$','','g') " get function name
    let ftags=taglist(fun)
    if type(ftags)==type(0) || ((type(ftags)==type([])) && ftags==[])
        return '('
    endif
    let s:signature_list=[]
    for i in ftags
        if has_key(i,'kind') && has_key(i,'name') && has_key(i,'signature')
            if (i.kind=='p' || i.kind=='f') && i.name==fun  " p is declare, f is defination
                let tmp=substitute(i.signature,',',s:re.','.s:rs,'g')
                let tmp=substitute(tmp,'(\(.*\))','('.s:rs.'\1'.s:re.');','g')
                let item={}
                let item['word']=tmp
                "let item['menu']=i.filename
                if index(s:signature_list,item)==-1
                    let s:signature_list+=[item]
                endif
            endif
        endif
    endfor
    if s:signature_list==[]
        return '('
    endif
    if len(s:signature_list)==1
        return s:signature_list[0]['word']
    else
        call  complete(col('.'),s:signature_list)
        return ''
    endif
endfunction

function! SwitchRegion(key)
    if len(s:signature_list)>1
        let s:signature_list=[]
        return ''
    endif
    if match(getline('.'),s:rs.'.*'.s:re)!=-1 || search(s:rs.'.\{-}'.s:re)!=0
        let s:expanded=0
        normal 0
        call search(s:rs,'c',line('.'))
        normal v
        call search(s:re,'e',line('.'))
        return "\<c-\>\<c-n>gvo\<c-g>"
    else
        if s:expanded==1
            let s:expanded=0
            return ''
        else
            return a:key
        endif
    endif
endfunction

function! ExpandTemplate()
    let cword = substitute(getline('.')[:(col('.')-2)],'\zs.*\W\ze\w*$','','g')
    if has_key(g:template,&ft)
        if has_key(g:template[&ft],cword)
            let s:expanded=1  "in case of insert char after expanded
            return "\<C-W>" . g:template[&ft][cword]
        endif
    endif
    if has_key(g:template['_'],cword)
        let s:expanded=1
        return "\<C-W>" . g:template['_'][cword]
    endif
    return ""
endfunction

" [Get converted file name like __THIS_FILE__ ]
function! GetFileName()
    let filename=expand("%:t")
    let filename=toupper(filename)
    let _name=substitute(filename,'\.','_',"g")
    let _name="__"._name."__"
    return _name
endfunction

" Templates: {{{1
" C templates
let g:template = {}
let g:template['c'] = {}
let g:template['c']['c'] = "/*  */\<left>\<left>\<left>"
let g:template['c']['d'] = "#define  "
let g:template['c']['i'] = "#include  \"\"\<left>"
let g:template['c']['ii'] = "#include  <>\<left>"
let g:template['c']['f'] = "#ifndef  \<c-r>=GetFileName()\<cr>\<CR>#define  \<c-r>=GetFileName()\<cr>".
            \repeat("\<cr>",5)."#endif  /*\<c-r>=GetFileName()\<cr>*/".repeat("\<up>",3)
let g:template['c']['for'] = "for( ".s:rs."...".s:re." ; ".s:rs."...".s:re." ; ".s:rs."...".s:re." )\<cr>{\<cr>".
            \s:rs."...".s:re."\<cr>}\<cr>"
" common templates
let g:template['_'] = {}
let g:template['_']['xt'] = "\<c-r>=strftime(\"%Y-%m-%d %H:%M:%S\")\<cr>"


" vim: set ft=vim ff=unix fdm=marker :
