//%attributes = {"invisible":true}
$0:=New object:C1471

Case of 
		
		  //______________________________________________________
	: (This:C1470.status="??")\
		 | (This:C1470.status="A@")  // New (staged or not)
		
		$0.fill:=Form:C1466.colors.new
		
		  //______________________________________________________
	: (This:C1470.status="@D@")  // Deleted (staged or not)
		
		$0.fill:=Form:C1466.colors.deleted
		
		  //______________________________________________________
	: (This:C1470.status="RM")  // Moved
		
		  //
		
		  //______________________________________________________
	: (This:C1470.status="@M@")  // Modified
		
		$0.fill:=Form:C1466.colors.modified
		
		  //______________________________________________________
	Else 
		
		  //
		
		  //______________________________________________________
End case 