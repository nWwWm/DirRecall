<img src="./img/penguin.png" width="200" height="200">

# DirRecall 📂👣🐧
DirRecall is a simple nifty shell script that simplifies your directory navigation within the terminal, allowing you to swiftly recall and traverse your previous directories. 🚀

## Features ✨
* Automatically tracks the directories you visit and saves them in a history list. 📝
* Quickly navigate to any previously visited directory using the `pcd` command. ⚡️
* Customizable maximum size for the history list. 📏
* Persistent storage of the history list between sessions. 💾
* Share or isolate path data between different shell sessions using the SHARE_DATA environment variable. 🔄
* Specify directories to be ignored, preventing them from being added to the history list. 🔒
* Comprehensive testing with shunit2 framework to ensure functionality and reliability. 🧪

## Requirements 🛠️
* Zsh shell 🐚

## Installation ⚙️
### Zsh shell 
1. Clone the repository or download the DirRecall.zsh script file.
2. Make sure the script file is executable by running: 
   ```bash
   chmod u+x DirRecall.zsh
   ```
3. Add line below to your `~/.zshrc` file.
   ```bash 
   source /absoulte/path/to/DirRecall.zsh
   ``` 

## Usage 🚀
1. Simply use the `cd` command as you normally would to navigate through directories.
2. To navigate to a previously visited directory, use the `pcd` command followed by the index or path of the directory. For example: `pcd 2`.
3. Use the `lpcd` command to display the list of previously visited directories with indexes.

## Configuration ⚙️
You can customize the behavior of DirRecall by modifying the variables in the script:
* `MAX_SIZE`: Sets the maximum size of the history list. Default is 10.
* `FILE_PATH`: Specifies the file path for persistent storage of the history list.
* `ALLOW_DUPLICATES`: Choose whether path repeats are allowed in the previous paths list.
* `DISTANCE_THRESHOLD`: Specify the minimum distance between locations to be saved to the history list.
* `SHARE_DATA`: Specify whether path data is shared between different shell sessions.
* `IGNORE_FILE`: File path for storing ignored paths.

## Testing 🧪
DirRecall has been thoroughly tested to ensure functionality and reliability. The shunit2 framework was used for comprehensive testing. The tests cover various scenarios to verify the correctness of the script's functions and behavior.

### Manual Installation of shunit2
Before running the tests, you need to manually install the shunit2 framework. Follow these steps:

1. Clone the shunit2 repository or download the shunit2 script file.
2. Make sure the script file is executable by running: chmod +x shunit2.
3. Set the `SHUNIT2_PATH` variable in the test scripts to the absolute path of the shunit2 script.

   ```bash
   # ... 
   # Set the path to shunit2
   SHUNIT2_PATH="/absolute/path/to/shunit2"
   # ...
   ```
### Running the Tests
To run the tests, execute the test script e.g. DirRecallTest.zsh. It will run all the defined test functions and display the results.
```bash
./DirRecallTest.zsh 
```
Make sure that you have the necessary permissions to execute the test script. If needed, you can grant execution permissions using the chmod command:
```bash
chmod u+x DirRecallTest.zsh
```
By running the tests, you can ensure that DirRecall functions as expected and validate its behavior in different scenarios.

## Future Developments 🚀
I have some exciting plans for the future of this script. Here are a few things I'm considering:
* Support for Bash shell (because everyone deserves a shell of their choice!) 🐚
* Additional customization options (because who doesn't like to have it their way?) ✨

Please note that the current version of the script is compatible only with the Zsh shell. I haven't mastered the art of teleporting the script to different shells just yet, but I'am working on it. Stay tuned for future updates and shell-hopping adventures! 🌟

## License 📄
This project is licensed under the Apache License 2.0. For more details, please see the LICENSE file.

## Acknowledgements 🙌
DirRecall was born out of sheer frustration with forgetting the paths to previously visited directories in the terminal. Special thanks to those countless moments of aimless wandering through the file system, desperately trying to recall where I was just moments ago. 🤔🚶‍♂️

The developer would also like to acknowledge the countless cups of coffee ☕️ and sleepless nights 🌙 that fueled the development of DirRecall. Without the caffeine-induced determination and a dash of delirium, this script would have remained just another distant memory.

Furthermore, I express my gratitude to all the brave explorers of the terminal who found this little project in the endless depths of the internet. Your fearless navigation and endless hours of typing inspired me to create a tool that simplifies your journey through the digital wilderness. 🧭🌳

In this solo endeavor, the developer navigated the coding challenges with determination and unwavering focus. However, the true heroes of this project are the countless lines of code that faithfully execute the vision, silently powering DirRecall's directory-recalling magic. Let us not forget their invaluable contribution! 💻✨

## Disclaimer ⚠️
DirRecall is provided as-is without any warranty or guarantee of its functionality or performance. The author (@nWwWm) shall not be held responsible for any damages or losses incurred while using this script. Use it at your own risk.

Although efforts have been made to ensure the accuracy and reliability of the script, bugs or issues may still be present. Users are encouraged to thoroughly test the script and report any problems or suggestions for improvement.

Please note that DirRecall is a personal project and is not affiliated with any company or organization. It is developed and maintained independently.

## Contributing 🤝
Contributions are welcome! If you have any ideas, improvements, or bug fixes, feel free to open an issue or submit a pull request. Let's make DirRecall even more awesome together! 🌟
