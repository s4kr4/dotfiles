augroup filetypedetect
  autocmd!
  autocmd BufRead,BufNewFile *.coffee setfiletype coffee
  autocmd BufRead,BufNewFile *.html setfiletype html
  autocmd BufRead,BufNewFile *.jade setfiletype pug
  autocmd BufRead,BufNewFile *.js setfiletype javascript
  autocmd BufRead,BufNewFile *.json setfiletype json
  autocmd BufRead,BufNewFile *.md setfiletype markdown
  autocmd BufRead,BufNewFile *.php setfiletype php
  autocmd BufRead,BufNewFile *.pug setfiletype pug
  autocmd BufRead,BufNewFile *.py setfiletype python
  autocmd BufRead,BufNewFile *.rb setfiletype ruby
  autocmd BufRead,BufNewFile *.slim setfiletype slim
  autocmd BufRead,BufNewFile *.ts setfiletype typescript
  autocmd BufRead,BufNewFile *.twig setfiletype html
  autocmd BufRead,BufNewFile *.vim setfiletype vim
augroup END
