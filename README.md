# vim-mistral

A small Vim plugin providing Mistral AI support, either through the online API or locally with Ollama.

## Installation

1. You will need Python 3 and appropriate support for it in Vim (usually, the Python support is already built-in).

2. Use the Vim [plugin manager](https://junegunn.github.io/vim-plug/):

    ```vim
    Plug 'mjkarki/vim-mistral'
    ```

3. Set your [La Plateforme API key](https://console.mistral.ai/api-keys) in your preferred shell configuration file, such as ~/.profile or ~/.zshenv:

    ```sh
    export MISTRAL_API_KEY=<your api key here>
    ```

4. Alternatively, you can use Mistral locally via [Ollama](https://ollama.com/). No API key needed. You have to install Ollama and some [Mistral model](https://ollama.com/search?q=mistral) first. Then set `let g:mistral_model = "local"` in your ~/.vimrc file. Adjust local model name in the variable `g:mistral_model_local` if needed. The default is `mistral`.

5. Define a leader key in your ~/.vimrc. For example: `let mapleader=" "` (the Vim default is `\`)

## Usage

### Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `:Medit` | Any editing instructions | Edit a visual selection in its place. If there is no visual selection, this places the generated text on the next line from the current cursor location. |
| `:Massist` | Any instructions | Works like `:Medit` except instead of modifying the current buffer contents, this will open a new scratch buffer and the answer will be shown there. |
| `:Mcr` | Instructions for code reviewer | Very specific command for code reviewing. |
| `:Mask` | A freeform prompt | A chat. Ask a question, and the answer will be opened in a new scratch buffer. If there is a visual selection, it will be added at the end of the prompt with a `":\n"` separator. Note, this does not have any chat history or remember previous messages. For actual conversations, use [Le Chat](https://chat.mistral.ai/). |

The difference between Medit and Mcr is the prompt template. The first command
uses a prompt that restricts the output to only what is asked for. This is
suitable for in-place editing. The Mcr command gives more freedom to the LLM to
provide an answer in its own words. However, the code review prompt prevents
the LLM from printing out the full revised code, which is very often provided
and usually does not add any value to the feedback. Mask does not have any
prompt template; the prompt from the user is passed on as-is.

### Mappings

Here are few mappings available as examples of how to use this plugin:

```vim
vnoremap <silent> <leader>mg :Medit Fix grammar and spelling<CR>
vnoremap <silent> <leader>mt :Massist Translate to Finnish<CR>
vnoremap <silent> <leader>ms :Massist Translate to English<CR>ggVG:Medit Summarize the text using bullet points<CR>
vnoremap <silent> <leader>mc :Mcr Perform code review and list possible errors and improvement suggestions<CR>
```

These mappings automatically select the whole buffer before calling a mapping listed above.

```vim
nmap <silent> <leader>mg ggVG<leader>mg
nmap <silent> <leader>mt ggVG<leader>mt
nmap <silent> <leader>ms ggVG<leader>ms
nmap <silent> <leader>mc ggVG<leader>mc
```

If you don't want to have any of these mappings, see the global variable descriptions.

## Global Variables

Global variables that can be used to change Mistral AI's behavior:

| Variable                     | Description |
|------------------------------|-------------|
| `g:mistral_model`            | Model type, default: `"online"`. Can be either `"online"` or `"local"` |
| `g:mistral_model_online`     | Online model name, default: `"mistral-large-latest"` |
| `g:mistral_model_local`      | Local model name, default: `"mistral"` |
| `g:mistral_temperature`      | Model temperature, default: `0.2` |
| `g:mistral_disable_mappings` | Set this variable to `1` to disable all default key mappings |

You can set these anywhere in your ~/.vimrc file.

