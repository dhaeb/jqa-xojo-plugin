#tag Class
Protected Class cJsonEnumNameMapper
	#tag Method, Flags = &h0
		Sub Constructor()
		  // XOJOs line Continuation is the "_" character  --> https://docs.xojo.com/Line_Continuation
		  
		  
		  Self.mapping = New Dictionary
		  Self.mapping_reverse = New Dictionary
		  // Setup for test
		  Var string_fixture_test  As Dictionary = new Dictionary
		  
		  string_fixture_test.Value(0) = "Foo"
		  string_fixture_test.Value(1) = "Bar"
		  string_fixture_test.Value(2) = "Baz"
		  
		  Self.mapping.Value("Fixtures.Test") = string_fixture_test
		  
		  
		  // BusinessCaseTypeEnum
		  
		  Var business_case_type_enum  As Dictionary = New Dictionary
		  
		  Var business_types() as String = Array("Null","Pfand","PfandRueckzahlung","Rabatt","Aufschlag","ZuschussEcht",_
		  "ZuschussUnecht","TrinkgeldAG","TrinkgeldAN", _
		  "EinzweckgutscheinKauf","EinzweckgutscheinEinloesung","MehrzweckgutscheinKauf",_
		  "MehrzweckgutscheinEinloesung","Forderungsentstehung","Forderungsaufloesung","Anzahlungseinstellung",_
		  "Anzahlungsaufloesung","Anfangsbestand","Privatentnahme",_
		  "Privateinlage","Geldtransit","Lohnzahlung","Einzahlung","Auszahlung","DifferenzSollIst","Umsatz")
		  
		  Var prefix As String = "mDFKATaxonomy"
		  Var fullClassname As String = prefix+".BusinessCaseTypeEnum"
		  
		  
		  createMappingFromArray(fullClassname, business_types)
		  
		  
		  createMappingFromArray(prefix+".PaymentTypeEnum", _
		  Array("Null","Bar","Unbar","Keine","ECKarte","Kreditkarte","ElZahlungsdienstleister","Guthabenkarte"))
		  
		  createMappingFromArray(prefix+".BuyerTypeEnum", _
		  Array("Null","Mitarbeiter","Kunde"))
		  
		  createMappingFromArray(prefix+".LogTimeFormatEnum", _
		  Array("Null","utcTime" , "utcTimeWithSeconds" , "generalizedTime", "generalizedTimeWithMilliseconds", "unixTime"))
		  
		  Var signature_algorithm_map() as String = Array("Null","ecdsa-plain-SHA256","ecdsa-plain-SHA384","ecdsa-plain-SHA512",_
		  "ecdsa-plain-SHA3-224","ecdsa-plain-SHA3-256","ecdsa-plain-SHA3-384","ecdsa-plain-SHA3-512","ecsdsa-plain-SHA224",_
		  "ecsdsa-plain-SHA256","ecsdsa-plain-SHA384","ecsdsa-plain-SHA512","ecsdsa-plain-SHA3-224","ecsdsa-plain-SHA3-256",_
		  "ecsdsa-plain-SHA3-384","ecsdsa-plain-SHA3-512","ecdsa-plain-SHA224")
		  
		  createMappingFromArray(prefix+".SignatureAlgorithmEnum", signature_algorithm_map)
		  
		  createMappingFromArray(prefix+".TransactionReferenceEnum", Array("Null","ExternerLieferschein","ExterneSonstige","Transaktion","ExterneRechnung"))
		  
		  createMappingFromArray(prefix+".TransactionTypeEnum", Array("Null","AVTransfer","AVBestellung","AVTraining","AVBelegstorno","AVBelegabbruch","AVSachbezug","AVRechnung","AVSonstige","Beleg"))
		  
		  Var currency_code() As String = Array("Null","AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN",_
		  "BHD","BIF","BMD","BND","BOB","BOV","BRL","BSD","BTN","BWP","BYN","BZD","CAD","CDF","CHE","CHF","CHW","CLF","CLP",_
		  "CNY","COP","COU","CRC","CUC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","GBP",_
		  "GEL","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","INR","IQD","IRR","ISK","JMD","JOD",_
		  "JPY","KES","KGS","KHR","KMF","KPW","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LYD","MAD","MDL","MGA",_
		  "MKD","MMK","MNT","MOP","MRU","MUR","MVR","MWK","MXN","MXV","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD",_
		  "OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD",_
		  "SHP","SLL","SOS","SRD","SSP","STN","SVC","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TWD","TZS","UAH",_
		  "UGX","USD","USN","UYI","UYU","UYW","UZS","VES","VND","VUV","WST","XAF","XAG","XAU","XBA","XBB","XBC","XBD","XCD",_
		  "XDR","XOF","XPD","XPF","XPT","XSU","XTS","XUA","XXX","YER","ZAR","ZMW","ZWL")
		  
		  createMappingFromArray(prefix+".CurrencyCodeEnum", currency_code)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub createMappingFromArray(fullClassName as string, map() as string)
		  Var new_mapping  As Dictionary = New Dictionary
		  Var new_mapping_reverse  As Dictionary = New Dictionary
		  For i As Integer =  0 To map.Count() - 1
		    new_mapping.Value(i) = map(i)
		    new_mapping_reverse.Value(map(i)) = i
		  Next
		  
		  Self.mapping.Value(fullClassname) = new_mapping
		  Self.mapping_reverse.Value(fullClassname) = new_mapping_reverse
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function get() As cJsonEnumNameMapper
		  If cJsonEnumNameMapper.this = Nil then
		    cJsonEnumNameMapper.this = New cJsonEnumNameMapper
		  End
		  Return cJsonEnumNameMapper.this
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getIntMappingFor(enumName As Variant) As Variant
		  Return mapping_reverse.Lookup(enumName, Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getStringMappingFor(enumName As Variant) As Variant
		  Return mapping.Lookup(enumName, Nil)
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mapping As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mapping_reverse As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared this As cJsonEnumNameMapper
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
