let kubernetes = env:DHALL_KUBERNETES

let Certificate =
	  { apiVersion : Text
	  , kind : Text
	  , metadata : kubernetes.ObjectMeta.Type
	  , spec :
		  { secretName : Text
		  , dnsNames : List Text
		  , issuerRef : { name : Text, kind : Text, group : Text }
		  }
	  }

let defaultCertificate =
	  { apiVersion = "cert-manager.io/v1alpha2"
	  , metadata = kubernetes.ObjectMeta.default
	  , kind = "Certificate"
	  , spec =
		  { issuerRef =
			  { kind = "ClusterIssuer"
			  , group = "cert-manager.io"
			  , name = "letsencrypt-prod"
			  }
		  }
	  }

in  { Type = Certificate, default = defaultCertificate }
