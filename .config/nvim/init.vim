call plug#begin(stdpath('data') . '/plugged')

Plug 'nvim-lua/plenary.nvim' " utility functions for telescope
Plug 'nvim-telescope/telescope.nvim' " fuzy finder ( alternative for fzf, interacts with tree sitter )

Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " C implementation of fzf algo for telescope
Plug 'nvim-telescope/telescope-file-browser.nvim' " telescope file explorer, was builtin before, now as plugin


"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " code parser and code query tool, provides smart synatx highlighting
Plug 'nvim-treesitter/nvim-treesitter' " code parser and code query tool, provides smart synatx highlighting
Plug 'neovim/nvim-lspconfig' " deault configurations for LSP

Plug 'vim-test/vim-test' " test runner

Plug 'dracula/vim',{'as':'dracula'} " dracula color scheme

Plug 'sebdah/vim-delve'

" COQ - completion plugin
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" 9000+ Snippets fo COQ
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

call plug#end()

colorscheme dracula

lua <<EOF
-- init telescope with native ( c version ) of fzf
require('telescope').setup {
  extensions = {
	fzf = {
	  fuzzy = true,                    -- false will only do exact matching
	  override_generic_sorter = true,  -- override the generic sorter
	  override_file_sorter = true,     -- override the file sorter
	  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
									   -- the default case_mode is "smart_case"
	}
  },
  pickers = {
    buffers = {
        mappings = {
            i = {
                ["<c-d>"] = "delete_buffer"
            }
        }
    },
    find_files = {
        preview = true 
    }
  }
}
require('telescope').load_extension('fzf')
require("telescope").load_extension "file_browser"

-- configure treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    --    disable = { "c", "rust" },  -- list of language that will be disabled
     additional_vim_regex_highlighting = false,
  },
}

-- enable LSP for go 
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

local coq = require "coq"

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'gopls', 'phpactor', 'vuels' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }))
end

nvim_lsp.yamlls.setup{
    on_attach=on_attach,
    settings = {
        yaml = {
         schemas = {
           ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.22.3-standalone-strict/all.json"] = "*.yaml",
          }
        }
    }
}
EOF
" ------
" END OF LUA
" ------


let mapleader = ","
" remap esc to jk, better than moving way to the corner
inoremap jk <esc>

" Telescope mappings
nnoremap <leader>f :Telescope find_files<cr>
nnoremap <leader>F :Telescope file_browser<cr>
nnoremap <leader>b :lua require'telescope.builtin'.buffers{}<cr>
nnoremap <leader>s :lua require'telescope.builtin'.lsp_document_symbols{}<cr>
nnoremap <leader>S :lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{}<cr>
nnoremap <leader>g :lua require'telescope.builtin'.live_grep{}<cr>

" hide autocomplete scratch window when completion is done
autocmd CompleteDone * if pumvisible() == 0 | pclose | endif

" Move lines up down
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" quick fix navigation
nnoremap [q :cp<cr>
nnoremap ]q :cn<cr>

" vim-test mappings
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
" use colorized go test
if executable('gotest')
    let test#go#gotest#executable = 'gotest'
endif

" set replacements for whitespaces
" show with :set list / :set nolist
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" auto insert tabs/spaces on new line
set autoindent

" intuitive behaviour of backspace
set backspace=indent,eol,start
set smarttab

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" show line numbers relative to cursor
set relativenumber

set history=1000

" show at least n lines at edges of window
set scrolloff=5

" dont show preview buffer on omnifunc
set completeopt-=preview


function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:Scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file scratch
endfunction
com! Scratch call s:Scratch()
