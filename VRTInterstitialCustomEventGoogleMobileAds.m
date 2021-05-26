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
    [self.customEventShowDelegate customEventWillPresentModal:VRTModalTypeInterstitial];
}


#pragma mark Display-Time Lifecycle Notifications


/// Tells the delegate that an impression has been recorded for the ad.
- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    //There is no Vrtcal analog for this event
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    //There is no Vrtcal analog for this event
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.customEventShowDelegate customEventShown];
    [self.customEventShowDelegate customEventDidPresentModal:VRTModalTypeInterstitial];
}

/// Tells the delegate that the ad will dismiss full screen content.
- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.customEventShowDelegate customEventWillDismissModal:VRTModalTypeInterstitial];
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self.customEventShowDelegate customEventDidDismissModal:VRTModalTypeInterstitial];
}

@end
