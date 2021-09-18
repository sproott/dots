let mapleader = ' '
nnoremap <space> <nop>

" Semicolon as a colon
nmap ; :

" Remap 0 to first non-blank character
map 0 ^

" Reasonable window switching
map <C-j> <Esc><C-w>j
map <C-k> <Esc><C-w>k
map <C-h> <Esc><C-w>h
map <C-l> <Esc><C-w>l

" Split with new buffer
nnoremap <leader>V :vsplit<CR>
nnoremap <leader>H :split<CR>

" Exit insert mode
imap jk <Esc>
imap kj <Esc>

" Disable search highlight
nnoremap <Esc> :nohlsearch<CR>

" Reload file
nnoremap <leader>R :edit<CR>

" CHADTree
nnoremap <leader>n :CHADopen --always-focus<CR>

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" LSP
nnoremap gd :lua vim.lsp.buf.definition()<CR>
nnoremap gr :lua vim.lsp.buf.rename()<CR>
nnoremap gh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>f :lua vim.lsp.buf.formatting()<CR>

