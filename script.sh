function quit(){
	unset answer & unset tutorialrequests & unset row & unset column & unset answer & unset backrequests & unset quitrequests
	exit 1
}

function tutorial(){
dialog --title "Tutorial 1" --msgbox 'You will be asked to enter how many columns and rows you want for the table.... Tutorial incomplete' 20 40
}

dialog --title "Welcome" --msgbox "This is a program seeking ot integrate making basic spreadsheets into LaTeX" 10 40
dialog --title "Continue?" --yesno "Do you want to continue?" 10 20
[ $? -eq 1 ] && exit 1
dialog --title "Tutorial Option" --yesno "Do you want a tutorial on how to use this script?" 10 25
[ $? -eq 0 ] && tutorial

tutorialrequests="help Help HElp HELp HELP hElp hELP heLp heLP hElP HeLp hElP"
quitrequests="quit Quit QUit QUIt qUit qUIT quIt quIT qUiT QuIt qUiT exit Exit EXIT leave escape end finish theend"
backrequests="back Back BAck BACk bAck bACK baCk baCK bAcK BaCk bAcK return Return";
rowreq="row ROW rOW ROw RoW rOw Row roW rows Rows rOws roWs rowS ROws rOWs roWS RoWs rOwS rOWS ROWs RoWS ROwS ROWS";
colreq="col COL cOL COl CoL cOl Col coL cols Cols cOls coLs colS COls cOLs coLS CoLs cOlS cOLS COLs CoLS COlS COLS";
no="no NO No nO"

touch latex.tex

answer='9'
while [[ "$quitrequests" != *"$answer"* ]]
do
	row=$(dialog --title "row number" --inputbox 'Enter the number of rows.' 10 20 3>&1 1>&2 2>&3 3>&-)
	while [[ ! $row =~ ^[0-9]+$ ]]; do
		dialog --title "incorrect" --msgbox "Please enter a number" 10 20
		row=$(dialog --title "row number" --inputbox 'Enter the number of rows.' 10 20 3>&1 1>&2 2>&3 3>&-)
	done
	column=$(dialog --title "column number" --inputbox 'Enter the number of columns.' 10 20 3>&1 1>&2 2>&3 3>&-)
	while [[ ! $column =~ ^[0-9]+$ ]]; do
		dialog --title "incorrect" --msgbox "Please enter a number" 10 20
		column=$(dialog --title "column number" --inputbox 'Enter the number of columns.' 10 20 3>&1 1>&2 2>&3 3>&-)
	done
		echo -n ' \documentclass[12px]{article}
\begin{document}
    \begin{center}
	  \begin{tabular}{' >> latex.tex
	count=0
	while [ ! $count -eq $column ]; do
		echo -n "|c" >> latex.tex
		let "count++"
	done
	dialog --title "row headers" --yesno "do you want row headers" 10 20
	rowheaders=$?
	[ $rowheaders -eq 0 ] && echo -n "|c" >> latex.tex
	echo '|}' >> latex.tex
	echo '\hline ' >> latex.tex
	[ $rowheaders -eq 0 ] && rowheaderscolheader=$(dialog --title "row headerscolumn's header" --inputbox "Header for the row headers column" 10 20 3>&1 1>&2 2>&3 3>&-)
	lecount=1
	[ $rowheaders -eq 0 ] && echo -n '\textbf{'$rowheaderscolheader'} & ' >> latex.tex
	colhead=$(dialog --title "column $lecount header" --inputbox "Enter the header for column $lecount" 10 20 3>&1 1>&2 2>&3 3>&-)
	echo -n '\textbf{'$colhead'} ' >> latex.tex
	while [ ! $lecount -eq $column ]; do
		let "lecount++"
		colhead=$(dialog --title "column $lecount header" --inputbox "Enter the header for column $lecount" 10 20 3>&1 1>&2 2>&3 3>&-)
		echo -n ' & \textbf{'$colhead'}' >> latex.tex
	done
	echo ' \\' >> latex.tex
	answer='9'
	while  [[ "$backrequests" != *"$answer"* ]] && [[ "$quitrequests" != *"$answer"* ]] || [ "$answer" == "" ]; do
		answer=$(dialog --title "Where now?" --inputbox 'would you like to use rows or columns (col/s for columns) ?' 20 40   3>&1 1>&2 2>&3 3>&- )
                [[ "$tutorialrequests" == *"$answer"* ]] && [ "$answer" != "" ] && [[ $answer =~ ^[hH] ]] && tutorial
		ahoy="testnone"
		specialspecialcount=0
                while [[ "$rowreq" == *"$answer"* ]] && [[ "$backrequests" != *"$ahoy"* ]] && [ ! $specialspecialcount -eq $row ]; do
			let = "specialspecialcount++"
			answer='blank'
			sp="9"
			ahoy=$(dialog --title "which row" --inputbox "Which row would you like to go to?"  10 20 3>&1 1>&2 2>&3 3>&- )
			[[ "$rowsetmanuallyalready" == 1 ]] && dialog --title "so?" --yesno "Do you want to set this row manually, or do you want to set it's pattern?" 10 30
			sp=$?
			p=0
			echo ' \hline' >> latex.tex

			cmd=$(dialog --title "run $p " --inputbox "code"  10 20 3>&1 1>&2 2>&3 3>&-)
	                eval $cmd
			echo -n "$res" >> latex.tex
			echo -n " " >> latex.tex

			while [[ "$no" != *"$sp"* ]] && [ ! $p -eq $column ]; do
				cmd=$(dialog --title "run $p" --inputbox "run code"  10 20 3>&1 1>&2 2>&3 3>&-)
		                eval $cmd

				echo -n " & $res" >> latex.tex
				echo -n " " >> latex.tex
				let "p++"
			done
			echo " \\\\" >> latex.tex
		done
		while [[ "$colreq" == *"$answer"* ]]; do
			sp="";
			ahoy=$(dialog --title "which column" --inputbox "Which column would you like to go to?"  10 20 3>&1 1>&2 2>&3 3>&-)
		done
	done
done

dialog --title "Bye" --msgbox "I hope you enjoyed your stay" 20 40
echo " \\hline
          \\end{tabular}
    \\end{center}
\\end{document}" >> latex.tex

pdflatex latex.tex
quit
