let kubernetes = env:DHALL_KUBERNETES

in    λ(args : { name : Text, tag : Text, port : Natural })
	→ defaults.Deployment::{
	  , metadata = kubernetes.ObjectMeta::{ name = args.name }
	  , spec =
		  Some
			kubernetes.DeploymentSpec::{
			, replicas = Some 1
			, selector =
				kubernetes.LabelSelector::{
				, matchLabels = [ { mapKey = "app", mapValue = args.name } ]
				}
			, template =
				kubernetes.PodTemplateSpec::{
				, metadata =
					kubernetes.ObjectMeta::{
					, labels = [ { mapKey = "app", mapValue = args.name } ]
					, name = args.name
					}
				, spec =
					Some
					  kubernetes.PodSpec::{
					  , containers =
						  [ kubernetes.Container::{
							, name = args.name
							, image = Some args.tag
							, ports =
								[ kubernetes.ContainerPort::{
								  , containerPort = args.port
								  }
								]
							}
						  ]
					  }
				}
			}
	  }
