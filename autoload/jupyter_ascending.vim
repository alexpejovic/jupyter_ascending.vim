function! s:on_stdout(j, d, e)
  if len(a:d) > 0 && len(a:d[0]) > 0
    echom '[JupyterAscending]' a:d
  endif
endfunction

function! s:execute(command_string) abort
  if has('nvim')
    call jobstart(a:command_string, {
          \ 'on_stdout': funcref('s:on_stdout')
          \ })
  else
    call systemlist(a:command_string)
  end
endfunction

function! jupyter_ascending#sync() abort
  let file_name = expand("%:p")
  let ipynb_file_name = substitute(file_name, "py", "ipynb", "")

  if match(file_name, g:jupyter_ascending_match_pattern) < 0
    return
  endif

  let command_string = printf(
        \ "%s -m jupyter_ascending.requests.sync --filename '%s'",
        \ g:jupyter_ascending_python_executable,
        \ file_name
        \ )

  let jupytext_cmd_str = printf(
        \ "jupytext --sync %s",
        \ ipynb_file_name
        \ )

  call s:execute(command_string)
  call s:execute(jupytext_cmd_str)
endfunction

function! jupyter_ascending#execute() abort
  let file_name = expand("%:p")

  if match(file_name, g:jupyter_ascending_match_pattern) < 0
    return
  endif

  let command_string = printf(
        \ "%s -m jupyter_ascending.requests.execute --filename '%s' --linenumber %s",
        \ g:jupyter_ascending_python_executable,
        \ file_name,
        \ line('.')
        \ )

  call s:execute(command_string)
endfunction

function! jupyter_ascending#execute_all() abort
  let file_name = expand("%:p")

  if match(file_name, g:jupyter_ascending_match_pattern) < 0
    return
  endif

  let command_string = printf(
        \ "%s -m jupyter_ascending.requests.execute_all --filename '%s'",
        \ g:jupyter_ascending_python_executable,
        \ file_name
        \ )

  call s:execute(command_string)
endfunction


function! jupyter_ascending#restart() abort
  let file_name = expand("%:p")

  if match(file_name, g:jupyter_ascending_match_pattern) < 0
    return
  endif

  let command_string = printf(
        \ "%s -m jupyter_ascending.requests.restart --filename '%s'",
        \ g:jupyter_ascending_python_executable,
        \ file_name
        \ )

  call s:execute(command_string)
endfunction
