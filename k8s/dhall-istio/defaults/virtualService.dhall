  { apiVersion =
	  "networking.istio.io/v1alpha3"
  , kind =
	  "VirtualService"
  , metadata =
	  [] : List { mapKey : Text, mapValue : Text }
  , spec =
	  ./virtualServiceSpec.dhall
  }
: ../types/VirtualService.dhall
