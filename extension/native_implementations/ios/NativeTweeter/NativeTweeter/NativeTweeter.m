//
//  NativeTweeter.m
//  NativeTweeter
//
//  Created by David Wagner on 26/05/2012.
//  Copyright (c) 2012 Noise & Heat. All rights reserved.
//

#import "NativeTweeter.h"

// Import the Twitter framework
#import <Twitter/Twitter.h>

// Import the Adobe runtime extension
#import "FlashRuntimeExtensions.h"

// Constants which match the internal event constants
// used in Tweeter.as
static const uint8_t IE_ERROR[] = "Tweeter::Error";
static const uint8_t IE_FINISHED[] = "Tweeter::Finished";
static const uint8_t IE_CANCELLED[] = "Tweeter::Cancelled";

static const uint8_t EMPTY_STRING[] = "";

/**
 * Internal utility function to check if tweeting is available.
 *
 * By declaring this as static, we make sure that the function can
 * only be accessed by other functions in this file.
 */
static BOOL tweetingAvailable()
{
    // Check to see if the TWTweetComposeViewController class exists
    if (NSClassFromString(@"TWTweetComposeViewController") == Nil)
    {
        // The class doesn't exist so it can't be used
        return NO;
    }
    
    // Use a class method to see if tweeting is available.
    return [TWTweetComposeViewController canSendTweet];
}

/**
 * Native function called from ActionScript to query if Tweeting is available.
 *
 * ActionScript params: None
 * ActionScript return: Boolean
 */
FREObject NAH_Tweeter_isSupported(FREContext context, void *functionData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    if (FRENewObjectFromBool(tweetingAvailable(), &result ) != FRE_OK)
    {
        result = NULL;
    }
    
    return result;
}

/**
 * Native function called from ActionScript to start a new tweet.
 *
 * ActionScript params: String containing the initial message
 * ActionScript return: Nothing
 */
FREObject NAH_Tweeter_tweet(FREContext context, void *functionData, uint32_t argc, FREObject argv[])
{
    if ( !tweetingAvailable() )
    {
        FREDispatchStatusEventAsync(context, IE_ERROR, (uint8_t *)"Tweeting not available.");
        return NULL;
    }
    
    if (argc != 1)
    {
        FREDispatchStatusEventAsync(context, IE_ERROR, (uint8_t *)"Wrong number of arguments. Expected 1.");
        return NULL;
    }
    
    uint32_t messageLength;
    const uint8_t *message;
    if (FREGetObjectAsUTF8(argv[0], &messageLength, &message) != FRE_OK)
    {
        FREDispatchStatusEventAsync(context, IE_ERROR, (uint8_t *)"Could not convert tweet message to string");
        return NULL;
    }
    
    TWTweetComposeViewController *composer = [[TWTweetComposeViewController alloc] init];
    [composer setInitialText:[NSString stringWithUTF8String:(char *)message]];
    composer.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        if (result == TWTweetComposeViewControllerResultDone)
        {
            FREDispatchStatusEventAsync(context, IE_FINISHED, EMPTY_STRING);
        }
        else
        {
            FREDispatchStatusEventAsync(context, IE_CANCELLED, EMPTY_STRING);
        }
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [vc dismissModalViewControllerAnimated:YES];
    };
    
    UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [vc presentModalViewController:composer animated:YES];
    
    return NULL;
}

/**
 * Called to initialize the extension context. This largely involves
 * mapping which native functions can be called from ActionScript.
 */
void NAHTweeterContextInitializer( void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction * *functionsToSet )
{
    /**
     * Helper macro to make adding functions a little less error prone.
     *
     * It assumes that the C function names in this file map directly to
     * the same method names in the ActionScript part of the extension.
     */
    #define MAP_ANE_FUNCTION(fn, data) { .name = (const uint8_t *)(# fn), .functionData = (data), .function = &(fn) }
    
    // Create the mappings for the exposed native functions
    static FRENamedFunction functionMap[] = {
        MAP_ANE_FUNCTION( NAH_Tweeter_isSupported, NULL ),
        MAP_ANE_FUNCTION( NAH_Tweeter_tweet,       NULL ),
    };
    
    // Calculate the number of functions defined
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
    
    // Set the array for functions
    *functionsToSet = functionMap;
}

/**
 * Called to finalize the context. You can release any resources you
 * have acquired here. For this simple extension, we simply do nothing.
 */
void NAHTweeterContextFinalizer( FREContext ctx )
{
    // Nowt
}

/**
 * Called to intialize the extension. This function name is mapped in
 * the extension.xml file in the ActionScript project.
 */
void NAHTweeterExtensionInitializer( void * *extDataToSet, FREContextInitializer *ctxInitializerToSet, FREContextFinalizer *ctxFinalizerToSet )
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &NAHTweeterContextInitializer;
    *ctxFinalizerToSet = &NAHTweeterContextFinalizer;
}
