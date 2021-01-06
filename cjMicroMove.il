/*Skill Program
project name:MicroMove Objects
Writen by Jcai@winbond
If you have any question pls call 1823!!!
                                                                                
Enjoy your work, enjoy your life!!!
Wahahaha!!!

Tue Apr 17 23:53:34 CST 2007
*/


;;selset~>XY operation. objType including "mosaic" "inst" "label"

procedure(cjXY(instr pitch objectDB);=>return one xy list
 prog( (obXYCoode obXCoode obYCoode)

	if( (objectDB~>objType!='("mosaic")&&objectDB~>objType!='("inst")&&objectDB~>objType!='("label"))
		then 	println("cjXY-objType err") 
		return()
	  );fi

	obXYCoode=objectDB~>xy
	obXCoode=caar(obXYCoode)
        obYCoode=cadar(obXYCoode)

	case( instr
		( "up"
        		obYCoode=obYCoode+pitch			
		)

		( "down"
        		obYCoode=obYCoode-pitch
		)

		( "left"
			obXCoode=obXCoode-pitch
		)

		( "right"
			obXCoode=obXCoode+pitch
		)

		( nil
			println("cjXY-instr nil")
			return()
		)

	);case

	obXYCoode=list(obXCoode obYCoode)

	return(obXYCoode)

 );end of prog		
);end of cjXY


;;selset~>bBox operation. objType including "rect"

procedure(cjBBox(instr pitch objectDB);=>return one bBox list
 prog( (obBBox obX1Coode obY1Coode obX2Coode obY2Coode)

	if( (objectDB~>objType!='("rect"))
		then 	println("cjBBox-objType err") 
			return()
	);fi

	obBBox=objectDB~>bBox
	obX1Coode=caaar(obBBox)
	obY1Coode=cadaar(obBBox)
	obX2Coode=caadar(obBBox)
	obY2Coode=car(cdadar(obBBox))

	case( instr
		( "up"
			obY1Coode=obY1Coode+pitch
			obY2Coode=obY2Coode+pitch
		)

		( "down"
			obY1Coode=obY1Coode-pitch
        		obY2Coode=obY2Coode-pitch
		)

		( "left"
			obX1Coode=obX1Coode-pitch
        		obX2Coode=obX2Coode-pitch
		)

		( "right"
			obX1Coode=obX1Coode+pitch
        		obX2Coode=obX2Coode+pitch
		)

		( nil
			println("cjBBox-instr nil")
			return()
		)
	
	);case


	obBBox=list(list(obX1Coode obY1Coode) list(obX2Coode obY2Coode))
	return(obBBox)

 );end of prog
);end of cjBBox


;;selset~>Point operation. objType including "path" "polygon"

procedure(cjPoint(instr pitch objectDB);=>return one points list
 prog( (obPts obPtn restPts nowPts newPts obXcoode obYcoode)

	if( (objectDB~>objType!='("path")&&objectDB~>objType!='("polygon"))

		then 	println("cjPoint-objType err") 
			return()
	  );fi

	obPts=objectDB~>points
	restPts=car(obPts)
	newPts=tconc(nil '());initial the newPts. sklanguser.pdf p184.

	case( instr
		( "up"
			while( (restPts!=nil)
				nowPts=car(restPts)
				restPts=cdr(restPts)
				obXcoode=car(nowPts)
				obYcoode=cadr(nowPts)+pitch
				tconc(newPts list(obXcoode obYcoode))
			);while

			newPts=cdar(newPts);get the new point from tconc
		)

		( "down"
			while( (restPts!=nil)
				nowPts=car(restPts)
				restPts=cdr(restPts)
				obXcoode=car(nowPts)
				obYcoode=cadr(nowPts)-pitch
				tconc(newPts list(obXcoode obYcoode))
			);while

			newPts=cdar(newPts);get the new point from tconc
		)

		( "left"
			while( (restPts!=nil)
				nowPts=car(restPts)
				restPts=cdr(restPts)
				obXcoode=car(nowPts)-pitch
				obYcoode=cadr(nowPts)
				tconc(newPts list(obXcoode obYcoode))
			);while

			newPts=cdar(newPts);get the new point from tconc
		)

		( "right"
			while( (restPts!=nil)
				nowPts=car(restPts)
				restPts=cdr(restPts)
				obXcoode=car(nowPts)+pitch
				obYcoode=cadr(nowPts)
				tconc(newPts list(obXcoode obYcoode))
			);while

			newPts=cdar(newPts);get the new point from tconc
		)

		( nil
			println("cjPoint-instr nil")
			return()
		)

	);case 

	return(newPts)
 );prog
);end of cjPoint


;;cjMicroMove fuction
procedure(cjMicroMove(instr)
 prog( (curwin selset pitch obj)

	curwin=hiGetCurrentWindow()
	selset=geGetSelSet()
	pitch=curwin~>ySnapSpacing

	foreach(selset geGetSelSet()
		case( selset~>objType
			( ("mosaic" "inst" "label")
				obj=list(selset)
				obj~>xy=cjXY(instr pitch obj)
			)

			( "rect"
				obj=list(selset)
				obj~>bBox=cjBBox(instr pitch obj)	
			)

			( ("path" "polygon")
				obj=list(selset)
				obj~>points=cjPoint(instr pitch obj)	
			)
			
			( t
				println("no objType")	
			)
		);case	
	);foreach	

 );prog
);end of cjMicroMove

procedure(cjMicroMoveUp()
	cjMicroMove("up")
);

procedure(cjMicroMoveDown()
	cjMicroMove("down")
);

procedure(cjMicroMoveLeft()
	cjMicroMove("left")
);

procedure(cjMicroMoveRight()
	cjMicroMove("right")
);


;;set bind key
hiSetBindKey("Layout" "Alt<Key>Up" "cjMicroMoveUp()")
hiSetBindKey("Layout" "Alt<Key>Down" "cjMicroMoveDown()")
hiSetBindKey("Layout" "Alt<Key>Left" "cjMicroMoveLeft()")
hiSetBindKey("Layout" "Alt<Key>Right" "cjMicroMoveRight()")
;;endof bind key
                                                                                
;;all end

