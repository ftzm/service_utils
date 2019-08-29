let types = env:DHALL_KUBERNETES_TYPES
let defaults = env:DHALL_KUBERNETES_DEFAULTS

in    λ(args : { name : Text, tag : Text, port : Natural })
	→   defaults.Deployment
	  ⫽ { metadata =
			defaults.ObjectMeta ⫽ { name = args.name }
		, spec =
			Some
			(   defaults.DeploymentSpec
			  ⫽ { replicas =
					Some 1
				, selector =
					  defaults.LabelSelector
					⫽ { matchLabels =
						  [ { mapKey = "app", mapValue = args.name } ]
					  }
				, template =
					  defaults.PodTemplateSpec
					⫽ { metadata =
							defaults.ObjectMeta
						  ⫽ { labels =
								[ { mapKey = "app", mapValue = args.name } ]
							, name =
								args.name
							}
					  , spec =
						  Some
						  (   defaults.PodSpec
							⫽ { containers =
								  [   defaults.Container
									⫽ { name =
										  args.name
									  , image =
										  Some args.tag
									  , ports =
										  [   defaults.ContainerPort
											⫽ { containerPort = args.port }
										  ]
									  }
								  ]
							  }
						  )
					  }
				}
			)
		}
