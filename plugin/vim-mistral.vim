if !has('python3')
    echohl WarningMsg
    echomsg  "Python 3 support is required for vim-mistral plugin!"
    echohl None
    finish
endif

if exists('g:vim_mistral')
    finish
endif

let g:vim_mistral = 1

if !exists('g:mistral_model')
    let g:mistral_model = "online"
endif

if !exists('g:mistral_model_online')
    let g:mistral_model_online = "mistral-large-latest"
endif

if !exists('g:mistral_model_local')
    let g:mistral_model_local = "mistral"
endif

if !exists('g:mistral_temperature')
    let g:mistral_temperature = 0.2
endif

let s:separator = "\n####\n"
let s:mistral_assist_header = "You are an assistant. Answer concisely and only
            \ what you are asked. Do not provide any explanation or comments.
            \ If the answer is source code, do not use markdown syntax."
let s:mistral_code_review_header = "You are a code reviewer. Do not provide
            \ revised code."

command! -nargs=+ -range Medit call vim_mistral#Edit(<range>, <q-args>,
            \ s:separator, s:mistral_assist_header, g:mistral_model, v:false)
command! -nargs=+ -range Massist call vim_mistral#Edit(<range>, <q-args>,
            \ s:separator, s:mistral_assist_header, g:mistral_model, v:true)
command! -nargs=+ -range Mask call vim_mistral#Edit(<range>, <q-args>, "", "",
            \ g:mistral_model, v:true)
command! -nargs=+ -range Mcr if <range> | call vim_mistral#Edit(<range>,
            \ <q-args>, s:separator, s:mistral_code_review_header,
            \ g:mistral_model, v:true) | endif

if !exists('g:mistral_disable_mappings')
    vnoremap <silent> <leader>mg :Medit Fix grammar and spelling<CR>
    vnoremap <silent> <leader>mt :Massist Translate to Finnish<CR>
    vnoremap <silent> <leader>ms :Massist Translate to English<CR>
                \ggVG:Medit Summarize the text using bullet points<CR>
    vnoremap <silent> <leader>mc :Mcr Perform code review and list
                \ possible errors and improvement suggestions<CR>

    nmap <silent> <leader>mg ggVG<leader>mg
    nmap <silent> <leader>mt ggVG<leader>mt
    nmap <silent> <leader>ms ggVG<leader>ms
    nmap <silent> <leader>mc ggVG<leader>mc
endif

