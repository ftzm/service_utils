let kubernetes = env:DHALL_KUBERNETES

let prelude = env:DHALL_PRELUDE

let SimpleService = { name : Text, ports : List Natural }

let mkPort = λ(p : Natural) → kubernetes.ServicePort::{ port = p }

let mkPorts = prelude.List.map Natural kubernetes.ServicePort.Type mkPort

in    λ(service : SimpleService)
	→   kubernetes.Service::{
		, metadata =
			kubernetes.ObjectMeta::{
			, name = service.name
			, labels = [ { mapKey = "app", mapValue = service.name } ]
			}
		, spec =
			Some
			  kubernetes.ServiceSpec::{
			  , selector = [ { mapKey = "app", mapValue = service.name } ]
			  , ports = mkPorts service.ports
			  }
		}
	  : kubernetes.Service.Type
