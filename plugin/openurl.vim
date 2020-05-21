" Copyright (c) 2010 Kenko Abe
"
"
" Summary
" =======
" The OprnUrl function opens a url which is a first one in the line
"
" Require
" =======
" You need a python interface.
"
" Usage
" =====
" If there is a line such that
"
" Sample line. http://aaa http://bbb
"
" You use ':OpenUrl' command in this line, 
" then you can open http://aaa in a default web browser.
"
"
"
" I set a command for OpenUrl function, such that
"
" command OpenUrl :call OpenUrl()
" 
" You can change command name by changing above command name 'OpenUrl'.
"
" example)
" command AnotherOpenUrlName :call OpenUrl()
"

let g:OpenUrlPort = "44567"
let g:OpenUrlSearchEngine = "http://www.google.com/search?q="

" define OpenUrl function
function! OpenUrl()
python << EOM
# coding=utf-8

import vim
import re
import subprocess 

re_obj = re.compile(r'(https?|ftp)://[^\s/$.?#].[^\s]*')
line = vim.current.line
port = vim.eval("g:OpenUrlPort")
match_obj = re_obj.search(line)

try:
    url = match_obj.group()
    cmd = "echo \"{}\" | nc localhost {} -q0".format(url, port)
    subprocess.call(cmd, shell=True)
    print 'open URL : %s' % url
except:
    print 'failed! : open URL'
    print "Unexpected error:", sys.exc_info()[0]

EOM
endfunction

function! OpenUrlSearch(term)
python << EOM
# coding=utf-8

import vim
import re
import urllib
import subprocess 

port = vim.eval("g:OpenUrlPort")
search_url = vim.eval("g:OpenUrlSearchEngine")
search_term = vim.eval("a:term")

try:
    full_search_url = "{}{}".format(search_url, urllib.quote_plus(search_term))
    cmd = "echo \"{}\" | nc localhost {} -q0".format(full_search_url, port)
    subprocess.call(cmd, shell=True)
    print 'open URL Search : {}'.format(full_search_url)
except:
    print 'failed! : open URL Search'
    print "Unexpected error:", sys.exc_info()[0]

EOM
endfunction


" set a command for OpenUrl function
command OpenUrl :call OpenUrl()
