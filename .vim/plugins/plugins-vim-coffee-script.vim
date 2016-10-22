" --------------------------------------------------------------------
" vim-coffee-script
" --------------------------------------------------------------------
au BufRead,BufNewFile,BufReadPre *.coffee set filetype=coffee
" インデント設定
autocmd FileType coffee setlocal sw=2 sts=2 ts=2 et
" オートコンパイル
"保存と同時にコンパイルする
autocmd BufWritePost *.coffee silent make! 
"エラーがあったら別ウィンドウで表示
autocmd QuickFixCmdPost * nested cwindow | redraw! 
" Ctrl-cで右ウィンドウにコンパイル結果を一時表示する
nnoremap <silent> <C-C> :CoffeeCompile vert <CR><C-w>h

