rmplus+ (rmplus-shred)
=======
rmplus+ is a wrapper for shred written in zsh to make secure file deletion easier and less error-prone by presetting optional arguments for shred and combining entropy sources from audio input by capturing real-time microphone input and mouse cursor movement, integrated with /dev/urandom capture

Usage
-------
rmplus+ can be run by executing it from zsh terminal with the usage:

./rmplus.sh [options] filename

Optional arguments:
--help Display usage and optional arguments
--how  Show the standard shred options
--v    Enable shred verbose output
--p    Prompt before secure removal of file for deletion after entropy capture.
