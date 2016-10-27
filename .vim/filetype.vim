augroup filetypedetect
  au BufRead,BufNewFile *.rb setfiletype ruby
  au BufRead,BufNewFile *.py setfiletype python
  au BufRead,BufNewFile *.php setfiletype php
  au BufRead,BufNewFile *.js setfiletype javascript
  au BufRead,BufNewFile *.coffee setfiletype coffee
  au BufRead,BufNewFile *.slim setfiletype slim
  au BufRead,BufNewFile *.vim setfiletype vim
augroup END
