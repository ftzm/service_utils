let prelude = env:DHALL_PRELUDE

let kubernetes = env:DHALL_KUBERNETES

let mkRule =
		λ(name : Text)
	  → λ(port : Natural)
	  → λ(host : Text)
	  → kubernetes.IngressRule::{
		, host = Some host
		, http =
			Some
			  { paths =
				  [ kubernetes.HTTPIngressPath::{
					, backend =
						{ serviceName = name
						, servicePort = kubernetes.IntOrString.Int port
						}
					}
				  ]
			  }
		}

let mkRules =
		λ(name : Text)
	  → λ(port : Natural)
	  → λ(hosts : List Text)
	  → prelude.List.map
		  Text
		  kubernetes.IngressRule.Type
		  (mkRule name port)
		  hosts

in    λ(spec : { name : Text, hosts : List Text, port : Natural })
	→ kubernetes.Ingress::{
	  , metadata = kubernetes.ObjectMeta::{ name = spec.name }
	  , spec =
		  Some
			kubernetes.IngressSpec::{
			, tls =
				[ { secretName = Some "${spec.name}-crt-secret"
				  , hosts = [] : List Text
				  }
				]
			, rules = mkRules spec.name spec.port spec.hosts
			}
	  }
