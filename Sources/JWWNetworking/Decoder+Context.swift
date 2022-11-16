import Foundation

/// Empty protocol that can be used to define a context object that can be attached to any `Decoder`
protocol DecodingContext { }

extension CodingUserInfoKey {
    /// Custom coding key that can be used to declare a `DecodingContext`.
    static let decodingContext = CodingUserInfoKey(rawValue: "com.justinwme.jwwnetworking.decoding-context")!
}

extension Decoder {
    /// Custom payload that can be used as part of the decoding.
    var context: DecodingContext? {
        userInfo[CodingUserInfoKey.decodingContext] as? DecodingContext
    }
}

extension JSONDecoder {
    /// Custom payload that can be used as part of the JSON decoding.
    var context: DecodingContext? {
        get { userInfo[CodingUserInfoKey.decodingContext] as? DecodingContext }
        set { userInfo[CodingUserInfoKey.decodingContext] = newValue }
     }
}
