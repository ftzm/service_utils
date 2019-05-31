let k = ./dhall-kubernetes/types.dhall

let i = ./dhall-istio/types.dhall

let simpleDeployment = ./simpleDeployment

let mkIstioService = ./mkIstioService

let simpleVirtualService = ./simpleVirtualService.dhall

let ServiceSpec =
	  { name :
		  Text
	  , port :
		  Natural
	  , tag :
		  Text
	  , gateway :
		  Text
	  , hosts :
		  List Text
	  }

let doc =
	  < Deployment :
		  k.Deployment
	  | Service :
		  k.Service
	  | VirtualService :
		  i.VirtualService
	  >

in    λ(spec : ServiceSpec)
	→ [ doc.Deployment
		( simpleDeployment
		  { name = spec.name, port = spec.port, tag = spec.tag }
		)
	  , doc.Service
		( mkIstioService
		  { name =
			  spec.name
		  , ports =
			  [ { targetPort = spec.port, port = spec.port, name = "http" } ]
		  }
		)
	  , doc.VirtualService
		( simpleVirtualService
		  { name = spec.name, gateway = spec.gateway, hosts = spec.hosts }
		)
	  ]
