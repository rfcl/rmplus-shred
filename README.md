rmplus+ (rmplus-shred)
=======
rmplus+ is a macOS wrapper for shred written in zsh to make secure file deletion easier and less error-prone by presetting optional arguments for shred and combining entropy sources from audio input by capturing real-time microphone input and mouse cursor movement, integrated with /dev/urandom capture

Usage
-------
rmplus+ can be run by executing it from zsh terminal with the usage:

~~~
./rmplus.sh [options] filename
~~~

#### Optional arguments:
~~~
--help Display usage and optional arguments

--how  Show the standard shred options

--v    Enable shred verbose output

--p    Prompt before secure removal of file for deletion after entropy capture.
~~~

#### Example usage:
~~~
./rmplush.sh --p --v filetodelete.txt
~~~

Requirements
-------
rmplus+ requires the cli utilies [ffmpeg](https://github.com/ffmpeg/ffmpeg) (for audio capture) and [cliclick](https://github.com/BlueM/cliclick) (for mouse movement capture). Future updates will support cross-platform compatibility and options for disabling any of these entropy capture sources.

Both requirements are available in homebrew and can be installed from terminal by running:
~~~
brew install cliclick
brew install ffmpeg
~~~

If you do not have Homebrew installed, you can install from terminal by running the shell snippet:
~~~
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
~~~

To make rmplus+ usable from anywhere via zsh shell, either add install location to path (recommended) or run:
~~~
sudo ln -s [rmplus install directory]/rmplus.sh /usr/local/bin/rmplus
~~~
