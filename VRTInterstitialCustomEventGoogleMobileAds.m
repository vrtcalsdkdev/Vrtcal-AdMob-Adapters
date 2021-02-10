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
@interface VRTInterstitialCustomEventGoogleMobileAds() <GADFullScreenContentDelegate>
@property GADInterstitialAd *gadInterstitial;
@end


@implementation VRTInterstitialCustomEventGoogleMobileAds

- (void) loadInterstitialAd {
    NSString *adUnitId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    
    [GADInterstitialAd loadWithAdUnitID:adUnitId request:[GADRequest new] completionHandler:^(GADInterstitialAd * _Nullable interstitialAd, NSError * _Nullable error) {
        
        if (interstitialAd == nil || error != nil) {
            [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
            return;
        }
        
        
        self.gadInterstitial = interstitialAd;
        self.gadInterstitial.fullScreenContentDelegate = self;
        
        [self.customEventLoadDelegate customEventLoaded];
    }];
}

- (void) showInterstitialAd {
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    [self.gadInterstitial presentFromRootViewController:vc];
}


#pragma mark Display-Time Lifecycle Notifications

/// Called just before presenting an interstitial. After this method finishes the interstitial will
/// animate onto the screen. Use this opportunity to stop animations and save the state of your
/// application in case the user leaves while the interstitial is on screen (e.g. to visit the App
/// Store from a link on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitialAd *)ad {
    [self.customEventShowDelegate customEventShown];
}

/// Called when |ad| fails to present.
- (void)interstitialDidFailToPresentScreen:(GADInterstitialAd *)ad {
    
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitialAd *)ad {
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeInterstitial];
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitialAd *)ad {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeInterstitial];
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store). The normal
/// UIApplicationDelegate methods, like applicationDidEnterBackground:, will be called immediately
/// before this.
- (void)interstitialWillLeaveApplication:(GADInterstitialAd *)ad {
    [self.customEventShowDelegate customEventWillLeaveApplication];
}


@end
