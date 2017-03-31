return function (Layer, layer, ref)
  local deleted = Layer.key.deleted
  layer [10] = 10
  layer [1] = 1
  layer [2] = 2
  layer [3] = 3
  layer [4] = 4
  layer [5] = 5
  layer [6] = 6
  layer [7] = 7
  layer [8] = 8
  layer [9] = 9
  layer.foo = deleted
  layer.tropfort = true
  layer.truc = "truc"
end
