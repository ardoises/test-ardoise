return function (Layer, layer, ref)
  local deleted = Layer.key.deleted
  layer [10] = 100
  layer [1] = 1
  layer [2] = 4
  layer [3] = 9
  layer [4] = 16
  layer [5] = 25
  layer [6] = 36
  layer [7] = 49
  layer [8] = 64
  layer [9] = 81
  layer.a = "b"
  layer.foo = deleted
  layer.test = true
  layer.tropfort = true
  layer.truc = "muche"
  layer.x = deleted
end
