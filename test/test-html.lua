local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestHTML = {}
function TestHTML.test_parse_valid()
  local success, html = pcall(xmlua.HTML.parse, "<html></html>")
  luaunit.assertEquals(success, true)
  luaunit.assertEquals(html:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html></html>
]])
end

function TestHTML.test_parse_invalid()
  local success, html = pcall(xmlua.HTML.parse, "broken tag>")
  luaunit.assertEquals(success, true)
  luaunit.assertEquals(html:to_html(),
                       [[
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body><p>broken tag&gt;</p></body></html>
]])
end

function TestHTML.test_parse_prefer_charset_meta_charset()
  local html = [[
<html>
  <head>
    <title>タイトル</title>
    <meta charset="UTF-8">
  </head>
</html>
]]
  local document = xmlua.HTML.parse(html, {prefer_charset = true})
  luaunit.assertEquals(document:search("//title"):text(),
                       "タイトル")
end

function TestHTML.test_parse_encoding_content_type()
  local html = [[
<html>
  <head>
    <title>タイトル</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
</html>
]]
  local document = xmlua.HTML.parse(html)
  luaunit.assertEquals(document:search("//title"):text(),
                       "タイトル")
end

function TestHTML.test_root()
  local html = xmlua.HTML.parse("<html></html>")
  luaunit.assertEquals(html:root():to_html(),
                       "<html></html>")
end

function TestHTML.test_parent()
  local html = xmlua.HTML.parse("<html></html>")
  luaunit.assertNil(html:parent())
end
