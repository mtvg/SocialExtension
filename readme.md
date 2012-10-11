# iOS 6 Social framework Native Extention for AIR 3.5+ #

Here is my first shot with Adobe Native Extensions for AIR.

This ANE is only for iOS 6+ as it exposes the native sharing composer of iOS 6.  
It will work on an iOS device, the iOS simulator and the AIR simulator.

## Requirements ##
Here is the tools I've used to develop this extension:

* [XCode 4.5](https://itunes.apple.com/fr/app/xcode/id497799835?mt=12)
* [Flash Builder 4.7 beta](http://labs.adobe.com/technologies/flashbuilder4-7/)
* [AIR 3.5 beta](http://labs.adobe.com/technologies/flashplatformruntimes/air3-5/)

In order to use AIR 3.5 with FB 4.7, I've merged the AIR 3.5 SDK into the FB Flex SDK and the FB Compiler Plugin:

	# ditto air3-5_sdk_mac /Applications/Adobe\ Flash\ Builder\ 4.7/sdks/4.6.0
	# ditto air3-5_sdk_mac /Applications/Adobe\ Flash\ Builder\ 4.7/eclipse/plugins/com.adobe.flash.compiler_4.7.0.345990/AIRSDK

You will also need your Apple Developer certificate and provisioning profile.

## What's in the repository? ##
### ANE file ###
The Native Extension ([SocialExtension.ane](https://github.com/mtvg/SocialExtension/raw/master/SocialExtension.ane))

_Usage:_
	
	import net.mtvg.air.SocialExtension;
	
	var socialExt:SocialExtension = new SocialExtension;
	socialExt.addEventListener(Event.CANCEL, onCancel);
	socialExt.addEventListener(Event.COMPLETE, onComplete);
	
	socialExt.shareComposer(serviceType:int, shareText:String="", shareURL:String="", shareImage:BitmapData=null):Boolean
	
`serviceType` can be:

* `SocialExtension.SERVICE_TWITTER`
* `SocialExtension.SERVICE_FACEBOOK`
* `SocialExtension.SERVICE_SINAWEIBO`

`shareComposer()` returns `false` if the selected `serviceType` is not available on the device


	
### SocialExtensionXCode ###

The native code that exposes the [SLComposeViewController](http://developer.apple.com/library/ios/documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html) class. 

### SocialExtensionAS ###

The source code of the AS3 library:

* SocialExtensionIOS for the real library
* SocialExtensionDefault for the fake library (AIR simulator)

### SocialExtensionBuild ###

Contains all you need to package the ANE file.

In order to use the _build.sh_ file, don't forget to add the AIR SDK to your PATH variable:

	# export PATH=$PATH:/Applications/Adobe\ Flash\ Builder\ 4.7/sdks/4.6.0/bin
	
### SocialExtensionExample ###

Contains a Flex Mobile project that uses the extension, it looks like this:

![](https://github.com/mtvg/SocialExtension/raw/master/SocialExtensionExample/preview.png) 