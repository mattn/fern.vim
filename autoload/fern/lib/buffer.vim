let s:Opener = vital#fern#import('Vim.Buffer.Opener')

function! fern#lib#buffer#replace(bufnr, content) abort
  let modified_saved = getbufvar(a:bufnr, '&modified')
  let modifiable_saved = getbufvar(a:bufnr, '&modifiable')
  try
    call setbufvar(a:bufnr, '&modifiable', 1)
    call setbufline(a:bufnr, 1, a:content)
    call deletebufline(a:bufnr, len(a:content) + 1, '$')
  finally
    call setbufvar(a:bufnr, '&modifiable', modifiable_saved)
    call setbufvar(a:bufnr, '&modified', modified_saved)
  endtry
endfunction

function! fern#lib#buffer#open(bufname, ...) abort
  let options = extend({
        \ 'opener': 'edit',
        \ 'mods': '',
        \ 'cmdarg': '',
        \ 'locator': 0,
        \}, a:0 ? a:1 : {},
        \)
  if options.opener ==# 'select'
    let options.opener = 'edit'
    if fern#lib#window#select()
      return
    endif
  else
    if options.locator
      call fern#lib#window#locate()
    endif
  endif
  return s:Opener.open(a:bufname, {
        \ 'opener': options.opener,
        \ 'mods': options.mods,
        \ 'cmdarg': options.cmdarg,
        \})
endfunction
