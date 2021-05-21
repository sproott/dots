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


" Go to homescreen
nnoremap <leader>s :Startify<CR>
" Toggle Goyo
nnoremap <leader>G :Goyo<CR>
" Open terminal
nnoremap <leader>t :term<CR>
nnoremap <leader><leader> :FloatermToggle<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <S-Esc> <Esc>
" Reload file
nnoremap <leader>R :edit<CR>
" Apply config
nnoremap <leader>A :source %<CR>
" Install plugins
nnoremap <leader>P :PlugInstall<CR>

command! W SudoWrite

