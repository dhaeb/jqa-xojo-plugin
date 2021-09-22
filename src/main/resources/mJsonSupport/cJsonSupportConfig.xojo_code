#tag Class
Protected Class cJsonSupportConfig
	#tag Method, Flags = &h0
		Sub Constructor()
		  Me.dateformat = mJsonSupport.Dateformat.Iso8601Format
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(dateformat As Dateformat)
		  Me.dateformat = dateformat
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getDateFormat() As Dateformat
		  Return Me.dateformat
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private dateformat As Dateformat
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
		#tag ViewProperty
			Name="dateformat"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Dateformat"
			EditorType="Enum"
			#tag EnumValues
				"0 - Iso8601Format"
				"1 - Iso8601WithoutMillsec"
			#tag EndEnumValues
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
