//
//  SocialExtension.m
//  SocialExtension
//
//  Created by Mathieu Vignau on 10/10/12.
//  Copyright (c) 2012 MTVG. All rights reserved.
//

#import "SocialExtension.h"

@implementation SocialExtension

static NSString *eventName = @"socialExtensionEvent";

FREObject composeViewController(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // possible return values
    FREObject yes;
    FREObject no;
    FRENewObjectFromBool(YES, &yes);
    FRENewObjectFromBool(NO, &no);
    
    // arguments definition
    int32_t serviceTypeId;
    NSString *shareText;
    NSString *shareURL;
    FREBitmapData bitmapData;
    
    // get serviceTypeId from arguments and check if it is an int between 0 and 2 included
    if (!( FRE_OK == FREGetObjectAsInt32(argv[0], &serviceTypeId) &&
          serviceTypeId>=0 && serviceTypeId <=2))
        return no;
    
    // set serviceType
    NSString *serviceType;
    if (serviceTypeId == 0)
        serviceType = SLServiceTypeFacebook;
    else
    if (serviceTypeId == 1)
        serviceType = SLServiceTypeTwitter;
    else
    if (serviceTypeId == 2)
        serviceType = SLServiceTypeSinaWeibo;
    
    // check if service is available
    if (![SLComposeViewController isAvailableForServiceType:serviceType])
        return no;    
    
    // get strings values from arguments
	uint32_t shareTextLength;
    const uint8_t *shareTextPointer;
	uint32_t shareURLLength;
    const uint8_t *shareURLPointer;
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[1], &shareTextLength, &shareTextPointer))
        shareText = [NSString stringWithUTF8String:(char*)shareTextPointer];
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[2], &shareURLLength, &shareURLPointer))
        shareURL = [NSString stringWithUTF8String:(char*)shareURLPointer];
    
    // create the view controller
    SLComposeViewController *socialController = [SLComposeViewController
                                                 composeViewControllerForServiceType:serviceType];
    
    // setup the view controller with provided data
    [socialController setInitialText:shareText];
    if (shareURL.length>0)
        [socialController addURL:[NSURL URLWithString:shareURL]];
    
    // load bitmapdata into UIImage
    // from http://forums.adobe.com/message/4201451
    
    if (FRE_OK == FREAcquireBitmapData(argv[3], &bitmapData))
    {
        int width       = bitmapData.width;
        int height      = bitmapData.height;
        
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
        
        int                     bitsPerComponent    = 8;
        int                     bitsPerPixel        = 32;
        int                     bytesPerRow         = 4 * width;
        CGColorSpaceRef         colorSpaceRef       = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo            bitmapInfo;
        
        if (bitmapData.hasAlpha)
        {
            if (bitmapData.isPremultiplied)
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
            else
                bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;
        }
        else
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
        }
        
        CGColorRenderingIntent  renderingIntent     = kCGRenderingIntentDefault;
        CGImageRef              imageRef            = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
        
        UIImage *shareImage = [UIImage imageWithCGImage:imageRef];
        
        FREReleaseBitmapData(argv[3]);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGDataProviderRelease(provider);
        
        [socialController addImage:shareImage];
    }    
    
    // handle result
    SLComposeViewControllerCompletionHandler __block completionHandler=
    ^(SLComposeViewControllerResult result) {
        [socialController dismissViewControllerAnimated:YES completion:nil];
        switch(result) {
            case SLComposeViewControllerResultCancelled:
            default:
                
                FREDispatchStatusEventAsync(ctx, (uint8_t*)[eventName UTF8String], (uint8_t*)[@"cancelled" UTF8String]);
                break;
            case SLComposeViewControllerResultDone:
                FREDispatchStatusEventAsync(ctx, (uint8_t*)[eventName UTF8String], (uint8_t*)[@"done" UTF8String]);
                break;
        }
    };
    [socialController setCompletionHandler:completionHandler];
    
    // display the view controller
    UIViewController *mainViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [mainViewController presentViewController:socialController animated:YES completion:nil];
    
    return yes;
}

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
						uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
	*numFunctionsToTest = 1;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
	func[0].name = (const uint8_t*) "composeViewController";
	func[0].functionData = NULL;
    func[0].function = &composeViewController;
	
	*functionsToSet = func;
}



// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void ContextFinalizer(FREContext ctx) {
    
    // Nothing to clean up.
    
	return;
}



// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void ExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                    FREContextFinalizer* ctxFinalizerToSet) {
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;
}



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void ExtensionFinalizer(void* extData) {
    
    // Nothing to clean up.
    
    return;
}

@end
