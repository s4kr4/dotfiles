" --------------------------------------------------------------------
"  sjl/badwolf
" --------------------------------------------------------------------

if dein#is_sourced('badwolf')
  " Determines whether the line number, sign column, and fold column are
  " rendered darker than the normal background, or the same.
  let g:badwolf_darkgutter = 0
  
  " Determines how light to render the background of the tab line (the line at
  " the top of the screen containing the various tabs (only in console mode)).
  let g:badwolf_tabline = 1
  
  " Determines whether text inside a tags in HTML files will be underlined.
  let g:badwolf_html_link_underline = 1
  
  " Determines whether CSS properties should be highlighted.
  let g:badwolf_css_props_highlight = 1
endif
