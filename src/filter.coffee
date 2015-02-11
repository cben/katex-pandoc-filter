# Pandoc json->json filter.
# Assumes katex.css was loaded in html, e.g. by `-H head.html`.

katex = require('katex')
Promise = require('promise')

# TODO: could get rid of promises - unlike MathJax, KaTeX is synchronous.

tex2html = (tex, inline) ->
  new Promise (resolve) ->
    if not inline
      tex = '\\displaystyle {' + tex + '}'
    try
      html = katex.renderToString(tex)
      resolve(html)
    catch error
      console.error('katex-pandoc-filter:', tex, ' -> ', error.toString())
      resolve('[Math error: ' + error + ']')

walkChildren = (children) ->
  Promise.all children.map (childnode) ->
    walkTree(childnode)

walkTree = (node) ->
  if node.t=="Math"
    inline=node.c[0].t!='DisplayMath'
    tex=node.c[1]
    tex2html(tex, inline).then (html) ->
      t:"RawInline"
      c:["html",html]
  else
    if node.c? and typeof node.c is 'object'
      walkChildren(node.c).then (c) ->
        t: node.t
        c: c
    else
      Promise.resolve(node)

process.stdin.setEncoding('utf8')
jsondata = ""
process.stdin.on 'data', (data) ->
  jsondata+=data
process.stdin.on 'end', () ->
  data=JSON.parse(jsondata)
  if data?
    walkChildren data[1]
    .then (trans) ->
      data[1]=trans
      console.log(JSON.stringify(data))
