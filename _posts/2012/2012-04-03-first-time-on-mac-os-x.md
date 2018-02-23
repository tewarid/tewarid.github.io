---
layout: default
title: First time on Mac OS X
tags: macos noob
---

If you have never used a Mac, you'll rightfully feel lost about several key aspects. As a first time Mac OS X user, after almost two decades with the PC, I required some time to adapt.

![Dock](/assets/img/macos-dock.jpg)

### Mouse

Mouse on a Mac has only one button. To get the context menu or the right-click menu you'll need to hold the control key while you press the mouse button. On the Dock, you can hold the mouse button for a while and get the context menu for an app. From that context menu you can pin or unpin the icon for the app.

The trackpad supports multi-finger gestures. Slide down two fingers over the trackpad for the content to scroll up, slide up for the content to scroll down.

### Keyboard

The keyboard is again different on the Mac, more so the [keyboard shortcuts](http://support.apple.com/kb/HT1343). The command key behaves more like the control key on the PC. Thus, command-c copies, command-v pastes, command-x cuts and command-z undoes. Some commonly used keys are missing, here are the alternatives.

| Key on PC | Alternative on Mac  |
| --------- | ------------------- |
| backspace | delete              |
| Home      | command-left arrow  |
| End       | command-right arrow |
| Page Up   | control-up arrow    |
| Page Down | control-down arrow  |
| Delete    | control-d           |

### Common Applications

Apple has unleashed the App Store on Mac OS X after its success on iOS. It has tons of free and paid apps.

I use Skype and Chrome almost on a daily, for several hours. Luckily both are available for Mac OS X from their respective sites. Use Safari to download the installers. App installers in Mac have the extension dmg. Double click on a dmg file in Finder and you can install the app. Installed applications can be found in the Applications place in the Finder app. The Finder app itself is always available when you are on the Desktop, or from the Dock.

### Command Line

If you're familiar with the command line you'll find yourself at home in the Terminal app. It provides a command line interface based on the Bash shell. Mac OS X has a fully capable Unix system underneath all the eye candy. Here's one example of how you can use the curl command to resume a broken download

```bash
curl -C - -O
```
