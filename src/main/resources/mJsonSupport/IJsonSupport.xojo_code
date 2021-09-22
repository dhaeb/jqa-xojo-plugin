#tag Interface
Protected Interface IJsonSupport
	#tag Method, Flags = &h0
		Sub fromJSON(json As JSONItem)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fromJSONFactory(fieldName As String, jsonItem As JSONItem = Nil) As IJsonSupport
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function fromJsonFactoryArray(fieldName As String, count As Integer) As IJsonSupport()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getFields() As String()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getRequiredFields() As String()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSON(config As cJsonSupportConfig = Nil) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSONItem(config As cJsonSupportConfig = Nil) As JSONItem
		  
		End Function
	#tag EndMethod


	#tag Note, Name = getFields
		// the getFields method provides a string array with all the field names which should be considered during JSON creation. 
		
		
	#tag EndNote


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
End Interface
#tag EndInterface
