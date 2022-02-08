" vim-modefiles - Avoid gunking up your files with modelines
" Maintainer:   Jer Wilson <superjer@superjer.com>
" URL:          https://github.com/superjer/vim-modefiles
" Version:      0.8
"
" License:
" Copyright Jer Wilson. Distributed under the same terms as Vim itself.
" See :help license
"
" Installation:
" Put this file in your ~/.vim/plugin dir or, if you use a bundler, clone
" https://github.com/superjer/vim-modefiles to your bundles dir.
"
" Description:
" Modefiles are like modelines (see :h modeline), but without putting crap in
" every file. Simply use :Set instead of :set to make option(s) sticky to the
" current file.
"
" :Set option ...      Set options now & in the future when this file is opened
" :Set                 View the currently :Set options
" :Set! option ...     Like :Set but clear any previously saved options
" :Set!                Edit file containing your :Set options in a new window
"
" When reopening a file, your :Set options will be reloaded automatically.
" All errors are silently ignored! This should prevent problems when moving to
" an older version of Vim. To check for errors, source the modefile yourself:
"
" :Set!
" :source %
"
" To specify the directory for saving modefiles, add to your .vimrc:
"   let g:modefilesdir = 'your/own/dir'
" The default is '~/.vim/modefiles' and will be created automatically.
"
" To use a command other than :split with the :Set! command, do this:
"   let g:modefileseditcmd = 'vsplit'
"

if exists("g:loaded_modefiles")
  finish
endif
let g:loaded_modefiles = 1

command! -nargs=* -complete=option -bang Set call s:Set(<bang>0,<q-args>)

if !exists("g:modefilesdir")
  let g:modefilesdir = '~/.vim/modefiles'
endif

if !exists("g:modefileseditcmd")
  let g:modefileseditcmd = 'split'
endif

func! s:GetModeFile()
  let modefile = substitute(expand('%:p'),'/','~','g')
  if !len(modefile) | return '' | endif
  let modefile = expand(g:modefilesdir . '/' . modefile)
  return modefile
endfunc

func! s:Set(bang,args)
  let modefile = s:GetModeFile()
  let args = split(a:args,'\v\s+')
  let setus = ''
  for arg in args
    let opt = substitute(arg,'\v(^inv|^no|[-:=?!+^&<].*)','','g')
    if !exists('&'.opt)
      echo (len(opt) ? opt : arg) . ' is not an option, skipping it'
    else
      let setus .= ' ' . arg
    endif
  endfor

  if a:args == ''
    if a:bang && len(modefile)
      exec g:modefileseditcmd . ' ' . modefile | return
    elseif filereadable(modefile)
      echo "--- Modefile contents ---\n" . join(readfile(modefile),"\n") | return
    endif
    echo "No modefile is available for this buffer"
    return
  endif

  if !len(setus) | echo "No changes made" | return | endif
  let setus = "setlocal" . setus

  exec setus
  if !len(modefile) | echo 'Option(s) set, but this buffer has no file name' | return | endif
  if exists('*mkdir') | silent! call mkdir(expand(g:modefilesdir),"p") | endif
  exe "redir! " . (a:bang ? "> " : ">> ") . modefile
  silent echo setus
  redir END
endfunc

au BufReadPost * call s:GetSet()
func! s:GetSet()
  let modefile = s:GetModeFile()
  if filereadable(modefile)
    exe "silent! source " . modefile
  endif
endfunc

