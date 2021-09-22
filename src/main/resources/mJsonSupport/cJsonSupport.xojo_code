#tag Class
Protected Class cJsonSupport
Implements mJsonSupport.IJsonSupport
	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function createJSONArray(values As Variant, name As String, config As cJsonSupportConfig = Nil) As JSONItem
		  // Assumptions:
		  // This framework will NOT support multidimensional arrays as there dim is not really extractable in XOJO.
		  Var jsonArray As JSONItem = createJSONItemAsArray
		  
		  Select Case values.ArrayElementType
		  Case Variant.TypeString
		    Var strs() As String = values
		    
		    For Each str As String In strs
		      jsonArray.append(str)
		    Next
		    
		  Case Variant.TypeInt64
		    Var nums() As Int64 = values
		    
		    For Each num As int64 In nums
		      jsonArray.append(num)
		    Next
		    
		  Case Variant.TypeInt32
		    Var nums() As Int32 = values
		    
		    For Each num As Int32 In nums
		      jsonArray.append(num)
		    Next
		    
		  Case Variant.TypeBoolean
		    Var bools() As Boolean = values
		    
		    For Each bool As Boolean In bools
		      jsonArray.append(bool)
		    Next
		    
		  Case Variant.TypeDouble
		    Var nums() As Double = values
		    
		    For Each num As Double In nums
		      jsonArray.append(num)
		    Next
		    
		  Case Variant.TypeInteger
		    Var nums() As Integer = values
		    
		    For Each num As Integer In nums
		      jsonArray.append(num)
		    Next 
		    
		  Case Variant.TypeSingle
		    Var nums() As Single = values
		    
		    For Each num As Single In nums
		      jsonArray.append(num)
		    Next
		    
		  Case Variant.TypeText
		    Var texts() As Text = values
		    // Implicit conversion between text value and string...
		    // https://forum.xojo.com/18396-string-to-text-implicit-conversion/0
		    
		    For Each str As String In texts
		      jsonArray.append(str)
		    Next
		    
		  Case Variant.TypeCurrency
		    Var curs() As Currency = values
		    
		    For Each cur As Currency In curs
		      jsonArray.append(cur.ToString())
		    Next
		    
		  Case Variant.TypeObject
		    // We can not cast directly to I_JSON_Support
		    // It's necessary to iterate over current object values
		    Var objs() As Object = values
		    
		    For Each obj As Object In objs
		      // FIXME: Language problem XOJO - this is a dynamic method call and therefore very unstable code in gernal!!!!
		      If obj IsA mJsonSupport.IJsonSupport Then
		        // The following dynamic method call is need due to Xojo's lack of downcasting
		        Var methods() As Introspection.MethodInfo = Introspection.GetType(obj).GetMethods()
		        
		        For Each method As Introspection.MethodInfo In methods
		          If method.Name = "toJSONItem" Then
		            Var params(-1) As Variant  
		            params.Add(config)
		            Var json As JSONItem = method.Invoke(obj, params)
		            jsonArray.append(json)
		            
		            Exit
		          End
		        Next
		      End
		    Next
		  Else
		    Var ex As UnsupportedFormatException = New UnsupportedFormatException()
		    ex.Message = "Data type for property `" + name + "` is not supported."
		    
		    System.Log(System.LogLevelError, "❌ DFKA: mJsonSupport > cJsonSupport > createJsonArray - Data type for property `" +_
		    name + "` is not supported.")
		    Raise ex
		  End Select
		  
		  Return jsonArray
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub createJSONFromDatetime(value As DateTime, propInfo As Introspection.PropertyInfo, returnable As JsonItem, config As cJsonSupportConfig)
		  
		  If value <> Nil Then
		    Var assignable As String = ""
		    Select Case config.getDateFormat()
		    Case Dateformat.Iso8601Format
		      assignable = value.ToIsoString
		    Case Dateformat.Iso8601WithoutMillsec
		      assignable = value.ToIsoStringWithoutMillsec
		    End Select
		    returnable.Value(propInfo.Name) = assignable
		  Else
		    returnable.Value(propInfo.Name) = ""
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub createJSONFromEnum(returnable As JSONItem, name As String, enumName As String, enumValue As Integer)
		  If enumValue = 0 Then 
		    // Do nothing because the value is null at position 0 of each enumeration
		  Else
		    
		    Var values As Variant = mJsonSupport.cJsonEnumNameMapper.get().getStringMappingFor(enumName)
		    
		    If values.isNull() Then
		      returnable.Value(name) = enumValue
		    Else
		      Var dict As Dictionary = values
		      
		      If dict.HasKey(enumValue) Then
		        returnable.Value(name) = dict.Value(enumValue)
		      Else
		        returnable.Value(name) = enumValue
		      End
		    End
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub createJSONFromField(propInfo As Introspection.PropertyInfo, returnable As JSONItem, config As cJsonSupportConfig = Nil)
		  Var propTypeInfo As Introspection.TypeInfo = propInfo.PropertyType
		  
		  
		  // Handle primitives
		  If propTypeInfo.IsPrimitive Then
		    Me.createJSONPrimitive(propInfo, returnable, config)
		  End
		  
		  // Handle object
		  If (propTypeInfo.IsClass Or propTypeInfo.IsInterface) And propTypeInfo <> GetTypeInfo(DateTime) Then
		    // Needs to split because date.value(Me) results in a Xojo crash
		    If propInfo.Value(Me) IsA mJsonSupport.IJsonSupport Then
		      Var val As mJsonSupport.IJsonSupport = propInfo.Value(Me)
		      Var jsonItem as JSONItem = val.toJSONItem(config)
		      returnable.Value(propInfo.Name) = jsonItem
		    End If
		    
		    
		    // handle dicts
		    
		    If propInfo.Value(Me) IsA Dictionary Then
		      Var val As Dictionary = propInfo.Value(Me)
		      returnable.Value(propInfo.Name) = createJsonItem(val)
		    End If
		    
		    
		  End
		  
		  // Handle arrays
		  If propTypeInfo.IsArray Then
		    Var typeNameWithoutPotentialArrayParenthesis As String = propTypeInfo.FullName
		    typeNameWithoutPotentialArrayParenthesis = typeNameWithoutPotentialArrayParenthesis.Left(typeNameWithoutPotentialArrayParenthesis.Length - 2)
		    // Check if we got an array of enums, this is not implemented in XOJO, so we use our enum mapper
		    Var enumsVariant As Variant = cJsonEnumNameMapper.get().getStringMappingFor(typeNameWithoutPotentialArrayParenthesis)
		    
		    If enumsVariant.IsNull Then
		      // It's a normal array or at least not mapped enum, so proceed
		      // This code works also for non mapped enums, as they are just interepreted as integers
		      Var val As Variant = propInfo.Value(Me)
		      
		      Try
		        returnable.Value(propInfo.name) = createJSONArray(val, propInfo.name)
		      Catch ex As OutOfBoundsException
		        // Note: Seems like we have a multidimensional array here
		        // So we can't and don't need to handle this case
		        ex.Message = "Multidimensional arrays are not supported."
		        System.Log(System.LogLevelError, "❌ DFKA: mJsonSupport > cJsonSupport > createJSONFromFeild -"+_
		        " Multidimensional arrays are not supported.")
		        Raise ex
		      End Try
		    Else
		      // This seems like an array of mapped enums
		      Var jsonArray As JSONItem = Me.createJSONItemAsArray()
		      Var enumValues() As Integer = propInfo.Value(Me)
		      Var dict As Dictionary = enumsVariant
		      
		      For Each enumValue As Integer In enumValues
		        If dict.HasKey(enumValue) Then
		          jsonArray.append(dict.Value(enumValue))
		        Else
		          jsonArray.append(enumValue)
		        End
		      Next
		      
		      returnable.Value(propInfo.Name) = jsonArray
		    End
		  End
		  
		  // Handle enums
		  If propTypeInfo.IsEnum Then
		    Var num As Integer = propInfo.Value(Me)
		    Me.createJSONFromEnum(returnable, propInfo.name, propTypeInfo.FullName, num)
		  End
		  
		  // Handle datetimes
		  If propTypeInfo = GetTypeInfo(DateTime) Or propTypeInfo = GetTypeInfo(Date) Then
		    Me.createJSONPrimitive(propInfo, returnable, config)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function createJsonItem() As JSONItem
		  Return New JSONItem_MTC()
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function createJsonItem(d As Dictionary) As JSONItem
		  Var r As  JSONItem_MTC = d
		  Return r 
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function createJsonItem(s As String) As JSONItem
		  Return New JSONItem_MTC(s)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function createJSONItemAsArray() As JSONItem
		  Var jsonArray As JSONItem = createJsonItem()
		  
		  // Workaround to set JSONItem to array mode (so that an empty array gets printed)
		  jsonArray.append(1)
		  jsonArray.removeAll()
		  
		  Return jsonArray
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub createJSONPrimitive(propInfo As Introspection.PropertyInfo, returnable As JSONItem, config As cJsonSupportConfig = Nil)
		  Select Case propInfo.propertyType.Name
		  Case "Int8", "Int16", "Int32", "Int64", "Integer", "Single", "Double", "Boolean", "Variant",  "String"
		    Var surelyInclude() As String = Me.includeFieldsWhenEmpty
		    // this is a temporary solution for the keyword function problem in EpsonCommand Class
		    If propInfo.Name = "functionName" Then
		      returnable.Value("function") = propInfo.Value(Me)
		    ElseIf propInfo.Value(Me).StringValue = "" And surelyInclude.IndexOf(propInfo.Name) = -1  Then
		      // don't add the key to the JSON item if the value is an empty string 
		      // TODO ADD TEST FOR surelyInclude
		      
		    ElseIf propInfo.Name = "text_" Then
		      returnable.Value("text") = propInfo.Value(Me)
		    Else
		      returnable.Value(propInfo.Name) = propInfo.Value(Me)
		    End If
		    
		  Case "Text"
		    
		    If propInfo.Name = "text_" Then
		      returnable.Value("text") = propInfo.Value(Me)
		    Else
		      // Tip: Implicit conversion between text value and string
		      // https://forum.xojo.com/18396-string-to-text-implicit-conversion/0
		      Var propInfoStr As String = propInfo.Value(Me)
		      
		      returnable.Value(propInfo.Name) = propInfoStr
		    End If
		    
		  Case "Currency"
		    returnable.Value(propInfo.Name) = propInfo.Value(Me).CurrencyValue
		    
		  Case "DateTime"
		    Var datetime As DateTime = propInfo.Value(Me).DateTimeValue
		    createJSONFromDatetime(datetime, propInfo, returnable, config)
		  Case "Date"
		    Var value As Variant = propInfo.Value(Me)
		    Var date As Date = value.DateValue
		    Var datetime As New DateTime(date)
		    createJSONFromDatetime(datetime, propInfo, returnable, config)
		  Else
		    Var ex As UnsupportedFormatException = New UnsupportedFormatException()
		    ex.Message = "Current JSON data type `" + propInfo.propertyType.Name + "` is not supported."
		    System.Log(System.LogLevelError, "❌ DFKA: mJsonSupport > cJsonSupport > createJsonPrimitive Current JSON data type `" +_
		    propInfo.propertyType.Name + "` is not supported.")
		    Raise ex
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fromJSON(json As JSONItem)
		  Dim typeInfo As Introspection.TypeInfo = Introspection.GetType(Me)
		  If json = Nil Then
		    System.Log(System.LogLevelError, "❌ DFKA: mJsonSupport > cJsonSupport > fromJSON - The output JSON item is nil")
		    // TODO this exception type is not good, use mJSONSupport exception
		    Raise New mDFKATaxonomy.mEpsonConnector.mModel.cDFKANilObjectException("The output JSON item is nil")
		  Else
		    For Each prop As Introspection.PropertyInfo In typeInfo.GetProperties()
		      If  prop.CanRead And prop.CanWrite Then 
		        If Not prop.Value(Me).IsArray Then 
		          // we have a readable and writable property which is most likely an object, or primitive 
		          Var lookupResultFromJson As Variant = json.Lookup(prop.Name, Nil)
		          
		          // handle the case, that a JSON property is called "text" --> as this is a reserved name in XOJO, we need to make this workaround
		          If lookupResultFromJson.IsNull And prop.Name = "text_" Then
		            lookupResultFromJson = json.Lookup("text", Nil)
		          End If
		          
		          If lookupResultFromJson isA JSONItem Then
		            // the JSON frameworks indicates that this is an array or an object
		            Var nestedJsonItem As JSONItem = lookupResultFromJson
		            If nestedJsonItem.IsArray() Then
		              // TODO throw exception
		              // this should never happen as it indicates, that there is an array in JSON and we aspect a skalar value
		            Else
		              If prop.PropertyType.Name = "Dictionary" Then
		                prop.Value(Me) = JSONItem_MTC_TO_DICT(nestedJsonItem)
		              Else 
		                
		                Var complex As IJsonSupport = Me.fromJSONFactory(prop.Name, lookupResultFromJson)
		                if complex <> Nil Then
		                  complex.fromJSON(json.Lookup(prop.Name, Nil))
		                  prop.Value(Me) = complex
		                End
		              End If
		            End If
		          ElseIf prop.PropertyType.Name = "DateTime" Then
		            // TODO this seems like an own interface implementation
		            // INFO We are currently hard coding ISO 8601 datetime format
		            Var asString As String = lookupResultFromJson
		            If asString.EndsWith("Z") Then
		              Var iso8601Date As String = asString.Replace("T", " ").Replace("Z", "")
		              iso8601Date = removeMillsec(iso8601Date)
		              If iso8601Date <>""  Then
		                #pragma BreakOnExceptions Off
		                Try
		                  dim utcTZ As new TimeZone(0)
		                  prop.Value(Me) = DateTime.FromString(iso8601Date, nil, utcTZ)
		                Catch
		                  prop.Value(Me) = Nil
		                End Try
		                #pragma BreakOnExceptions On
		              End If
		            End If
		          ElseIf prop.PropertyType.IsEnum() Then
		            // TODO code for checking if it's in the mapping singleton
		            Var enumMapperSingleton As cJsonEnumNameMapper = cJsonEnumNameMapper.get()
		            Var enumsMapping As Variant = enumMapperSingleton.getIntMappingFor(prop.PropertyType.FullName)
		            If enumsMapping.IsNull() Then
		              // default behaviour to handle all enums which are not took care of in JsonEnumMapper
		              prop.Value(Me) = json.Lookup(prop.Name, Nil)
		            Else
		              Var enumValue As String = json.Lookup(prop.Name, Nil) 
		              
		              Var dict As Dictionary = enumsMapping
		              
		              If dict.HasKey(enumValue) Then
		                prop.Value(Me) = dict.Value(enumValue)
		              End
		              
		            End
		            
		            
		          ElseIf not lookupResultFromJson.isNull Then
		            prop.Value(Me) = lookupResultFromJson
		          End If
		          
		        ElseIf prop.Value(Me).IsArray Then 
		          // this is always an array, but it can be an array of objects
		          Var bufferJSON As JSONItem =  json.Lookup(prop.Name, Nil)
		          
		          Select Case  prop.propertyType.Name
		            // TODO datetime missing
		          Case "String()" 
		            Var bufferArray() As String
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Text()"
		            Var bufferArray() As Text
		            For index As Integer = 0 To bufferJSON.Count-1
		              var val As String = bufferJSON(index)
		              bufferArray.AddRow(val.ToText)
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Int32()"
		            Var bufferArray() As Int32
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Int8()"
		            Var bufferArray() As Int8
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Int16()"
		            Var bufferArray() As Int16
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Int64()"
		            Var bufferArray() As Int64
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Integer()"
		            Var bufferArray() As Integer
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Single()"
		            Var bufferArray() As Single
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Double()"
		            Var bufferArray() As Double
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Boolean()"
		            Var bufferArray() As Boolean
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Case "Variant()"
		            Var bufferArray() As Variant
		            For index As Integer = 0 To bufferJSON.Count-1
		              bufferArray.AddRow(bufferJSON(index))
		            Next
		            prop.Value(Me) = bufferArray
		            
		          Else
		            Var lookupResultFromJson As Variant = json.Lookup(prop.Name, Nil)
		            Var nestedJsonItem As JSONItem = lookupResultFromJson
		            If nestedJsonItem <> Nil And nestedJsonItem.IsArray() Then
		              
		              // we have an array of objects
		              Var countElements As Integer = nestedJsonItem.Count
		              // also the JSON frameworks indicates that this is an array
		              Var complexArray() As IJsonSupport  = Me.fromJSONFactoryArray(prop.Name, countElements)
		              If complexArray <> Nil Then
		                For i As Integer = 0 To countElements- 1
		                  Var complex As IJsonSupport = complexArray(i)
		                  complex.fromJSON(nestedJsonItem.Value(i))
		                Next
		                prop.Value(Me) = complexArray
		                
		              End If
		            End If
		          End Select 
		          
		        End If
		      End If
		      
		    Next
		  End If
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub fromJson(jsonString As String)
		  Call Me.fromJSON(createJsonItem(jsonString))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function fromJSONFactory(fieldName As String, jsonItem As JSONItem = Nil) As IJsonSupport
		  // This method can be overidden to implement IJsonSupport fromJSON kind off recursively
		  // We need this as there is only "local" type information in the classes and subclasses itself,
		  // XOJO LACKS a global type tracking "generics" library at RUNTIME
		  Return Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function fromJsonFactoryArray(fieldName As String, count As Integer) As IJsonSupport()
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getFields() As String()
		  Var emptyArray() As String
		  
		  Return emptyArray
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function getRequiredFields() As String()
		  // As default, there are no required fields for a class, this can be changed using subclassing and overwriting.
		  Var requiredFeildsArray() As String
		  Return requiredFeildsArray
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function includeFieldsWhenEmpty() As String()
		  Var emptyFieldsWhichShouldBeIncluded() As String
		  Return emptyFieldsWhichShouldBeIncluded
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function JSONItem_MTC_TO_DICT(input As JSONItem) As Dictionary
		  Return JSONItem_MTC(input).toDict
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub throwRequiredException(className As String, propName As String, returnableString As String)
		  System.DebugLog("Class Name : " + className + "    Property Name (" + propName +  "): " + returnableString)
		  
		  Var ex As NilObjectException = New NilObjectException()
		  ex.Message = "The property  :  ´" + propName+ "´  in the class ´" + className+ "´  has a nil value"
		  System.Log(System.LogLevelError, "❌ DFKA: mJsonSupport > cJSonSupport > throwRequiredException - Exception: " +_
		  "The property  :  ´" + propName+ "´  in the class ´" + className+ "´  has a nil value")
		  Raise ex
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSON(config As cJsonSupportConfig = Nil) As String
		  Return Me.toJSONItemMTC(config).ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSONItem(config As cJsonSupportConfig = Nil) As JSONItem
		  Return toJSONItemMTC(config)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function toJSONItemMTC(config As cJsonSupportConfig = Nil) As JSONItem_MTC
		  Var returnable As New JSONItem_MTC // = createJsonItem()
		  Var typeInfo As Introspection.TypeInfo = Introspection.GetType(Me)
		  Var propInfos() As Introspection.PropertyInfo = typeInfo.GetProperties()
		  If config = Nil Then
		    config = New cJsonSupportConfig()
		  End If
		  
		  Var fields() As String = Me.getFields()
		  
		  For Each prop As Introspection.PropertyInfo In propInfos
		    If Not prop.IsComputed Then
		      If fields.Count = 0 Or fields.IndexOf(prop.Name) <> -1 Then
		        
		        
		        Var propValue As Variant = prop.Value(Me)
		        // Cheking if all the required feilds in the classes have no null values
		        For Each value As String in Me.getRequiredFields()
		          If prop.Name.Compare(value) = 0 Then
		            // only throw exception when there is a debug build...
		            #If DebugBuild Then
		              If propValue.IsNull Then
		                throwRequiredException(typeInfo.Name, prop.Name, returnable.ToString)
		              ElseIf prop.PropertyType.Name = "String" Then 
		                Var stringValue As String = propValue
		                If stringValue = "" Then
		                  throwRequiredException(typeInfo.Name, prop.Name, returnable.ToString)
		                End If
		              End If
		            #Endif
		          End If
		        Next
		        Me.createJSONFromField(prop, returnable, config)
		      End If
		    End
		  Next
		  
		  Return returnable
		End Function
	#tag EndMethod


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
