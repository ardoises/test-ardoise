return function (Layer, layer, ref)
  local refines = Layer.key.refines
  layer [refines] = {
    [1] = Layer.require "petrinet",
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
  layer.vertices = {
    a = {
      position = {
        x = 158.35683676289,
        y = 118.42616554591,
      },
    },
    b = {
      position = {
        x = 233.45909612981,
        y = 371.90758472858,
      },
    },
  }
end
