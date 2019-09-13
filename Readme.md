# Conan Boost

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This repository contains the conan receipe that is used to build the boost packages at appcom.

For Infos about Boost please visit [www.boost.org](https://www.boost.org/).  
The library is licensed under the [Boost Software License](https://www.boost.org/users/license.html).  
This repository is licensed under the [MIT License](LICENSE).

Compiling Boost is kinda complicated. So I wrote the build scripts and the conan scripts seperately.
The `build-boost` scripts will output a zip file containing the libraries.
The `upload-conan` scripts will unzip the corresponding zip file, package it using the `conanfile.py` and upload them to
a conan repository.

## Build Scripts

For building the following scripts can be used.

### Android

This script utilizes a [fork](https://github.com/Manromen/Boost-for-Android) of 
[moritz-wundke Boost-for-Android](https://github.com/moritz-wundke/Boost-for-Android).

Precompiled binaries for Android can also be downloaded from 
[Github](https://github.com/Manromen/Boost-for-Android/releases).

For building from a macOS / Linux Host, there is a bash script. Building from a Windows Host is not supported.
The environmental `ANDROID_NDK_PATH` must be set to the path of the ndk.

Example:

`ANDROID_NDK_PATH='/opt/android-ndks/android-ndk-r17b' ./build-boost-android.sh`

#### Requirements

* [Android NDK](https://developer.android.com/ndk/downloads/)

### Debian 9 (Stretch)

For building Boost for Debian, execute the `build-boost-debian-stretch.sh` script.

#### Requirements

* build-essential, curl, git, unzip and zip (`apt-get install build-essential curl git unzip zip`)

### iOS

This script utilizes a [fork](https://github.com/Manromen/Apple-Boost-BuildScript) of
[faithfracture Apple-Boost-BuildScript](https://github.com/faithfracture/Apple-Boost-BuildScript).

For building the iOS Libraries, execute `build-boost-ios.sh`.

#### Requirements

* [Apple Xcode](https://developer.apple.com/xcode/)

### macOS

This script utilizes a [fork](https://github.com/Manromen/Apple-Boost-BuildScript) of
[faithfracture Apple-Boost-BuildScript](https://github.com/faithfracture/Apple-Boost-BuildScript).

For building the macOS Libraries, execute `build-boost-macos.sh`

#### Requirements

* [Apple Xcode](https://developer.apple.com/xcode/)

### Windows 10

There is a `build-boost-win10.ps1` script, but I couldn't get it working.
Feel free to make it work and create a pull request please. :)

I will describe my procedure of building boost in the file `build-boost-win10.md`, until I may got a working version of
the script.

#### Requirements

* [Visual Studio 2017](https://visualstudio.microsoft.com/de/downloads/)
* [Powershell 5](https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell?view=powershell-6)

## Upload Conan Scripts

### Android

To create a conan package for Android there must be a corresponding zip archive in the builds folder for that version
and NDK.
The file must be name in the following structure:  
`boost-android-[ndk]-[arch]-[version].zip` for example: `builds/1.70.0/boost-android-r20-arm64-v8a-1.70.0.zip`

For the debug version there must be a `debug` before the `[version]`:  
`boost-android-[ndk]-[arch]-debug-[version].zip` for example: `builds/1.70.0/boost-android-r20-arm64-v8a-debug-1.70.0.zip`

After adjusting the settings in `upload-conan-android.sh` this script will create the conan packages.

### iOS

To create a conan package for iOS there must be a corresponding zip archive in the builds folder for that version
and SDK.
The file must be name in the following structure:  
`boost-ios-sdk[sdk]-[version].zip` for example: `builds/1.70.0/boost-ios-sdk12.4-1.70.0.zip`

For the debug version there must be a `debug` before the `[version]`:  
`boost-ios-sdk[sdk]-debug-[version].zip` for example: `builds/1.70.0/boost-ios-sdk12.4-debug-1.70.0.zip`

After adjusting the settings in `upload-conan-ios.sh` this script will create the conan packages.
