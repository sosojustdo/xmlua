local Element = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Savable = require("xmlua.savable")
local Searchable = require("xmlua.searchable")

local methods = {}

local metatable = {}
function metatable.__index(element, key)
  return methods[key] or
    Savable[key] or
    Searchable[key] or
    methods.get_attribute(element, key)
end

function methods.get_attribute(self, name)
  local value = nil
  local colon_start = name:find(":")
  if colon_start then
    local namespace_prefix = name:sub(0, colon_start - 1)
    local local_name = name:sub(colon_start + 1)
    local namespace = libxml2.xmlSearchNs(self.document,
                                          self.node,
                                          namespace_prefix)
    if namespace then
      value = libxml2.xmlGetNsProp(self.node, local_name, namespace.href)
    else
      value = libxml2.xmlGetProp(self.node, name)
    end
  else
    value = libxml2.xmlGetNoNsProp(self.node, name)
  end
  return value
end

function Element.new(document, node)
  local element = {
    document = document,
    node = node,
  }
  setmetatable(element, metatable)
  return element
end

return Element