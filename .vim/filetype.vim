augroup filetypedetect
  autocmd!
  autocmd BufRead,BufNewFile *.rb setfiletype ruby
  autocmd BufRead,BufNewFile *.py setfiletype python
  autocmd BufRead,BufNewFile *.php setfiletype php
  autocmd BufRead,BufNewFile *.js setfiletype javascript
  autocmd BufRead,BufNewFile *.json setfiletype json
  autocmd BufRead,BufNewFile *.coffee setfiletype coffee
  autocmd BufRead,BufNewFile *.ts setfiletype typescript
  autocmd BufRead,BufNewFile *.slim setfiletype slim
  autocmd BufRead,BufNewFile *.jade setfiletype pug
  autocmd BufRead,BufNewFile *.pug setfiletype pug
  autocmd BufRead,BufNewFile *.vim setfiletype vim
  autocmd BufRead,BufNewFile *.twig setfiletype html
augroup END
