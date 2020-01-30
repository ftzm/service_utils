let kubernetes = env:DHALL_KUBERNETES

let k = env:DHALL_KUBERNETES_TYPES

let i = ./dhall-istio/types.dhall

let simpleDeployment = ./simpleDeployment.dhall

let simpleIngress = ./simpleIngress.dhall

let mkSimpleService = ./simpleService.dhall

let simpleVirtualService = ./simpleVirtualService.dhall

let Certificate = ./cert-manager/Certificate.dhall

let simpleCertificate = ./cert-manager/simpleCertificate.dhall

let ServiceSpec =
	  { name : Text
	  , repo : Text
	  , port : Natural
	  , gateway : Text
	  , hosts : List Text
	  }

let doc =
	  < Deployment : k.Deployment
	  | Service : k.Service
	  | Cert : Certificate.Type
	  | Ingress : kubernetes.Ingress.Type
	  >

let tag = env:DOCKER_TAG as Text

in    λ(spec : ServiceSpec)
	→ [ doc.Deployment
		  (simpleDeployment { name = spec.name, port = spec.port, tag = tag })
	  , doc.Service
		  (mkSimpleService { name = spec.name, ports = [ spec.port ] })
	  , doc.Ingress
		  ( simpleIngress
			  { name = spec.name, hosts = spec.hosts, port = spec.port }
		  )
	  , doc.Cert (simpleCertificate { name = spec.name, hosts = spec.hosts })
	  ]
