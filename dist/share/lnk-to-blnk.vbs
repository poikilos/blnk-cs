
If Wscript.Arguments.Count > 0 Then
	strLinkFilePath = Wscript.Arguments(0)
	' must take at least one argument, which is the LNK Shortcut filename
	' second argument can be path to blnk file to create or overwrite (otherwise blnk file is placed in same folder as existing lnk file from first argument)
	If LCase(Right(strLinkFilePath, 4)) = ".lnk" Then
		If Len(strLinkFilePath) > 1 And Left(strLinkFilePath,1) = """" And Right(strLinkFilePath,1) = """" Then
			strLinkFilePath = Mid(strLinkFilePath,2,Len(strLinkFilePath)-2)
		End If
		Set objFSO=CreateObject("Scripting.FileSystemObject")
		If objFSO.FileExists(strLinkFilePath) Then
			Set wshShell = CreateObject("WScript.Shell")
			' CreateShortcut works like a GetShortcut when the shortcut already exists!
			Set objShortcut = wshShell.CreateShortcut(strLinkFilePath)

			' For URL shortcuts, only ".FullName" and ".TargetPath" are valid
			' FullName is path of the LNK file itself!!!!
			'WScript.Echo "Full Name         : " & objShortcut.FullName
			'WScript.Echo "Arguments         : " & objShortcut.Arguments
			'WScript.Echo "Working Directory : " & objShortcut.WorkingDirectory
			'WScript.Echo "Target Path       : " & objShortcut.TargetPath
			'WScript.Echo "Icon Location     : " & objShortcut.IconLocation
			'WScript.Echo "Hotkey            : " & objShortcut.Hotkey
			'WScript.Echo "Window Style      : " & objShortcut.WindowStyle
			'WScript.Echo "Description       : " & objShortcut.Description
			'("Type:"  ' Application, Link, or Directory
			

			' How to write file
			strBlinkFilePath=Left(strLinkFilePath,Len(strLinkFilePath)-4) & ".blnk"
			If Wscript.Arguments.Count > 1 Then
				strBlinkFilePath=Wscript.Arguments(1)
				If Len(strBlinkFilePath) > 1 And Left(strBlinkFilePath,1) = """" And Right(strBlinkFilePath,1) = """" Then
					strBlinkFilePath = Mid(strBlinkFilePath,2,Len(strBlinkFilePath)-2)
				End If
			End If
			Set objFile = objFSO.CreateTextFile(strBlinkFilePath,True)
			IsDirectory = False
			objFile.Write "Content-Type: text/blnk" & vbCrLf
			If Len(objShortcut.TargetPath) < 1 Or objFSO.FolderExists(objShortcut.TargetPath) Then
				objFile.Write "Type:Directory" & vbCrLf
				IsDirectory = True
			Else
				objFile.Write "Type:Application" & vbCrLf
			End If
			If Len(objShortcut.WorkingDirectory) > 0 Then objFile.Write "Path:" & objShortcut.WorkingDirectory & vbCrLf
			If Len(objShortcut.IconLocation) > 0 And objShortcut.IconLocation <> ",0" Then objFile.Write "Icon:" & objShortcut.IconLocation & vbCrLf
			objFile.Write "NoDisplay:true" & vbCrLf
			objFile.Write "Terminal:false" & vbCrLf
			'Set objFile = objFSO.GetFile(strLinkFilePath)
			'strLinkFileName = objFSO.GetFileName(objFile)
			'strName = Left(strLinkFileName,Len(strLinkFileName)-4)
			strBlinkFileName = strBlinkFilePath
			iLastSlash = InStrRev(strBlinkFilePath, "\")
			If iLastSlash > 0 Then
				strBlinkFileName = Right(strBlinkFilePath,Len(strBlinkFilePath)-iLastSlash)
			End If
			strName = Left(strBlinkFileName, Len(strBlinkFileName) - 5)
			
			objFile.Write "Name:" & strName & vbCrLf
			'objFile.Write "GenericName:" & Left(strLinkFilePath,Len(strLinkFilePath)-4) & vbCrLf  ' GenericName is only used for generalizing software such as calling Firefox "Internet"
			objFile.Write "Encoding:UTF-8" & vbCrLf
			objFile.Write "Comment:File or folder shortcut generated by lnk-to-blnk" & vbCrLf
			If Len(objShortcut.Arguments) > 0 Then objFile.Write "Arguments:" & objShortcut.Arguments
			'If Len(objShortcut.TargetPath) > 0 Then
				objFile.Write "Exec:" & objShortcut.TargetPath & vbCrLf  ' Link Target
				
			'Else
			'	MsgBox "WARNING: There is no target so '" & strBlinkFilePath & "' will do nothing just like received file '" & strLinkFilePath & "'", vbOKOnly, "link-to-blnk"
			'End If
			objFile.Close


			Set objShortcut = Nothing
			Set wshShell    = Nothing
		Else
			MsgBox "Unable to process nonexistant file " & vbLf & strLinkFilePath, vbOKOnly, "link-to-blnk"
		End If
	Else
		MsgBox "Unable to process non-link file " & vbLf & strLinkFilePath, vbOKOnly, "link-to-blnk"
	End If
Else
	MsgBox "There are zero parameters. You must use a lnk file as the first parameter.", vbOKOnly, "link-to-blnk"
End If