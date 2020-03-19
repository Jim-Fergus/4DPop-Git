//%attributes = {}
C_BOOLEAN:C305($bRelative)
C_TEXT:C284($t;$tVersion)
C_OBJECT:C1216($file;$git;$o)
C_COLLECTION:C1488($c)

Case of 
		
		  //______________________________________________________
	: (True:C214)
		
		$git:=cs:C1710.Git.new()
		$tVersion:=$git.version("short")
		
		$git.status()
		$git.getBranches()
		
		$git.execute()
		ASSERT:C1129($git.error#"")
		
		$git.getRemotes()
		$git.getTags()
		
		$file:=Folder:C1567(Folder:C1567(fk database folder:K87:14).platformPath;fk platform path:K87:2).file("Project/Sources/Methods/GITLAB_EXECUTE.4dm")
		$git.diff($file)
		
		$git.diffTool("Project/Sources/Methods/GITLAB_EXECUTE.4dm")
		
		$git.open("disk")
		
		  //______________________________________________________
	: (True:C214)
		
		$t:="ABCDEF"
		$t:=Delete string:C232($t;-1;2)
		
		$t:="ABCDEF/**"
		$t:=Delete string:C232($t;Length:C16($t)-2;3)
		
		  //______________________________________________________
	: (True:C214)
		
		$t:="doc/frotz/"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="/doc"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="/doc/frotz"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="doc/frotz"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129($bRelative)
		
		$t:="frotz/"
		$bRelative:=Choose:C955(Position:C15("/";$t)=1;True:C214;Split string:C1554($t;"/";sk ignore empty strings:K86:1).length>1)
		ASSERT:C1129(Not:C34($bRelative))
		
		  //______________________________________________________
	: (False:C215)
		
		$o:=cs:C1710.Git.new()
		
		$o.execute("log --abbrev-commit --oneline")
		$o.execute("log --abbrev-commit --format=%s,%an,%h,%aD")
		
		$c:=Split string:C1554($o.result;"\n")
		
		  //______________________________________________________
	Else 
		
		  // A "Case of" statement should never omit "Else"
		  //______________________________________________________
End case 