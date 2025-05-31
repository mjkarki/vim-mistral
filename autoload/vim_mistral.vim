let s:plugin_path = resolve(expand('<sfile>:p:h') . '/..')

function! vim_mistral#Chat(system_prompt, prompt, model)
    try
python3 << EOL

import sys
lib_path = vim.eval('s:plugin_path')
sys.path.insert(0, lib_path)
import py3.vim_mistral as mistral

system_prompt   = vim.eval('a:system_prompt')
prompt          = vim.eval('a:prompt')
model           = vim.eval('a:model')
temperature     = vim.eval('g:mistral_temperature')
model_online    = vim.eval('g:mistral_model_online')
model_local     = vim.eval('g:mistral_model_local')

response = mistral.chat(system_prompt, prompt, model, temperature, model_online, model_local)

vim.command(f'let l:response = "{response}"')

EOL
    return l:response
    catch /.*/
        echohl WarningMsg
        echomsg v:exception
        echohl None
    endtry
endfunction

function! vim_mistral#Edit(is_range, system_prompt, prompt, model, is_new_buffer)
    try
        echomsg "Mistral is processing: " . a:prompt . "..."
        let l:t_backup = @t
        if a:is_range
            silent! normal! gv"ty

            let @t = vim_mistral#Chat(a:system_prompt, a:prompt . ":\n" . @t, a:model)
            if @t == "0"
                return
            endif

            if a:is_new_buffer
                horizontal new
                setlocal buftype=nofile bufhidden=hide noswapfile
            endif
            if a:is_new_buffer
                silent! put t
            else
                silent! normal! gv"tp
            endif
        else
            let @t = vim_mistral#Chat(a:system_prompt, a:prompt, a:model)
            if @t == "0"
                return
            endif

            if a:is_new_buffer
                horizontal new
                setlocal buftype=nofile bufhidden=hide noswapfile
            endif
            silent! put t
        endif
    finally
        let @t = l:t_backup
        echo
    endtry
endfunction

