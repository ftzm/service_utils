let Certificate = ./Certificate.dhall

in    λ(spec : { name : Text, hosts : List Text })
	→     Certificate.default
		∧ { metadata = { name = spec.name }
		  , spec =
			  { secretName = "${spec.name}-crt-secret", dnsNames = spec.hosts }
		  }
	  : Certificate.Type
