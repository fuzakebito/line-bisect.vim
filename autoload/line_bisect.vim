nnoremap <Plug>(hl_bisect) <Cmd>call <SID>unplace_sign()<CR>

function! line_bisect#start(range) abort
  call s:unplace_sign()
  if a:range == 'screen'
    let s:range = #{
          \   top: line('w0'),
          \   bot: line('w$'),
          \   mid: float2nr((line('w0')+line('w$'))/2)
          \ }
  else
    let s:range = a:range
  endif
  execute 'normal! ' . s:range.mid . 'G'
  call s:place_sign()
endfunction

function! line_bisect#up() abort
  call s:unplace_sign()
  if s:range.mid - s:range.top > 0
    let s:range.bot = s:range.mid - 1
    let s:range.mid = float2nr((s:range.top + s:range.bot)/2)
    execute 'normal! ' . s:range.mid . 'G'
  endif
    call s:place_sign()
endfunction

function! line_bisect#down() abort
  call s:unplace_sign()
  if s:range.bot - s:range.mid > 0
    let s:range.top = s:range.mid + 1
    let s:range.mid = float2nr((s:range.top + s:range.bot)/2)
    execute 'normal! ' . s:range.mid . 'G'
  endif
    call s:place_sign()
endfunction

function! s:place_sign() abort
  let s:id = 0
  for l:line in range(line('w0'), line('w$'))
    let s:id += 1
    if l:line >= s:range.top && l:line < s:range.mid
      exe 'sign place ' . s:id . ' group=line_bisect line=' . l:line . ' name=line_bisect_up file=' . expand('%:p')
    elseif l:line == s:range.mid
      exe 'sign place ' . s:id . ' group=line_bisect line=' . l:line . ' name=line_bisect_mid file=' . expand('%:p')
    elseif l:line <= s:range.bot && l:line > s:range.mid
      exe 'sign place ' . s:id . ' group=line_bisect line=' . l:line . ' name=line_bisect_down file=' . expand('%:p')
    else
      exe 'sign place ' . s:id . ' group=line_bisect line=' . l:line . ' name=line_bisect_blank file=' . expand('%:p')
    endif
  endfor
endfunction

function! s:unplace_sign() abort
  if exists('s:id')
    for l:id in range(1, s:id)
      exe 'sign unplace ' . l:id . ' group=line_bisect'
    endfor
  endif
endfunction
