return function (Layer, layer, ref)
  local deleted = Layer.key.deleted
  layer.foo = deleted
  layer.tropfort = true
  layer.truc = "truc"
end
