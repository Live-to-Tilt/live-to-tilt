<!-- markdownlint-disable MD033 MD041 -->

# Live to Tilt

![Cover photo](Documentation/cover.png)
No buttons or joysticks, just tilt. Tilt to avoid enemies and activate powerups. Tilt for your life.

---

## Overview

Live to Tilt is a re-creation of the popular iOS game Tilt to Live, a childhood favourite of ours! Just like in the original game, there are no buttons or joysticks. You tilt your device to control your character. Avoid the red dots that appear on the screen while collecting power-ups to obliterate them! Chain your kills to build up your combo and rake in the points!

## Team Members

This iPadOS app is a final project of CS3217, Software Engineering on Modern Application Platforms. Made with ❤️ by:

- [Goh Wen Hao](https://github.com/wenhaogoh)
- [Chester How](https://github.com/chesterhow)
- [Lui Kai Siang](https://github.com/kslui99)
- [Maxx Chan](https://github.com/maxxyh)

## Getting Started

Live to Tilt is written in Swift and developed in Xcode Version 13.2. Simply clone the repository to get started!

1. Get Xcode from the [App Store](https://apps.apple.com/us/app/xcode/id497799835) or https://developer.apple.com/downloads.
2. Install the Xcode Command Line Tools
   In Terminal, run the command: `xcode-select --install`

### Setting up Firebase

This project uses Firebase, along with PubNub, to support real-time multiplayer gameplay.

1. Create a firestore.
    ```Code instructions```

2. Create a database.
    ```...```

3. Download the Google plist, and add it to Live to Tilt.
    ```.../or an image```
    The Google plist should be placed into your directory like so:
    ![Google Plist instructions](Documentation/google-plist.png)

## Documentation

For more details on our technical design, please refer [here](https://docs.google.com/document/d/1IRGTh3BoQcHm0VggbzeEvdI_CIv9YHHpy2I9CQEtg08/edit?usp=sharing).

## Features

![Feature highlights](Documentation/features.png)

### 3 Awesome Powerups

<div style="display: flex; flex-direction: column; align-items: center; margin: 3rem 0 1rem">
<img style="height: 50px; width: 50px" src="Documentation/nuke.png">
<h3 style="margin: 1rem 0 0">NUKE</h3>
Kaboom! Obliterates all enemies within the vicinity.
<img src="Documentation/nuke-demo.gif" alt="Nuke">
</div>

<div style="display: flex; flex-direction: column; align-items: center; margin: 3rem 0 1rem">
<img style="height: 50px; width: 50px" src="Documentation/lightsaber.png">
<h3 style="margin: 1rem 0 0">LIGHTSABER</h3>
Wield 2 deadly lightsabers and blitz those dots to oblivion!
<img src="Documentation/lightsaber-demo.gif" alt="Lightsaber">
</div>

<div style="display: flex; flex-direction: column; align-items: center; margin: 3rem 0 1rem">
<img style="height: 50px; width: 50px" src="Documentation/freeze.png">
<h3 style="margin: 1rem 0 0">FREEZE</h3>
Freeze your enemies and shatter them while they're frozen!
<img src="Documentation/freeze-demo.gif" alt="Freeze">
</div>

## User Guide

Please refer to the User Manual section in our [documentation](https://docs.google.com/document/d/1IRGTh3BoQcHm0VggbzeEvdI_CIv9YHHpy2I9CQEtg08/edit?usp=sharing).