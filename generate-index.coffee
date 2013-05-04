fs = require 'fs'
parser = require './.chords-processor/lib/parsers/chord_parser'

json = (path)->
  src = fs.readFileSync path, 'utf8'
  p = new parser.Parser(src)
  p.processDirectives()
  title: p.attributes.title, author: p.attributes.author, path: path

jsons = []
processDir = (dir)->
  fs.readdirSync(dir).forEach (f)->
    return if f[0] is '.'
    ff = "#{dir}/#{f}"
    (processDir ff; return) if fs.lstatSync(ff).isDirectory()
    jsons.push json ff

dirs = fs.readdirSync('.').filter (f)-> f[0] isnt '.' and fs.lstatSync(f).isDirectory()
dirs.forEach processDir

jsons = jsons.sort((a, b)-> a.path >= b.path and 1 or -1).map (j)-> JSON.stringify j

output = "[\n#{jsons.join ',\n'}\n]"
fs.writeFileSync '.index.json', output, 'utf8'
