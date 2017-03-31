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
  layer.foo = deleted
  layer.tropfort = true
  layer.truc = "truc"
  layer.x = 43
end
