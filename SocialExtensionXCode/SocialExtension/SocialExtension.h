//
//  SocialExtension.h
//  SocialExtension
//
//  Created by Mathieu Vignau on 10/10/12.
//  Copyright (c) 2012 MTVG. All rights reserved.
//

#import <Social/Social.h>
#import "FlashRuntimeExtensions.h"

@interface SocialExtension : NSObject

FREObject composeViewController(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet);
void ContextFinalizer(FREContext ctx);
void ExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);
void ExtensionFinalizer(void* extData);

@end
