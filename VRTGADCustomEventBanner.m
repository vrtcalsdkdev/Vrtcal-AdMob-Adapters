//Header
#import "VRTGADCustomEventBanner.h"

//Dependencies
#import <VrtcalSDK/VrtcalSDK.h>

//Google Mobile Ads Banner Adapter, Vrtcal as Secondary
@interface VRTGADCustomEventBanner () <VRTBannerDelegate>
@property VRTBanner *vrtBanner;
@end

@implementation VRTGADCustomEventBanner

@synthesize delegate;

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request {

    VRTLogWhereAmI();
    NSError *jsonError = nil;
    NSData *jsonData = [serverParameter dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    if (!jsonDict) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent format:@"VrtcalSDK unable to extract json from serverParameter: %@", serverParameter];
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }
    
    NSString *strZid = jsonDict[@"zid"];
    int zid = [strZid intValue];
    if (zid == 0) {
        VRTError *error = [VRTError errorWithCode:VRTErrorCodeCustomEvent format:@"VrtcalSDK Unable to extract ZoneID from jsonDict: %@", jsonDict];
        [self.delegate customEventBanner:self didFailAd:error];
        return;
    }

    self.vrtBanner = [[VRTBanner alloc] initWithFrame:CGRectMake(0, 0, adSize.size.width, adSize.size.height)];
    self.vrtBanner.adDelegate = self;
    [self.vrtBanner loadAd:zid];
}

#pragma mark - VRTBanner
- (void)vrtBannerAdLoaded:(nonnull VRTBanner *)vrtBanner withAdSize:(CGSize)adSize {
    [self.delegate customEventBanner:self didReceiveAd:vrtBanner];
}

-(void)vrtBannerAdFailedToLoad:(VRTBanner *)vrtBanner error:(NSError *)error {
    [self.delegate customEventBanner:self didFailAd:error];
}

-(void)vrtBannerAdClicked:(VRTBanner *)vrtBanner {
    [self.delegate customEventBannerWasClicked:self];
}

- (void)vrtBannerWillPresentModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    [self.delegate customEventBannerWillPresentModal:self];
}

- (void)vrtBannerDidPresentModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    
}

- (void)vrtBannerWillDismissModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    [self.delegate customEventBannerWillDismissModal:self];
}

- (void)vrtBannerDidDismissModal:(nonnull VRTBanner *)vrtBanner ofType:(VRTModalType)modalType {
    [self.delegate customEventBannerDidDismissModal:self];
}

- (void)vrtBannerAdWillLeaveApplication:(nonnull VRTBanner *)vrtBanner {
    [self.delegate customEventBannerWillLeaveApplication:self];
}

-(UIViewController*)vrtViewControllerForModalPresentation{
    return self.delegate.viewControllerForPresentingModalView;
}

- (void)vrtBannerVideoStarted:(nonnull VRTBanner *)vrtBanner {
    //Google Mobile Ads doesn't have an analog to this event.
}

- (void)vrtBannerVideoCompleted:(nonnull VRTBanner *)vrtBanner {
    //Google Mobile Ads doesn't have an analog to this event.
}






















@end
