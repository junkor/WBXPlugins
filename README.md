# WBXPlugins
---
An easy way to add plugins entrance to xcode.






--

##implemented plugin functions


###WBIpaExporter

  WBIpaExporter is a plugin for Xcode. The plugin can export the IPA file from the archive in the Organizer window. It's based on [IpaExporter]()

  If you want to export the IPA file from the archive, you can open the Organizer window, click the "WBPlugins" menu, to open "WBIpaExporter", you can export ipa to desktop or SINA OTA.

* Open Organizer window.

  ![image](https://github.com/junkor/WBXPlugins/raw/master/Screenshots/Screenshot_0.png)
  
* Choose the archive in list, and click menu item "Export to OTA".

  ![image](https://github.com/junkor/WBXPlugins/raw/master/Screenshots/Screenshot_1.png)

* Input OTA Info to submit.

  ![image](https://github.com/junkor/WBXPlugins/raw/master/Screenshots/Screenshot_2.png)
  
* Waiting for upload.

  ![image](https://github.com/junkor/WBXPlugins/raw/master/Screenshots/Screenshot_3.png)

* Check the OTA, your ipa file has already there.

  ![image](https://github.com/junkor/WBXPlugins/raw/master/Screenshots/Screenshot_4.png)

### Supported Xcode Versions
  - Xcode6
  - Xcode7

### Manual build and install
  - Download source code and open IpaExporter.xcodeproj with Xcode.
  - Select "Edit Scheme" and set "Build Configuration" as "Release"
  - Build it. It automatically installs the plugin into the correct directory.
  - Restart Xcode. (Make sure that the Xcode process is terminated entirely)

### Manual install
- Download [WBXPlugins.xcplugin.zip](https://github.com/junkor/WBXPlugins/raw/master/Download/WBXPlugins.xcplugin.zip).
- unzip the zip file to get the .xcplugin package.
- copy the .xcplugin package to directory: `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/`

### Manual uninstall 
  Delete the following directory:

  `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/WBXPlugins.xcplugin`

The MIT License (MIT)
================

Copyright (c) 2014 Pharaoh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


