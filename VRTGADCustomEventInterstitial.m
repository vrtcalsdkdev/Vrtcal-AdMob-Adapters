//Header
#import "VRTGADCustomEventInterstitial.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>

//Google Mobile Ads Interstitial Adapter, Vrtcal as Secondary
@interface VRTGADCustomEventInterstitial () <VRTInterstitialDelegate>

@property (weak) UIViewController *rootViewController;
@property VRTInterstitial *vrtInterstitial;

@end

@implementation VRTGADCustomEventInterstitial

@synthesize delegate;

#pragma mark - GADCustomEventInterstitial



- (void)requestInterstitialAdWithParameter:(NSString * _Nullable)serverParameter
                                     label:(NSString * _Nullable)serverLabel
                                   request:(nonnull GADCustomEventRequest *)request {
    VRTLogWhereAmI();
    NSError *jsonError = nil;
    NSData *jsonData = [serverParameter dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    if (!jsonDict) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent format:@"VrtcalSDK unable to extract json from serverParameter: %@", serverParameter];
        [self.delegate customEventInterstitial:self didFailAd:error];
        return;
    }
    
    NSString *strZid = jsonDict[@"zid"];
    int zid = [strZid intValue];
    if (zid == 0) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent format:@"VrtcalSDK Unable to extract ZoneID from jsonDict: %@", jsonDict];
        [self.delegate customEventInterstitial:self didFailAd:error];
        return;
    }

    self.vrtInterstitial = [[VRTInterstitial alloc] init];
    self.vrtInterstitial.adDelegate = self;
    [self.vrtInterstitial loadAd:zid];
}

- (void)presentFromRootViewController:(nonnull UIViewController *)rootViewController {
    self.rootViewController = rootViewController;
    [self.vrtInterstitial showAd];
}

#pragma mark - VRTInterstitialDelegate

- (void)vrtInterstitialAdLoaded:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate customEventInterstitialDidReceiveAd:self];
}

- (void)vrtInterstitialAdFailedToLoad:(nonnull VRTInterstitial *)vrtInterstitial error:(nonnull NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)vrtInterstitialAdWillShow:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)vrtInterstitialAdDidShow:(nonnull VRTInterstitial *)vrtInterstitial {
    //Surprisingly, Google Mobile Ads doesn't have an analog to this event.
}

- (void)vrtInterstitialAdFailedToShow:(nonnull VRTInterstitial *)vrtInterstitial error:(nonnull NSError *)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)vrtInterstitialAdClicked:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate customEventInterstitialWasClicked:self];
}

- (void)vrtInterstitialAdWillLeaveApplication:(nonnull VRTInterstitial *)vrtInterstitial {
    //Google Mobile Ads supports this event but it is deprecated
    //[self.delegate customEventInterstitialWillLeaveApplication:self];
}

- (void)vrtInterstitialAdWillDismiss:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate customEventInterstitialWillDismiss:self];
}

- (void)vrtInterstitialAdDidDismiss:(nonnull VRTInterstitial *)vrtInterstitial {
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (nonnull UIViewController *)vrtViewControllerForModalPresentation {
    return self.rootViewController;
}

- (void)vrtInterstitialVideoStarted:(nonnull VRTInterstitial *)vrtInterstitial {
    //Google Mobile Ads doesn't have an analog to this event.
}

- (void)vrtInterstitialVideoCompleted:(nonnull VRTInterstitial *)vrtInterstitial {
    //Google Mobile Ads doesn't have an analog to this event.
}





@end
