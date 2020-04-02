Class constructor
	
	This:C1470.success:=True:C214
	This:C1470.error:=""
	This:C1470.errors:=New collection:C1472
	This:C1470.warning:=""
	This:C1470.warnings:=New collection:C1472
	This:C1470.user:=New object:C1471
	This:C1470.workingBranch:=New object:C1471
	This:C1470.branches:=New collection:C1472
	This:C1470.changes:=New collection:C1472
	This:C1470.history:=New collection:C1472
	This:C1470.remotes:=New collection:C1472
	This:C1470.stashes:=New collection:C1472
	This:C1470.tags:=New collection:C1472
	This:C1470.workingDirectory:=Folder:C1567(Folder:C1567(fk database folder:K87:14;*).platformPath;fk platform path:K87:2)
	This:C1470.git:=This:C1470.workingDirectory.folder(".git")
	This:C1470.gitignore:=This:C1470.workingDirectory.file(".gitignore")
	This:C1470.gitattributes:=This:C1470.workingDirectory.file(".gitattributes")
	This:C1470.local:=File:C1566("/usr/local/bin/git").exists
	This:C1470.version:=""
	
	This:C1470.debug:=(Structure file:C489=Structure file:C489(*))
	
	This:C1470.init()
	
/*————————————————————————————————————————————————————————*/
Function add
	
	C_VARIANT:C1683($1)
	C_VARIANT:C1683($v)
	
	Case of 
			
			  //_____________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			Case of 
					
					  //——————————————————————
				: ($1="all")  // Update the index and adds new files
					
					This:C1470.result:=New collection:C1472
					This:C1470.execute("add -A")
					
					  //——————————————————————
				: ($1="update")  // Update the index, but adds no new files
					
					This:C1470.result:=New collection:C1472
					This:C1470.execute("add -u")
					
					  //——————————————————————
				Else   // Add the given file
					
					This:C1470.execute("add "+Char:C90(Quote:K15:44)+String:C10($1)+Char:C90(Quote:K15:44))
					
					  //——————————————————————
			End case 
			
			  //_____________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			For each ($v;$1)
				
				If (Value type:C1509($v)=Is text:K8:3)
					
					This:C1470.execute("add "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
					
				Else 
					
					This:C1470.pushError("Wrong type of argument")
					
				End if 
			End for each 
			
			  //_____________________________
		Else 
			
			  // ERROR
			
			  //_____________________________
	End case 
	
/*————————————————————————————————————————————————————————*/
Function branch
	
	C_TEXT:C284($1)
	C_TEXT:C284($2)
	C_TEXT:C284($3)
	
	C_TEXT:C284($t)
	C_COLLECTION:C1488($c)
	C_OBJECT:C1216($o)
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	Case of 
			
			  //———————————————————————————————————
		: (Length:C16($t)=0)\
			 | ($t="list")  // Update branch list
			
			This:C1470.branches:=New collection:C1472
			
			If (Git EXECUTE ("branch --list -v"))
				
				For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
					
					$c:=Split string:C1554($t;" ";sk ignore empty strings:K86:1)
					
					If ($c[0]="*")  // Current branch
						
						$o:=New object:C1471(\
							"name";$c[1];\
							"ref";$c[2];\
							"current";True:C214)
						
						This:C1470.workingBranch:=$o
						
					Else 
						
						$o:=New object:C1471(\
							"name";$c[0];\
							"ref";$c[1];\
							"current";False:C215)
						
					End if 
					
					This:C1470.branches.push($o)
					
				End for each 
			End if 
			
			  //———————————————————————————————————
		: ($t="master")  // Return on the main branch
			
			If (Git EXECUTE ("checkout master"))
				
				This:C1470.branch()
				
			End if 
			
			  //———————————————————————————————————
		: (Count parameters:C259<2)\
			 | (Length:C16(String:C10($2))=0)
			
			This:C1470.pushError("Missing branch name!")
			
			  //———————————————————————————————————
		: ($t="create")  // Create a new branch
			
			If (Git EXECUTE ("branch "+String:C10($2)))
				
				This:C1470.branch()
				
			End if 
			
			  //———————————————————————————————————
		: ($t="createAndUse")  // Create a new branch and select it
			
			If (Git EXECUTE ("checkout -b "+String:C10($2)))
				
				This:C1470.branch()
				
			End if 
			
			  //———————————————————————————————————
		: ($t="use")  // Select a branch to use
			
			If (Git EXECUTE ("checkout "+$2+" --no-ff -m Merging branch "+$2))
				
				This:C1470.branch()
				
			End if 
			
			  //———————————————————————————————————
		: ($t="merge")  // Merge a branch to the current branch
			
			If (Git EXECUTE ("merge "+String:C10($2)))
				
				This:C1470.branch()
				
			End if 
			
			  //———————————————————————————————————
		: ($t="delete@")
			
			If (Git EXECUTE ("branch -"+Choose:C955($t="deleteForce";"D";"d")+" "+String:C10($2)))
				
				This:C1470.branch()
				
			End if 
			
			  //———————————————————————————————————
		: (Count parameters:C259<3)\
			 | (Length:C16(String:C10($3))=0)
			
			This:C1470.pushError("Missing branch new name!")
			
			  //———————————————————————————————————
		: ($t="rename")  // Rename a branch
			
			If (Git EXECUTE ("branch -m "+String:C10($2)+" "+String:C10($3)))
				
				If (Git EXECUTE ("push origin :"+String:C10($2)))
					
					If (Git EXECUTE ("push --set-upstream origin "+String:C10($3)))
						
						This:C1470.branch()
						
					End if 
				End if 
			End if 
			
			  //———————————————————————————————————
			
		Else 
			
			This:C1470.pushError("Unmanaged entrypoint for branch method: "+$t)
			
			  //———————————————————————————————————
	End case 
	
/*————————————————————————————————————————————————————————*/
Function checkout
	
	C_VARIANT:C1683($1)
	C_VARIANT:C1683($v)
	
	Case of 
			
			  //_____________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			This:C1470.execute("checkout -- "+Char:C90(Quote:K15:44)+String:C10($1)+Char:C90(Quote:K15:44))
			
			  //_____________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			For each ($v;$1)
				
				If (Value type:C1509($v)=Is text:K8:3)
					
					This:C1470.execute("checkout -- "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
					
				Else 
					
					  // ERROR
					
				End if 
			End for each 
			
			  //_____________________________
		Else 
			
			  // ERROR
			
			  //_____________________________
	End case 
	
/*————————————————————————————————————————————————————————*/
Function commit
	
	C_TEXT:C284($1)
	C_BOOLEAN:C305($2)
	
	C_TEXT:C284($t)
	
	This:C1470.status()
	
	If (This:C1470.changes.length>0)
		
		$t:=Choose:C955(Length:C16($1)=0;"Initial commit";$1)
		
		If ($2)
			
			Git EXECUTE ("commit --amend --no-edit")
			
		Else 
			
			Git EXECUTE ("commit -m "+Char:C90(Quote:K15:44)+$t+Char:C90(Quote:K15:44))
			
		End if 
		
	Else 
		
		This:C1470.pushWarning("Nothing to commit")
		
	End if 
	
/*————————————————————————————————————————————————————————*/
Function diff
	
	C_TEXT:C284($1)
	C_TEXT:C284($2)
	
	C_BOOLEAN:C305($b)
	
	If (Count parameters:C259>=2)
		
		$b:=Git EXECUTE ("diff -w "+String:C10($2)+" -- "+$1)
		
	Else 
		
		$b:=Git EXECUTE ("diff -w -- '"+$1+"'")
		
	End if 
	
	If ($b)
		
		This:C1470.result:=Replace string:C233(This:C1470.result;"\r\n";"\n")
		This:C1470.result:=Replace string:C233(This:C1470.result;"\r";"\n")
		
	End if 
	
/*————————————————————————————————————————————————————————*/
Function diffTool
	
	C_TEXT:C284($1)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"false")
	
	Git EXECUTE ("difftool -y '"+$1+"'")
	
/*————————————————————————————————————————————————————————*/
Function execute
	
	C_VARIANT:C1683($1)
	
	Git EXECUTE ($1)
	
/*————————————————————————————————————————————————————————*/
Function push
	
	C_OBJECT:C1216($o)
	
	If (Count parameters:C259>=2)
		
		This:C1470.execute("push "+String:C10($1)+" "+String:C10($2))
		
	Else 
		
		This:C1470.execute("push origin master")
		
	End if 
	
	If (Not:C34(This:C1470.success))
		
		This:C1470.success:=(Position:C15("Everything up-to-date";This:C1470.error)>0)
		  //"To https://github.com/vdelachaux/4DPop-Git.git\n   079bfde..4ce5cc3  master -> master\n"
		
		If (This:C1470.success)
			
			  // Remove error & warning
			This:C1470.error:=""
			This:C1470.warning:=""
			This:C1470.history[0].success:=True:C214
			
		End if 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function getRemotes
	
	C_TEXT:C284($t)
	C_COLLECTION:C1488($c)
	
	This:C1470.remotes.clear()
	
	If (Git EXECUTE ("remote -v"))
		
		For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
			
			$c:=Split string:C1554($t;"\t";sk ignore empty strings:K86:1)
			
			If (This:C1470.remotes.query("name=:1";$c[0]).length=0)
				
				This:C1470.remotes.push(New object:C1471(\
					"name";$c[0];\
					"url";Substring:C12($c[1];1;Position:C15(" (";$c[1])-1)))
				
			End if 
		End for each 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function getTags
	
	C_TEXT:C284($t)
	
	This:C1470.tags.clear()
	
	If (Git EXECUTE ("tag"))
		
		For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
			
			This:C1470.tags.push($t)
			
		End for each 
	End if 
	
/*—————————————————————————————————————————————————————-——*/
Function init
	
	C_LONGINT:C283($end;$start)
	
	If (Git EXECUTE ("init"))
		
		If (Not:C34(This:C1470.gitignore.exists))
			
			  // Create default gitignore
			This:C1470.gitignore.setText(File:C1566("/RESOURCES/gitignore.txt").getText("UTF-8";Document with CR:K24:21);"UTF-8";Document with LF:K24:22)
			
		End if 
		
		If (Not:C34(This:C1470.gitattributes.exists))
			
			  // Create default gitignore
			This:C1470.gitattributes.setText(File:C1566("/RESOURCES/gitattributes.txt").getText("UTF-8";Document with CR:K24:21);"UTF-8";Document with LF:K24:22)
			
		End if 
		
		  // Ignore file permission
		Git EXECUTE ("config core.filemode false")
		
		If (Git EXECUTE ("config --get user.name"))
			
			This:C1470.user.name:=Replace string:C233(This:C1470.result;"\n";"")
			
		End if 
		
		If (Git EXECUTE ("config --get user.email"))
			
			This:C1470.user.email:=Replace string:C233(This:C1470.result;"\n";"")
			
		End if 
		
		If (Git EXECUTE ("version"))
			
			This:C1470.version:=Replace string:C233(This:C1470.result;"\n";"")
			
			If (Match regex:C1019("(?m-si)\\d+(?:\\.\\d+)?(?:\\.\\d+)?";This:C1470.result;1;$start;$end))
				
				This:C1470.version:=Substring:C12(This:C1470.result;$start;$end)
				
			Else 
				
				  // Return full result
				This:C1470.version:=Replace string:C233(This:C1470.result;"\n";"")
				
			End if 
		End if 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function open
	
	C_TEXT:C284($1)
	
	C_TEXT:C284($tIN;$tOUT;$tERROR)
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE";"true")
	
	Case of 
			
			  //——————————————————————
		: ($1="terminal")  // Open terminal in the working directory
			
			LAUNCH EXTERNAL PROCESS:C811("open -a terminal '"+This:C1470.workingDirectory.path+"'";$tIN;$tOUT;$tERROR)
			
			  //——————————————————————
		: ($1="show")  // Open on disk the current directory
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_CURRENT_DIRECTORY";String:C10(This:C1470.workingDirectory.platformPath))
			LAUNCH EXTERNAL PROCESS:C811("open .";$tIN;$tOUT;$tERROR)
			
			  //——————————————————————
	End case 
	
	This:C1470.success:=Bool:C1537(OK) & (Length:C16($tERROR)=0)
	
	Case of 
			
			  //——————————————————————
		: (This:C1470.success)
			
			This:C1470.error:=""
			
			  //——————————————————————
		: (Length:C16($tERROR)>0)
			
			This:C1470.pushError($tERROR)
			
			  //——————————————————————
	End case 
	
/*————————————————————————————————————————————————————————*/
Function pushError
	
	C_TEXT:C284($1)
	
	This:C1470.error:=$1
	This:C1470.errors.push($1)
	
/*————————————————————————————————————————————————————————*/
Function pushWarning
	
	C_TEXT:C284($1)
	
	This:C1470.warning:=$1
	This:C1470.warnings.push($1)
	
/*————————————————————————————————————————————————————————*/
Function status
	
	C_TEXT:C284($t)
	
	This:C1470.changes.clear()
	
	If (Git EXECUTE ("status -s -uall"))
		
		If (Position:C15("\n";String:C10(This:C1470.result))>0)
			
			For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
				
				This:C1470.changes.push(New object:C1471(\
					"status";$t[[1]]+$t[[2]];\
					"path";Delete string:C232($t;1;3)))
				
			End for each 
		End if 
	End if 
	
/*————————————————————————————————————————————————————————*/
Function stash
	
	C_TEXT:C284($1)
	
	C_TEXT:C284($t)
	C_OBJECT:C1216($o)
	
	ARRAY LONGINT:C221($aLpos;0x0000)
	ARRAY LONGINT:C221($aLlength;0x0000)
	
	If (Count parameters:C259>=1)
		
		$t:=String:C10($1)
		
	End if 
	
	Case of 
			
			  //———————————————————————————————————
		: (Length:C16($t)=0)\
			 | ($t="list")  // Update branch list
			
			This:C1470.stashes:=New collection:C1472
			
			If (Git EXECUTE ("stash list"))
				
				For each ($t;Split string:C1554(This:C1470.result;"\n";sk ignore empty strings:K86:1))
					
					If (Match regex:C1019("(?mi-s)^([^:]*):\\s([^:]*)(?::\\s([[:alnum:]]{7})\\s([^$]*))?$";$t;1;$aLpos;$aLlength))
						
						If ($aLpos{3}#-1)
							
							$o:=New object:C1471(\
								"name";Substring:C12($t;$aLpos{1};$aLlength{1});\
								"message";Substring:C12($t;$aLpos{2};$aLlength{2});\
								"ref";Substring:C12($t;$aLpos{3};$aLlength{3});\
								"refMessage";Substring:C12($t;$aLpos{4};$aLlength{4})\
								)
							
						Else 
							
							$o:=New object:C1471(\
								"name";Substring:C12($t;$aLpos{1};$aLlength{1});\
								"message";Substring:C12($t;$aLpos{2};$aLlength{2})\
								)
							
						End if 
						
						This:C1470.stashes.push($o)
						
					End if 
				End for each 
			End if 
			
		Else 
			
			This:C1470.pushError("Unmanaged entrypoint for stash method: "+$t)
			
	End case 
	
/*————————————————————————————————————————————————————————*/
Function unstage
	
	C_VARIANT:C1683($1)
	
	C_VARIANT:C1683($v)
	
	Case of 
			
			  //_____________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			Git EXECUTE ("reset HEAD "+Char:C90(Quote:K15:44)+$1+Char:C90(Quote:K15:44))
			
			  //_____________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			For each ($v;$1)
				
				If (Value type:C1509($v)=Is text:K8:3)
					
					Git EXECUTE ("reset HEAD "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
					
				Else 
					
					  // ERROR
					
				End if 
			End for each 
			
			  //_____________________________
		Else 
			
			  // ERROR
			
			  //_____________________________
	End case 
	
/*————————————————————————————————————————————————————————*/
Function untrack
	
	C_VARIANT:C1683($1)
	
	C_VARIANT:C1683($v)
	
	Case of 
			
			  //_____________________________
		: (Value type:C1509($1)=Is text:K8:3)
			
			Git EXECUTE ("rm --cached "+Char:C90(Quote:K15:44)+$1+Char:C90(Quote:K15:44))
			
			  //_____________________________
		: (Value type:C1509($1)=Is collection:K8:32)
			
			For each ($v;$1)
				
				If (Value type:C1509($v)=Is text:K8:3)
					
					Git EXECUTE ("rm --cached "+Char:C90(Quote:K15:44)+$v+Char:C90(Quote:K15:44))
					
				Else 
					
					  // ERROR
					
				End if 
			End for each 
			
			  //_____________________________
		Else 
			
			  // ERROR
			
			  //_____________________________
	End case 
	
/*————————————————————————————————————————————————————————*/