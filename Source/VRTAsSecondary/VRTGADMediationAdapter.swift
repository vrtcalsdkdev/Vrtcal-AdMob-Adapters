// Google Mobile Ads Banner Adapter, Vrtcal as Secondary

import GoogleMobileAds
import VrtcalSDK

@objc(VRTGADMediationAdapter)
public final class VRTGADMediationAdapter: NSObject, GADMediationAdapter {
    
    // Vrtcal Init
    static var gadMediationAdapterSetUpCompletionBlock: GADMediationAdapterSetUpCompletionBlock?
    static var vrtGADMediationAdapterVrtcalSdkDelegate = VRTGADMediationAdapterVrtcalSdkDelegate()
    
    // Ads
    var vrtGadMediationBannerAd: VRTGADMediationBannerAd?
    var vrtGadMediationInterstitialAd: VRTGADMediationInterstitialAd?
    
    required public override init() {
        super.init()
    }
    
    public static func adapterVersion() -> GADVersionNumber {
        GADVersionNumber(majorVersion: 1, minorVersion: 0, patchVersion: 5)
    }
    
    public static func adSDKVersion() -> GADVersionNumber {
        let versionNumbers = VrtcalSDK
            .sdkVersion()
            .components(separatedBy: ".")
            .compactMap {
                Int($0)
            }
        
        guard versionNumbers.count == 3 else {
            return GADVersionNumber(majorVersion: 1, minorVersion: 0, patchVersion: 0)
        }
        
        return GADVersionNumber(
            majorVersion: versionNumbers[0],
            minorVersion: versionNumbers[1],
            patchVersion: versionNumbers[2]
        )
    }
    
    public static func networkExtrasClass() -> (any GADAdNetworkExtras.Type)? {
        return nil
    }
    

    public static func setUpWith(
        _ configuration: GADMediationServerConfiguration,
        completionHandler: @escaping GADMediationAdapterSetUpCompletionBlock
    ) {
        
        
        VRTLogInfo("configuration: \(configuration)")
        
        switch configuration.credentials.get(intSetting: "appid") {
        case .success(let appId):
            VRTGADMediationAdapter.gadMediationAdapterSetUpCompletionBlock = completionHandler
            
            VrtcalSDK.initializeSdk(
                withAppId: appId,
                sdkDelegate: VRTGADMediationAdapter.vrtGADMediationAdapterVrtcalSdkDelegate
            )
            
        case .failure(let vrtError):
            completionHandler(vrtError)
        }
    }
    
    // MARK: Banner
    public func loadBanner(
        for adConfiguration: GADMediationBannerAdConfiguration,
        completionHandler: @escaping GADMediationBannerLoadCompletionHandler
    ) {
        VRTLogInfo("adConfiguration: \(adConfiguration)")

        self.vrtGadMediationBannerAd = VRTGADMediationBannerAd()
        self.vrtGadMediationBannerAd?.loadBanner(
            for: adConfiguration,
            completionHandler: completionHandler
        )
    }
    
    // MARK: Interstitial
    public func loadInterstitial(
      for adConfiguration: GADMediationInterstitialAdConfiguration,
      completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler
    ) {
        VRTLogInfo("adConfiguration: \(adConfiguration)")

        self.vrtGadMediationInterstitialAd = VRTGADMediationInterstitialAd()
        self.vrtGadMediationInterstitialAd?.loadInterstitial(
            for: adConfiguration,
            completionHandler: completionHandler
        )
    }
}

// MARK: VrtcalSdkDelegate
class VRTGADMediationAdapterVrtcalSdkDelegate: VrtcalSdkDelegate {
    public func sdkInitialized() {
        VRTLogInfo()
        
        guard let gadMediationAdapterSetUpCompletionBlock = VRTGADMediationAdapter.gadMediationAdapterSetUpCompletionBlock else {
            VRTLogError("No gadMediationAdapterSetUpCompletionBlock")
            return
        }
        
        gadMediationAdapterSetUpCompletionBlock(nil)

        VRTGADMediationAdapter.gadMediationAdapterSetUpCompletionBlock = nil
    }
    
    public func sdkInitializationFailedWithError(_ error: any Error) {
        VRTLogError("\(error)")
        
        guard let gadMediationAdapterSetUpCompletionBlock = VRTGADMediationAdapter.gadMediationAdapterSetUpCompletionBlock else {
            VRTLogError("No gadMediationAdapterSetUpCompletionBlock")
            return
        }
        
        gadMediationAdapterSetUpCompletionBlock(error)

        VRTGADMediationAdapter.gadMediationAdapterSetUpCompletionBlock = nil
    }
}
