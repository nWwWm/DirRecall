# DirRecall 📂
DirRecall is a simple nifty bash script that simplifies your directory navigation within the terminal, allowing you to swiftly recall and traverse your previous directories. 🚀

## Features ✨
* Automatically tracks the directories you visit and saves them in a history list. 📝
* Quickly navigate to any previously visited directory using the `pcd` command. ⚡️
* Customizable maximum size for the history list. 📏
* Persistent storage of the history list between sessions. 💾
* Share or isolate path data between different shell sessions using the SHARE_DATA environment variable. 🔄
* Specify directories to be ignored, preventing them from being added to the history list. 🔒
<hr>

## Requirements 🛠️
* Zsh shell 🐚

## Installation ⚙️
### Zsh shell 
1. Clone the repository or download the DirRecall.zsh script file.
2. Make sure the script file is executable by running: `chmod u+x DirRecall.zsh`.
3. Add `source /absoulte/path/to/DirRecall.zsh` to your `~/.zshrc` file.

## Usage 🚀
1. Simply use the `cd` command as you normally would to navigate through directories.
2. To navigate to a previously visited directory, use the `pcd` command followed by the index or path of the directory. For example: `pcd 2`.
3. Use the `lpcd` command to display the list of previously visited directories with indexes.

## Configuration ⚙️
You can customize the behavior of DirRecall by modifying the variables in the script:
* `MAX_SIZE`: Sets the maximum size of the history list. Default is 10.
* `FILE_PATH`: Specifies the file path for persistent storage of the history list.
* `ALLOW_DUPLICATES`: Choose whether path repeats are allowed in the previous paths list.

<hr>

## Future Developments 🚀
I have some exciting plans for the future of this script. Here are a few things I'm considering:
* Support for Bash shell (because everyone deserves a shell of their choice!) 🐚
* Additional customization options (because who doesn't like to have it their way?) ✨

Please note that the current version of the script is compatible only with the Zsh shell. I haven't mastered the art of teleporting the script to different shells just yet, but I'am working on it. Stay tuned for future updates and shell-hopping adventures! 🌟

<hr>

## License 📄
This project is licensed under the MIT License.

## Acknowledgements 🙌
DirRecall was inspired by the need for a convenient way to navigate through previous directories in the terminal.

## Disclaimer ⚠️
DirRecall is provided as-is without any warranty or guarantee of its functionality or performance. The author (@nWwWm) shall not be held responsible for any damages or losses incurred while using this script. Use it at your own risk.

Although efforts have been made to ensure the accuracy and reliability of the script, bugs or issues may still be present. Users are encouraged to thoroughly test the script and report any problems or suggestions for improvement.

Please note that DirRecall is a personal project and is not affiliated with any company or organization. It is developed and maintained independently.

## Contributing 🤝
Contributions are welcome! If you have any ideas, improvements, or bug fixes, feel free to open an issue or submit a pull request. Let's make DirRecall even more awesome together! 🌟
