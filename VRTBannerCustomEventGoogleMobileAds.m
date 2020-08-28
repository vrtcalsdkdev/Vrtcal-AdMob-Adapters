//
//  VRTBannerCustomEventGoogleMobileAds.m
//
//  Created by Scott McCoy on 5/9/19.
//  Copyright © 2019 VRTCAL. All rights reserved.
//

//Header
#import "VRTBannerCustomEventGoogleMobileAds.h"

//Dependencies
#import <GoogleMobileAds/GoogleMobileAds.h>

//Google Mobile Ads Banner Adapter, Vrtcal as Primary
@interface VRTBannerCustomEventGoogleMobileAds() <GADBannerViewDelegate>
@property GADBannerView *gadBannerView;
@end


@implementation VRTBannerCustomEventGoogleMobileAds

- (void) loadBannerAd {
    NSString *adUnitId = [self.customEventConfig.thirdPartyCustomEventData objectForKey:@"adUnitId"];
    
    GADAdSize gadAdSize;
    gadAdSize.size = self.customEventConfig.adSize;
    self.gadBannerView = [[GADBannerView alloc] initWithAdSize:gadAdSize];
    self.gadBannerView.adUnitID = adUnitId;
    UIViewController *vc = [self.viewControllerDelegate vrtViewControllerForModalPresentation];
    self.gadBannerView.rootViewController = vc;
    self.gadBannerView.delegate = self;
    [self.gadBannerView loadRequest:[GADRequest request]];
}

- (UIView*) getView {
    return self.gadBannerView;
}


#pragma mark - GADBannerViewDelegate
/// Tells the delegate that an ad request successfully received an ad. The delegate may want to add
/// the banner view to the view hierarchy if it hasn't been added yet.
- (void)adViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    VRTLogWhereAmI();
    [self.customEventLoadDelegate customEventLoaded];
}

/// Tells the delegate that an ad request failed. The failure is normally due to network
/// connectivity or ad availablility (i.e., no fill).
- (void)adView:(nonnull GADBannerView *)bannerView didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    VRTLogInfo(@"error = %@", error);
    [self.customEventLoadDelegate customEventFailedToLoadWithError:error];
}

/// Tells the delegate that a full screen view will be presented in response to the user clicking on
/// an ad. The delegate may want to pause animations and time sensitive interactions.
- (void)adViewWillPresentScreen:(nonnull GADBannerView *)bannerView {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventClicked];
}

/// Tells the delegate that the full screen view will be dismissed.
- (void)adViewWillDismissScreen:(nonnull GADBannerView *)bannerView {
    VRTLogWhereAmI();
}

/// Tells the delegate that the full screen view has been dismissed. The delegate should restart
/// anything paused while handling adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(nonnull GADBannerView *)bannerView {
    VRTLogWhereAmI();
}

/// Tells the delegate that the user click will open another app, backgrounding the current
/// application. The standard UIApplicationDelegate methods, like applicationDidEnterBackground:,
/// are called immediately before this method is called.
- (void)adViewWillLeaveApplication:(nonnull GADBannerView *)bannerView {
    VRTLogWhereAmI();
    [self.customEventShowDelegate customEventClicked];
}


@end
