let k = env:DHALL_KUBERNETES_TYPES

let i = ./dhall-istio/types.dhall

let simpleDeployment = ./simpleDeployment.dhall

let mkIstioService = ./mkIstioService.dhall

let simpleVirtualService = ./simpleVirtualService.dhall

let ServiceSpec =
	  { name :
		  Text
	  , repo :
		  Text
	  , port :
		  Natural
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

let tag = env:DOCKER_TAG as Text

in    λ(spec : ServiceSpec)
	→ [ doc.Deployment
		(simpleDeployment { name = spec.name, port = spec.port, tag = tag })
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