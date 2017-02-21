return function (Layer, example, ref)

  local defaults = Layer.key.defaults
  local meta     = Layer.key.meta
  local refines  = Layer.key.refines

  local record     = Layer.new { name = "data.record" }
  local collection = Layer.new { name = "data.collection" }

  collection [meta] = {
    [collection] = {
      key_type        = false,
      value_type      = false,
      key_container   = false,
      value_container = false,
      minimum         = false,
      maximum         = false,
    },
  }
  collection [defaults] = {
    Layer.reference (collection) [meta] [collection].value_type,
  }

  local gui = Layer.new { name = "gui" }

  local graph = Layer.new { name = "graph" }

  graph [refines] = {
    record,
  }

  graph [meta] = {}

  -- Vertices are empty in base graph.
  graph [meta].vertex_type = {
    [refines] = {
      record,
    }
  }

  -- Arrows are records with only one predefined field: `vertex`.
  -- It points to the destination of the arrow, that must be a vertex of the
  -- graph.
  -- Edges have no label in base graph.
  -- They only contain zero to several arrows. The arrow type is defined for
  -- each edge type.
  -- The `default` key states that all elements within the `arrows` container
  -- are of type `arrow_type`.
  graph [meta].edge_type = {
    [refines] = {
      record,
    },
    [meta] = {
      arrow_type = {
        [refines] = {
          record,
        },
        [meta] = {
          [record] = {
            vertex = {
              value_type      = Layer.reference (graph) [meta].vertex_type,
              value_container = Layer.reference (graph).vertices,
            }
          }
        },
        vertex = nil,
      },
    },
  }

  graph [meta].edge_type.arrows = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (graph [meta].edge_type) [meta].arrow_type,
      }
    },
  }

  -- A graph contains a collection of vertices.
  -- The `default` key states that all elements within the `vertices` container
  -- are of type `vertex_type`.
  graph.vertices = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (graph) [meta].vertex_type,
      },
    },
  }

  -- A graph contains a collection of edges.
  -- The `default` key states that all elements within the `edges` container
  -- are of type `edge_type`.
  graph.edges = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (graph) [meta].edge_type,
      },
    },
  }

  graph [meta] [gui] = {}

  graph [meta] [gui].create = function (Adapter, proxy)
  end

  graph [meta].vertex_type [meta] [gui] = {}

  graph [meta].vertex_type [meta] [gui].create = function (Adapter, t)
    local group     = Adapter.document:createElementNS (Adapter.d3.namespaces.svg, "g")
    local selection = Adapter.d3:select (group)
    selection
      :append "circle"
      :attr ("r", 50)
      :attr ("stroke", "white")
      :attr ("stroke-width", 3)
    return selection:node ()
  end

  graph [meta].vertex_type [meta] [gui].update = function (Adapter, t)
    Adapter.d3
      :select (t.element)
      :selectAll "circle"
      :attr ("cx", t.data.x)
      :attr ("cy", t.data.y)
  end

  graph [meta].edge_type [meta] [gui] = {}

  graph [meta].edge_type [meta] [gui].create = function (Adapter, t)
    local group     = Adapter.document:createElementNS (Adapter.d3.namespaces.svg, "g")
    local selection = Adapter.d3:select (group)
    selection
      :append "circle"
      :attr ("r", 1)
      :attr ("stroke", "white")
    return selection:node ()
  end

  graph [meta].edge_type [meta] [gui].update = function (Adapter, t)
    Adapter.d3
      :select (t.element)
      :selectAll "circle"
      :attr ("cx", t.data.x)
      :attr ("cy", t.data.y)
  end

  local binary_edges = Layer.new { name = "graph.binary_edges" }

  binary_edges [refines] = {
    graph
  }

  binary_edges [meta].edge_type.arrows [meta] = {
    [collection] = {
      minimum = 2,
      maximum = 2,
    },
  }

  local directed = Layer.new { name = "graph.directed" }

  directed [refines] = {
    graph,
    binary_edges,
  }

  directed [meta].edge_type [meta] [record] = {
    source = {
      value_container = Layer.reference (directed).vertices,
    },
    target = {
      value_container = Layer.reference (directed).vertices,
    },
  }

  directed [meta].edge_type.arrows = {
    source = {
      vertex = Layer.reference (directed [meta].edge_type).source,
    },
    target = {
      vertex = Layer.reference (directed [meta].edge_type).target,
    },
  }

  local petrinet = Layer.new { name = "petrinet" }

  petrinet [refines] = {
    directed,
  }

  petrinet [meta].place_type = {
    [refines] = {
      Layer.reference (petrinet) [meta].vertex_type,
    },
    [meta] = {
      [record] = {
        identifier = false,
        marking    = false,
      }
    }
  }

  petrinet [meta].transition_type = {
    [refines] = {
      Layer.reference (petrinet) [meta].vertex_type,
    }
  }

  petrinet [meta].arc_type = {
    [refines] = {
      Layer.reference (petrinet) [meta].edge_type,
    },
  }

  petrinet.places = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (petrinet) [meta].place_type,
      }
    },
  }

  petrinet.transitions = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (petrinet) [meta].transition_type,
      }
    },
  }

  petrinet [meta].pre_arc_type = {
    [refines] = {
      Layer.reference (petrinet) [meta].arc_type,
    },
    [meta] = {
      [record] = {
        source = {
          value_container = Layer.reference (petrinet).places,
        },
        target = {
          value_container = Layer.reference (petrinet).transitions,
        },
      },
    },
  }

  petrinet [meta].post_arc_type = {
    [refines] = {
      Layer.reference (petrinet) [meta].arc_type,
    },
    [meta] = {
      [record] = {
        source = {
          value_container = Layer.reference (petrinet).transitions,
        },
        target = {
          value_container = Layer.reference (petrinet).places,
        },
      },
    },
  }

  petrinet.pre_arcs = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (petrinet) [meta].pre_arc_type,
      }
    },
  }

  petrinet.post_arcs = {
    [refines] = {
      collection,
    },
    [meta] = {
      [collection] = {
        value_type = Layer.reference (petrinet) [meta].post_arc_type,
      }
    },
  }

  petrinet.arcs = {
    [refines] = {
      Layer.reference (petrinet).pre_arcs,
      Layer.reference (petrinet).post_arcs,
    },
  }

  petrinet.vertices [refines] = {
    Layer.reference (petrinet).places,
    Layer.reference (petrinet).transitions,
  }
  petrinet.edges    [refines] = {
    Layer.reference (petrinet).arcs,
  }

  example [refines] = {
    petrinet,
  }
  example.places     .a  = {}
  example.transitions.b  = {}
  example.pre_arcs   .ab = {
    source = ref.places.a,
    target = ref.transitions.b,
  }

  -- Iteration over Petri net arcs:
  for id, arc in Layer.pairs (example.arcs) do
    print (id, arc.source, arc.target)
  end

  -- Iteration over graph edges:
  for id, edge in Layer.pairs (example.edges) do
    print (id, edge.source, edge.target)
  end

  -- Iteration over graph vertices:
  for id, vertex in Layer.pairs (example.vertices) do
    print (id, vertex)
  end

end
