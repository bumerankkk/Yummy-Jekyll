TODO:
- write post about security concern - https://hackernoon.com/inside-the-bulb-adventures-in-reverse-engineering-smart-bulb-firmware-1b81ce2694a6
- do a translation to Czech
- add affiliate links to foreign shops and also to czeh shops on czech translation


---
title: How to control Yeelight Bulb with Tasker over LAN
---

[api-spec-doc]: http://www.yeelight.com/download/Yeelight_Inter-Operation_Spec.pdf "document describing methods and parameters to control light unit"

As you probably know, [Taker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm) is very powerful automation tool with many plugins, which can its power grately amplify. Standard [Yeelight](https://play.google.com/store/apps/details?id=com.yeelight.cherry) control app can double as such Tasker plugin. BUT! Every action you performa over Yeelight app, no matter if from its UI or over Tasker, will be sent to Yeelight servers (Yeelight is subsidiary of Xiaomi, which is Chinese). You can't know what or how they use data like this. Yes, they can "improve user experience" based on that, but they could know where you live (based on IP), when you usually go sleep or come home or when you are not at home for a longer time period. And only positive it brings to you as a user, is that you can control your bulb from whenever Internet connection is. Very useful... But also if your Internet connection is out or the servers have some kind of issues, you can't control your bulb other than the "dumb" way - through the switch in your room.

To overcome the issues, improve performance and "unlock" few other possibilites, Yeelight luckily offers developers API to control the bulb, lamps, LED strips etc. from basically any app. So here comes this tutorial!

#### Note
Using LAN control does not break function of Yeelight app, Mi Home app nor any other bulb controlling apps, so you still will be able to control your smart lights through Internet from any Internet-connected point on the Globe. :)
I use Bulb Color, so possibly something might be specific for this product.


## Prerequisites
- Android phone with installed both [Taker](https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm) and [Send/Expect plugin](https://play.google.com/store/apps/details?id=com.asif.plugin.sendexpect) and both apps set up to be ready to play with :)
- [Yeelight app](https://play.google.com/store/apps/details?id=com.yeelight.cherry) installed, which will be needed just for a single step
- **WiFi enabled** (BT versions are out of luck here) Yeelight smart LED product - bulb, lamp, LED strip,.. plugged, powered and connected to you home WiFi network (it is needed to set static IP for each light unit!)


## 
1. First of all, you need to connect you smart LED to Yeelight App - setup should be pretty stright forward.
	1. In the control panel of unit, tap on eject-like icon (underlined triangle pointing up)
	1. tap LAN control button
	1. Enable LAN control with switch at the top of screen
	1. Note that at the bottom there is guide where to find app examples (I had no luck with those I tried) and important [API specification document][api-spec-doc]
1. Now we are good to begin with Tasker work.
1. I decided to have several basic tasks, which actually send data to unit and other tasks just set variables (like state, brightnes, colour and fade delay) and then trigger one of the basic ones. This approach makes it easier to maintain those tasks, so I very recommend it.
1. Let's start with first of basic tasks - turn unit ON:
	1. Create new task
	1. Tap "+" button
	1. Select Plugin - > Send/Expect
	1. Tap on pencil icon of "Configuration"
	1. Type in IP address of your bulb, which you can find in Yeelight app or as I recommended it should be statically assigned by DHCP of your router. I typed "192.168.1.%bulbIP" (without quotes) for case I will have multiple light units which I would like to controll, and port which is 55443.
	1. Tap "Add send" and type in actually data - parameters to be set in the light unit. For turning ON something like this: `{"id":1,"method":"set_power","params":["on", "smooth", %bulbDelay]}`
		- **id** - is a integer (positive decimal number) to reference request. You can possibly send multiple requests before actual response for the first request is delivered, so this may help find which response belongs to which request.
		- **method** - this is obviously type of action you want to perform
		- **params** - params of the action
		- for details refer to [API specification document][api-spec-doc]
	1. Now it is possible to check response of the light unit - for that is "Add expect" feature. So far I didn't find it useful for controling lights, but that may change in future.
	1. Confirm this with check mark icon
	1. Go one step back to screen with list of action of your new task
	1. You may find useful to put actions to turn WiFi ON if it is OFF (like `if %WIFI eq off: turn WiFi on; wait 20 seconds`) or to check whether you are connected to correct WLAN before sending command.

Any questions about parameters please consult with [API specification document][api-spec-doc] first. I don't have any additional information on top of it!

CAUTION: Make sure you have strong password to your home WLAN and other security settings are correctly set-up (I prefer to turn WPS of completely as it is known as security concern with very tiny benefit for use experience) to prevent others with playing with your light and hackers to cause demage not only on your lights!

