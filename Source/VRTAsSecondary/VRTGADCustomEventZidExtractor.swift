// Google Mobile Ads Adapter, Vrtcal as Secondary

import VrtcalSDK

// Google stores their configuration in a JSON string
// This fetches the zid field
enum VRTGADCustomEventZidExtractor {
    
    static func extract(
        serverParameter: String?
    ) -> Result<Int, VRTError> {
        
        // Get serverParameter
        guard let serverParameter else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "serverParameter nil"
            )
            return .failure(vrtError)
        }
        
        // Convert to [String: Any]
        let jsonSerializationHelperResult = JsonSerializationHelper.stringAnyDict(
            string: serverParameter
        )
        
        // Unpack the Result
        guard case let .success(stringAnyDict) = jsonSerializationHelperResult else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Could not convert serverParameter \(serverParameter) to [String: Any]: \(jsonSerializationHelperResult)"
            )
            
            return .failure(vrtError)
        }
        
        // Get zid
        guard let strZid = stringAnyDict["zid"] as? String,
        let zid = Int(strZid) else {
            let vrtError = VRTError(
                vrtErrorCode: .customEvent,
                message: "Unable to extract zid from stringAnyDict: \(stringAnyDict)"
            )
            return .failure(vrtError)
        }
        
        // Success
        return .success(zid)
    }
}
