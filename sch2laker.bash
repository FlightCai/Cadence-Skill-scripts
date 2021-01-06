#!/bin/bash

##If you have any question, please contact me. flight_cai@126.com;;
##v1.0;JCai;9,Dec.2011;

#input data
declare -a schCellList #declare array
schCellList=(cell1 cell2) #top cell name list.
icfbSchLib="schlib" #icfb Schematic library name.
cdslibFile="/home/xxx/cds.lib" #icfb cds.lib dir.
lakerSchLibDir="." #laker library dir. 
lakerSchLibName="lakerlib_name" #laker library name.
edifinMapFile="laker_edif.map" #laker edif in mapping file.
#end of input


#tools initial
toolStatus=`which laker`
if [[ -n $toolStatus ]] 
then
export PATH=$PATH:/home/userlib1/eda_tools/sprintsoft/laker/2011.02/bin
fi

toolStatus=`which edifout`
if [[ -n $toolStatus ]] 
then
export PATH=$PATH:/tool/edanew/cadence/ic5141/SunOS/tools/dfII/bin
fi

#define edif out
function edifOut()
{
	#file
	edifoutCfgFile=".template.temp";
	edifFile="$schCell.edif";
	\rm -rf $edifoutCfgFile;

	echo edifOutKeys = list\( nil > $edifoutCfgFile;
	echo 		\'runDirectory \".\" >> $edifoutCfgFile;
	echo 		\'outputFile \"$edifFile\"  >> $edifoutCfgFile;
	echo 		\'flattenDir \".\"  >> $edifoutCfgFile;
	echo 		\'library \"$icfbSchLib\"  >>  $edifoutCfgFile;
	echo 		\'cell \"$schCell\" >> $edifoutCfgFile;
	echo 		\'viewName \"schematic\" >> $edifoutCfgFile;
	echo 		\'externalLibList \"\"  >> $edifoutCfgFile;
	echo 		\'scalarOption \"FALSE\"  >> $edifoutCfgFile;
	echo 		\'interpretInhConn \"FALSE\"  >> $edifoutCfgFile;
	echo 		\'scalarWithPortsUnexpanded \"FALSE\"  >> $edifoutCfgFile;
	echo 		\'netlistOption \"FALSE\"  >> $edifoutCfgFile;
	echo		\'outputCDFAsProperty \"TRUE\" >> $edifoutCfgFile;
	echo 		\'skipDupInstNameCk \"FALSE\"  >> $edifoutCfgFile;
	echo 		\'replaceBundleWithArray \"TRUE\"  >> $edifoutCfgFile;
	echo 		\'netlistMode \"Hierarchical\"  >> $edifoutCfgFile;
	echo 		\'hierarchyFile \"\"  >> $edifoutCfgFile;
	echo 		\'stopCellExpansionFile \"\"  >> $edifoutCfgFile;
	echo 		\'ILFile \"\"  >> $edifoutCfgFile;
	echo 		\'design \"\"  >> $edifoutCfgFile;
	echo 		\'techFile \"default.tf\"  >> $edifoutCfgFile;
	echo 		\'ripperLibraryName \"\"  >> $edifoutCfgFile;
	echo		\'ripperCellName \"\"  >> $edifoutCfgFile;
	echo 		\'ripperViewName \"\"  >> $edifoutCfgFile;
	echo 		\)   >> $edifoutCfgFile;

	#icfb edif out
	edifout $edifoutCfgFile -cdslib $cdslibFile;
} #end of edifOut definition

#define edif in
function edifIn()
{
#laker edif in
	\rm lakerEDIFIn.cmd;
	echo "lakerEDIFIn -from Composer -file $edifFile -topCell $schCell -lib $lakerSchLibName -forkChild 0 -overwriteCell 1 -path $lakerSchLibDir -case Preserve -ps 1 -modelMap $edifinMapFile -busParentheses angle">lakerEDIFIn.cmd;
	echo lakerExit >>lakerEDIFIn.cmd
	laker -nogui -play lakerEDIFIn.cmd;
} #end of edifIn definition


#main
if [[ $1 == "-h" ]]
then #help instruction
	echo "$0 transfer Cadence sch library to Laker sch database."
	echo "	Usage: $0 [-i/-o/-h]"
	echo "		-i: only Cadence sch export to edif file."
	echo "		-o: only edif file transfer to Lkaer sch database."
	echo "		-h: help."
	echo "		:default is transfer Cadence sch to Laker database. "
elif [[ $1 == "-i" ]]
then #-i edif in
	for schCell in ${schCellList[@]}
		do
				edifIn
		done
	
elif [[ $1 == "-o" ]]
then #-o edif out
	for schCell in ${schCellList[@]}
		do
				edifOut
		done
else
	for schCell in ${schCellList[@]}
		do
				edifOut
				edifIn
		done
fi

#EOF
