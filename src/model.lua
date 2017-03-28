return function (Layer, layer, ref)
  local refines = Layer.key.refines
  layer [refines] = {
  }
  layer.places = {
    a = {
    },
  }
  layer.pre_arcs = {
    ab = {
      source = ref.places.a,
      target = ref.transitions.b,
    },
  }
  layer.transitions = {
    b = {
    },
  }
end
