let types = ./dhall-istio/types.dhall

let defaults = ./dhall-istio/defaults.dhall

in    λ(spec : { name : Text, gateway : Text, hosts : List Text })
	→   defaults.virtualService
	  ⫽ { metadata =
			[ { mapKey = "name", mapValue = spec.name } ]
		, spec =
			  defaults.virtualServiceSpec
			⫽ { hosts =
				  spec.hosts
			  , gateways =
				  [ spec.gateway ]
			  , http =
				  [ { route =
						[ { destination =
							  defaults.destination ⫽ { host = spec.name }
						  }
						]
					}
				  ]
			  }
		}
