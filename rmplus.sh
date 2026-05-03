#!/bin/zsh

## Define text to be displayed when the --help argument is passed to rmplus
HELPTEXT_HEAD="[*] rmplus+ secure delete \n";
HELPTEXT_DEV="[*] developed by lorelei - https://github.com/rfcl)\n\nusage: rmplus --args [filename]\n\nAcceptable arguments:"
HELPTEXT_ARG_HELP="\-\-help display simple help and usage"
HELPTEXT_ARG_HOW="\-\-how display explanation of how rmplus works"
HELPTEXT_ARG_FORCE="\-\-prompt confirm file removal by prompting for deletion when ready"
#HELPTEXT_ARG_VERBOSE="\-\-v show verbose output"
HELPTEXT_ARG_VERBOSE=''
HELPTEXT=($HELPTEXT_HEAD $HELPTEXT_DEV $HELPTEXT_ARG_FORCE $HELPTEXT_ARG_HELP $HELPTEXT_ARG_HOW $HELPTEXT_ARG_VERBOSE)

## Identify file targeted for secure removal from last argument passed to rmplus and record to global variable
FILE_TO_RM_IDX=${#argv};
FILE_TO_RM="$argv[$FILE_TO_RM_IDX]";

## Set default filename for temportary outfile to for captured entropy
ENTROPY_CAPTURE_OUTFILE="entropy_rand_capture.out"

## Set default minimum bytes of entropy captured from /dev/urandom and microphone capture
## Increasing this number will increase time to complete entropy capture but improve the quality of entropy.
ENTROPY_OUT_FS=600000
VERBOSE_OUTPUT=''

## Define how many windows of capture will occur for each iteration until minimum bytes of entropy are captured. 
## Increasing this number will increase time to complete entropy capture but improve the quality of entropy.
RAND_ENTROPY_ITERS=2

## Define how many windows of capture will occur for each iteration until minimum bytes of entropy are captured. 
## Increasing this number will increase time to complete entropy capture but improve the quality of entropy.
PER_WINDOW_CAPTURE_ITERS=2

## Set the time period duration of microphone recording for entropy capture
TMP_FF_REC_TIME=1

##Set default --prompt setting
AUTOMATIC_RM='true'

## Define utility functions

 ## Function to convert numbers to absolute values (for use with mouse input entropy modifier)
# function getabs(){
#     (( n = $1))
# 	echo $n
#     if (( n < 0 )); then 
#     	absval=$(echo $1 | sed 's/\-//g')
#     fi
# 	nh=$(( absval ))
# 	echo $nh
# }

## Evaluate additional options from arguments to passed to rmplus
 for val in "${argv[@]}" 
 do		
		## Check arguments for --help optiom which displays rmplus usage and options before exiting.
 		if [[ $val == "--help" ]]
			then 
			
 		 		for HELP_COMPONENT in $HELPTEXT 
				do
					print $HELP_COMPONENT
				done		
 		 		return 0 2>/dev/null || exit 0

		elif [[ $val == "--how" ]]
			then
 		  		print "[~] rmplus\ncommand shortened from:\n\nshred -f -z -n 7 -u -v --random-source /dev/urandom [filename]";
 		  		return 0 2>/dev/null || exit 0
		
		elif [[ $val == "--v" ]]
			then
				VERBOSE="-v";
				print "[!] Verbose shred output enabled"
		
		elif [[ $val == "--p" ]]
			then
				AUTOMATIC_RM="false"
				print "[!] Prompt before removal enabled"

		fi
 done

##Check for existence of file to remove
 if  [[ -f $FILE_TO_RM ]]
	then
	 	 print "[~] rmplus: preparing to generate entropy and securely remove $FILE_TO_RM";

 	else
		 print "[-] file not found: $FILE_TO_RM\n";
 		 print "[~] usage: rmplus [filename]";

 		 return 3 2>/dev/null || exit 1

fi

###### Capture entropy from /dev/urandom and microphone input ######

 ## Initialize temporary entropy capture output file
rm -rf $ENTROPY_CAPTURE_OUTFILE
touch $ENTROPY_CAPTURE_OUTFILE
window_iters=0

## Check for filesize of temporary entropy output file and continue capturing output until minimum bytes of entropy are captured.
until [ -n "$(find "$ENTROPY_CAPTURE_OUTFILE" -prune -size +$(echo $ENTROPY_OUT_FS)c)" ]; 
	do
		# Iterate for each window of capture defined in RAND_ENTROPY_ITERS
		for rand_entropy_idx in {1..$((RAND_ENTROPY_ITERS))..1}
			do
				echo "[~] Starting next entropy capture window"
				# Randomize timing of entropy capture
				for rand_entropy_stream in {1...$(shuf -i 1000-2000 -n 1)...$(shuf -i 1000-2000 -n 1)}
					do

						#Capture chunked entropy data from /dev/urandom stream and randomize data selection
						print "[~] Attempting to capture entropy data from /dev/urandom"
						entropy_rand_capture=$(head -n $(shuf -i 5-15 -n 1) /dev/urandom)
						
						#Write each chunk of chunk of captured entropy data to temporary outfile
						print "[~] Writing captured entropy data from /dev/urandom to temporary outfile"
						echo $entropy_rand_capture >> $ENTROPY_CAPTURE_OUTFILE
						print "\n\n [~] [ffmpeg] attempting to capture audio from microphone input to file $tmp_ff_a_fname"

						
						print "[~] Capturing and writing microphone, mouse movement, and /dev/urandom entropy data to temporary outfile"
						print "[!] Please move your cursor as much as possible or continue normal use until entropy capture is completed"

						per_window_iters=0
						until [[ $per_window_iters -eq $PER_WINDOW_CAPTURE_ITERS ]]
							do
								
								x_loc=$(cliclick p 2>/dev/null | sed 's/\,[0-9]*//')
								x_loc_abs=$(echo $x_loc | awk '{print sqrt($1*$1)}')
								entropy_rand_capture=$(head -n $x_loc_abs /dev/urandom)
								echo $entropy_rand_capture >> $ENTROPY_CAPTURE_OUTFILE

								# c_b=$(cliclick cp:. | awk '{print $3}')
								# echo $c_b
								# entropy_rand_capture=$(head -n $c_b /dev/urandom)
								# echo $entropy_rand_capture >> $ENTROPY_CAPTURE_OUTFILE

								y_loc=$(cliclick p  2>/dev/null | sed 's/[0-9]*\,//')
								y_loc_abs=$(echo $y_loc | awk '{print sqrt($1*$1)}')
								entropy_rand_capture=$(head -n $y_loc_abs /dev/urandom)
								echo $entropy_rand_capture >> $ENTROPY_CAPTURE_OUTFILE

								# c_r=$(cliclick cp:. | awk '{print $1}')
								# c_r_abs=$(getabs $c_r)
								# entropy_rand_capture=$(head -n $c_r_abs /dev/urandom)
								# echo $entropy_rand_capture >> $ENTROPY_CAPTURE_OUTFILE
								
								# c_g=$(cliclick cp:. | awk '{print $2}')
								# c_r_abs=$(getabs $c_g)
								# entropy_rand_capture=$(head -n $c_r_abs /dev/urandom)
								# echo $entropy_rand_capture >> $ENTROPY_CAPTURE_OUTFILE

								# print "$x_loc$c_b$y_loc$c_g$c_r"
								# print "$per_window_iters out of 30 iterations completed"
								
								if [[ $x_loc != $last_x_loc ]]
									then
										((per_window_iters++))
								fi
								# print "x is $x_loc .. y is $y_loc"
								# print $per_window_iters
								last_y_loc=$y_loc
								last_x_loc=$x_loc

								##Capture microphone data for entropy

								## Generate random number for inclusion in temporary mp3 output file name of microphone recording for entropy capture
								rand_shuf="$(shuf -i 999-100000 -n 1)"
								
								## Generate temporary mp3 output file name of microphone recording for entropy capture
								tmp_ff_a_fname="rand_tmp_ff-${rand_shuf}.mp3"

								## Capture microphone mp3 recording for entropy capture
								ffmpeg -f avfoundation -i ":0" -t $TMP_FF_REC_TIME $tmp_ff_a_fname 2>/dev/null

								## Write captured mp3 entropy data from microphone input to temporary entropy outfile
								print "[+] (Per window capture iteration $((per_window_iters)) / $PER_WINDOW_CAPTURE_ITERS) Successfully captured entropy data from microphone"
								print "[~] (Per window capture iteration $((per_window_iters)) / $PER_WINDOW_CAPTURE_ITERS) Writing captured entropy data from microphone to temporary outfile"
								cat $tmp_ff_a_fname >> $ENTROPY_CAPTURE_OUTFILE
								rm -rf $tmp_ff_a_fname
								print "[+] (Per window capture iteration $((per_window_iters)) / $PER_WINDOW_CAPTURE_ITERS) Print finished writing microphone data to temporary entropy outfile"
							done

						print "[+] Entropy capture from mouse movement and microphone input completed! You can go back to using your mouse normally now."

					done

			#Print progressive filesize of temporary outfile for each window of entropy capture
			((per_window_iters++))
			echo "[~] Size of entropy captured so far is $(stat -f %z $ENTROPY_CAPTURE_OUTFILE) [bytes]"
			# echo "[~] Entropy capture window $rand_entropy_idx of $RAND_ENTROPY_ITERS completed."
			done
	done

print "\n\n[+] All iterations of entropy capture complete"
print "[~] Total combined entropy data captured in bytes is $(stat -f %z $ENTROPY_CAPTURE_OUTFILE) [per stat]"
# print "[~] Entropy captured in bytes is $(ls -la $ENTROPY_CAPTURE_OUTFILE | awk '{print $5}') [per ls]"
# print "[~] If these numbers do not match further investigation may be required"

# print "[~] Ready to remove $argv[$FILE_TO_RM_IDX] using captured entropy"
# print "[~] rmplus: removing $argv[$FILE_TO_RM_IDX]"

##Generate entropy with default values or those specified by --rl n or --
# hred -f -z -n 7 -u $VERBOSE --random-source /dev/urandom $FILE_TO_RM

print "\n[!] Ready to securely remove $FILE_TO_RM"

if [[ $AUTOMATIC_RM = 'false' ]]
	then
		print "\n[!] WARNING: This file will be unable to be recovered after this action\n\n[!] Should rmplus delete $FILE_TO_RM?"
		if read -q "continue?[!] Press Y to proceed or any other key to cancel [Y/N]:"
			then
				print "\n\n[~] Permanently deleting $FILE_TO_RM"
				shred -f -z -n 100 -u $VERBOSE --random-source $ENTROPY_CAPTURE_OUTFILE $FILE_TO_RM
			else
				print "\n\n[!] File $FILE_TO_RM will not be removed (user override)"
		fi
			# shred -f -z -n 100 -u $VERBOSE --random-source $ENTROPY_CAPTURE_OUTFILE $FILE_TO_RM
	else [[ $AUTOMATIC_RM = 'true' ]]
		print "\n\n[~] Permanently deleting $FILE_TO_RM"
		shred -f -z -n 100 -u $VERBOSE --random-source $ENTROPY_CAPTURE_OUTFILE $FILE_TO_RM
fi


if [[ -f $FILE_TO_RM ]] 
	then
		print "\n[-] File $FILE_TO_RM not deleted"
		FILE_TO_RM_OUTCOME='false'
		
	else
		print "\n[+] File $FILE_TO_RM securely deleted"
		FILE_TO_RM_OUTCOME='true'
fi

print "\n[~] Securely deleting temporary entropy capture file $ENTROPY_CAPTURE_OUTFILE"
shred -f -z -n 100 -u $VERBOSE --random-source /dev/urandom $ENTROPY_CAPTURE_OUTFILE

if [[ -f $tmp_ff_a_fname ]]
	then
		print "\n[-] WARNING Temporary audio capture file $tmp_ff_a_fname not removed\n[!] It is recommended to check and manually remove $tmp_ff_a_fname"
		FF_AUDIO_RM_OUTCOME='false'
	else
		print "\n[+] File $tmp_ff_a_fname removed"
		FF_AUDIO_RM_OUTCOME='true'
fi

if [[ -f $ENTROPY_CAPTURE_OUTFILE ]]
	then
		print "\n[-] WARNING: Temporary entropy capture file $ENTROPY_CAPTURE_OUTFILE not removed\n[!] It is recommended to check and manually remove $ENTROPY_CAPTURE_OUTFILE"
		TMP_ENTROPY_RM_OUTCOME='false'
	else
		print "\n[+] File $ENTROPY_CAPTURE_OUTFILE securely removed"
		TMP_ENTROPY_RM_OUTCOME='true'
fi

# ls $tmp_ff_a_fname || ls $ENTROPY_CAPTURE_OUTFILE || ls $FILE_TO_RM || print "[!] WARNING: One or more files targeted for deletion failed to be securely deleted.\n[!] WARNING: It is recommended that you review rmplus output and check files manually so you can ensure they are securely removed."

# if [[ $TMP_ENTROPY_RM_OUTCOME == 'false' || $FF_AUDIO_RM_OUTCOME == 'false' || $FILE_TO_RM_OUTCOME == 'false' ]]
# 	then
# 		print '\n[!] WARNING: One or more temporary files or file targeted for secure deletion failed to be removed. It is recommended to check and manually remove these files if they are still present'
# 		return 2 2>/dev/null || exit 0
# 	else
# 		return 0 2>/dev/null || exit 0
# fi
# elif [[ $AUTOMATIC_RM == 'false' ]];
# 	then

# else
	# then
	# 	continue




 ## Function to convert numbers to absolute values (for use with mouse input entropy modifier)
# function getabs(){
#     (( n = $1))
# 	print $n
#     if (( n < 0 )); then 
#         absval=$(echo $n | sed 's/\-//g')
#     fi
# 	echo $absval
# }

# z=$(getabs -9)
# print $z