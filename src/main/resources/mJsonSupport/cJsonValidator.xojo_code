#tag Class
Protected Class cJsonValidator
	#tag Method, Flags = &h0
		Function ValidateJSONFile(JsonSchemaFilePath As String, JsonStringFilePath As String, JsonFileValidatorBinaryFilePath As String) As String
		  Try
		    Var s As Shell =  New Shell
		    
		    // Existing paths to the JsonSchema, JsonString and the JsonValidatorBinaryFile
		    // JsonValidator Binary file is a GoLang project 
		    'Var JsonSchemaFilePath As String = "file:///Users/boni/Desktop/2_1_1/taxonomie-schema.json"
		    'Var JsonStringFilePath As String = "file:///Users/boni/Desktop/2_1_1/taxonomie-struktur.json"
		    'Var JsonValidatorBinaryFilePath As String = "/Users/boni/devel/GoLangProjects/JsonValidator/JsonValidator "
		    Var cmdValidateJson As String =  JsonFileValidatorBinaryFilePath + "  " +  JsonSchemaFilePath + "  " + JsonStringFilePath
		    
		    #If TargetWindows Then
		      s.Execute(cmdValidateJson)
		    #ElseIf TargetMacOS Or TargetLinux Then
		      s.Execute(cmdValidateJson)
		    #Endif
		    
		    If s.ErrorCode = 0 Then
		      System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONFile - Recieved Content : " + s.Result)
		      System.DebugLog("Recieved Content : " + s.Result)
		      Return s.Result
		    Else
		      System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONFile - Error code: " + s.ExitCode.ToString)
		      Return s.ExitCode.ToString
		    End If
		    
		  Catch n As NetworkException 
		    System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONFile - Network Exception: "+_
		    n.Message)
		    Return n.Message
		  Catch r As RuntimeException
		    System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONFile - RuntimeException: "+_
		    r.Message)
		    Return r.Message
		  End Try
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValidateJSONString(JsonSchema As String, JsonString As String, JsonStringValidatorBinaryFilePath As String) As String
		  Try
		    
		    Var s As Shell =  New Shell
		    
		    // Existing paths to the JsonSchema, JsonString and the JsonValidatorBinaryFile
		    // JsonValidator Binary file is a GoLang project 
		    Var cmdValidateJson As String =  JsonStringValidatorBinaryFilePath + "  " +  JsonSchema  + "  " + JsonString
		    
		    #If TargetWindows Then
		      s.Execute(cmdValidateJson)
		    #ElseIf TargetMacOS Or TargetLinux Then
		      s.Execute(cmdValidateJson)
		    #Endif
		    
		    If s.ErrorCode = 0 Then
		      System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONString - Recieved Content : " + s.Result)
		      System.DebugLog("Recieved Content : " + s.Result)
		      Return s.Result
		    Else
		      System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONString - Error code: " + s.ExitCode.ToString) 
		      // MessageBox("Error code: " + s.ExitCode.ToString)
		      Return s.ExitCode.ToString
		    End If
		    
		  Catch n As NetworkException
		    System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONString - Network Exception"+_
		    n.Message)
		    // MessageBox("Network Exception"+n.Message)
		    Return n.Message
		  Catch r As RuntimeException
		    System.Log(System.LogLevelError,"❌ DFKA: mJsonSupport > cJsonValidator > ValidateJSONString - Run Time Exception"+_
		    r.Message)
		    // MessageBox("Run Time Exception"+r.Message)
		    Return r.Message
		  End Try
		  
		  
		End Function
	#tag EndMethod


End Class
#tag EndClass
