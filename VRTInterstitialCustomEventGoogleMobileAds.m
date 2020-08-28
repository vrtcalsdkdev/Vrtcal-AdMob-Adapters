//
//  VRTInterstitialCustomEventGoogleMobileAds.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
#import "VRTInterstitialCustomEventGoogleMobileAds.h"

//Dependencies
#import <GoogleMobileAds/GoogleMobileAds.h>

//Google Mobile Ads Interstitial Adapter, Vrtcal as Primary
@interface VRTInterstitialCustomEventGoogleMobileAds() <GADInterstitialDelegate>
@property GADInterstitial *gadInterstitial;
@end


@implementation VRTInterstitialCustomEventGoogleMobileAds

- (void) loadInterstitialAd {
    NSString *adUnitId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    self.gadInterstitial = [[GADInterstitial alloc] initWithAdUnitID:adUnitId];
    self.gadInterstitial.delegate = self;
    [self.gadInterstitial loadRequest:[GADRequest request]];
}

- (void) showInterstitialAd {
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    [self.gadInterstitial presentFromRootViewController:vc];
}

#pragma mark - GADInterstitialDelegate

/// Called when an interstitial ad request succeeded. Show it at the next transition point in your
/// application such as when transitioning between view controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [self.customEventLoadDelegate customEventLoaded];
}

/// Called when an interstitial ad request completed without an interstitial to
/// show. This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
}

#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    [self.customEventShowDelegate customEventShown];
}

/// Called when |ad| fails to present.
- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeInterstitial];
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeInterstitial];
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    [self.customEventShowDelegate customEventWillLeaveApplication];
}


@end
