# timeGUI.ahk
Need a quick and easy way to convert time zones without changing windows? Use a popup window triggered by `CTRL + \` (above the Tab key) to convert time zones actively:

![image](https://user-images.githubusercontent.com/15747450/156899966-8456dbba-c147-4509-ac18-c6bb5e98a98d.png)


Then press Enter or click the button to paste from clipboard in this format: `Mar. 5 @ 4:00PM EST [Mar. 5 @ 1:00PM PST | Mar. 5 @ 9:00PM UTC | Mar. 6 @ 2:30AM IST]`.

 ## Notes
* Can be downloaded and launched from executable if you don't have AHK installed, then the executable can be saved in your `shell:startup` folder: https://github.com/rjmccallumbigl/timeGUI.ahk/blob/main/timeGUI.exe
* As is, will handle EST + CST + PST + UTC + IST in that order. Time zones can be modified from the code.
* ~~The UTC offsets are also hardcoded, but the script can be modified to call the correct offset during DST hours.~~
  * Update: UTC offset for EST & PST is autuomatically grabbed via API.
