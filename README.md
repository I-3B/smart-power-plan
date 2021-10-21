# Smart power plan

A script to change the power plan when running an app of choice with a specific power plan and changing it after closing the app

## Installation
Unzip smart-power-plan and place 'Smart power plan.ps1' and 'Smart power plan.exe' in the same folder(any folder).
## Usage
Run 'Smart power plan.exe' and start the configuration.
if you want to add more apps to use Spp you can do so in the config file "%USERPROFILE%\Documents\Smart power plan-config.txt"
after you configure it with chrome for example it will look like this: 
```txt
[1] - chrome
application full path = C:\Program Files\Google\Chrome\Application\chrome.exe
power plan while the application is running = Power saver
power plan after the application terminate = Balanced
```
if you want to add another app let's say Telegram you will need to add it yourself, the file should look like this:
```txt
[1] - chrome
application full path = C:\Program Files\Google\Chrome\Application\chrome.exe
power plan while the application is running = Power saver
power plan after the application terminate = Balanced

[2] - Telegram
application full path = C:\Users\<username>\AppData\Roaming\Telegram Desktop\Telegram.exe
power plan while the application is running = Balanced 
power plan after the application terminate = My power plan
```
note 1: the title here is not strict and it can be anything, you just need to follow the template, so for Telegram it can be like this:
```txt
[abc] - please open telegram
```
note 2: you don't have to launch the app for Spp, you can launch it normally then start Spp for it 
and it will work the same.
## License
[MIT](https://choosealicense.com/licenses/mit/)
