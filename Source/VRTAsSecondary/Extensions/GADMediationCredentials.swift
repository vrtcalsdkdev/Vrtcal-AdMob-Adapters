import VrtcalSDK
import GoogleMobileAds


extension GADMediationCredentials {
    
    func get(intSetting: String) -> Result<Int, VRTError> {
        guard let json = settings["parameter"] as? String else {
            return .failure(
                VRTError(
                    vrtErrorCode: .customEvent,
                    message: "Unable to extract json: \(self)"
                )
            )
        }
        
        // Convert to [String: Any]
        let jsonSerializationHelperResult = JsonSerializationHelper.stringAnyDict(
            string: json
        )
        
        // Unpack the Result
        guard case let .success(stringAnyDict) = jsonSerializationHelperResult else {
            return .failure(
                VRTError(
                    vrtErrorCode: .customEvent,
                    message: "Could not convert json \(json) to [String: Any]: \(jsonSerializationHelperResult)"
                )
            )
        }
        
        guard let caseInsensitiveKey = stringAnyDict.keys.first(where: {
            $0.lowercased() == intSetting
        }) else {
            return .failure(
                VRTError(
                    vrtErrorCode: .customEvent,
                    message: "No matching key for \(intSetting): \(stringAnyDict)"
                )
            )
        }

        guard let anyValue = stringAnyDict[caseInsensitiveKey] else {
            return .failure(
                VRTError(
                    vrtErrorCode: .customEvent,
                    message: "caseInsensitiveKey \(caseInsensitiveKey) not found: \(stringAnyDict)"
                )
            )
        }
        
        guard let intValue = Int("\(anyValue)") else {
            return .failure(
                VRTError(
                    vrtErrorCode: .customEvent,
                    message: "Unable to cast to int: \(anyValue)"
                )
            )
        }
        
        return .success(intValue)
    }
    
}

extension Array<GADMediationCredentials> {
    func get(intSetting: String) -> Result<Int, VRTError> {
        guard let first = self.first else {
            return .failure(
                VRTError(
                    vrtErrorCode: .customEvent,
                    message: "Empty array: \(self)"
                )
            )
        }
        
        return first.get(intSetting: intSetting)
    }
}

