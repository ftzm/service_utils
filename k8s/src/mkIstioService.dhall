let prelude = env:DHALL_PRELUDE

let types = env:DHALL_KUBERNETES_TYPES

let defaults = env:DHALL_KUBERNETES_DEFAULTS

let IstioPort = { targetPort : Natural, port : Natural, name : Text }

let IstioService = { name : Text, ports : List IstioPort }

let mkIstioPort =
		λ(p : IstioPort)
	  →   defaults.ServicePort
		⫽ { targetPort =
			  Some (types.IntOrString.Int p.targetPort)
		  , port =
			  p.port
	      , name = Some p.name
		  }

let mkIstioPorts = prelude.List.map IstioPort types.ServicePort mkIstioPort

in    λ(service : IstioService)
	→     defaults.Service
		⫽ { metadata =
				defaults.ObjectMeta
			  ⫽ { name =
					service.name
				, labels =
					[ { mapKey = "app", mapValue = service.name } ]
				}
		  , spec =
			  Some
			  (   defaults.ServiceSpec
				⫽ { selector =
					  [ { mapKey = "app", mapValue = service.name } ]
				  , ports = mkIstioPorts service.ports

				  }
			  )
		  }
	  : types.Service
