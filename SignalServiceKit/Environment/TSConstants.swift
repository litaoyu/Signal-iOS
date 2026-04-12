//
// Copyright 2019 Signal Messenger, LLC
// SPDX-License-Identifier: AGPL-3.0-only
//

// MARK: -

import Foundation
public import LibSignalClient

public class TSConstants {

    private enum Environment {
        case production
        case staging
    }

    private static let environment: Environment = {
// You can set "USE_STAGING=1" in your Xcode Scheme. This allows you to
// prepare a series of commits without accidentally committing the change
// to the environment.
#if DEBUG
        if ProcessInfo.processInfo.environment["USE_STAGING"] == "1" {
            return .staging
        }
#endif

        // If you do want to make a build that will always connect to staging,
        // change this value. (Scheme environment variables are only set when
        // launching via Xcode, so this approach is still quite useful.)
        return .production
    }()

    public static var isUsingProductionService: Bool {
        return environment == .production
    }

    // Never instantiate this class.
    private init() {}

    public static let legalTermsUrl = URL(string: "https://signal.org/legal/")!
    public static let donateUrl = URL(string: "https://signal.org/donate/")!
    public static let appStoreUrl = URL(string: "https://itunes.apple.com/us/app/signal-private-messenger/id874139669?mt=8")!

    public static var mainServiceURL: String { shared.mainServiceURL }

    public static var textSecureCDN0ServerURL: String { shared.textSecureCDN0ServerURL }
    public static var textSecureCDN2ServerURL: String { shared.textSecureCDN2ServerURL }
    public static var textSecureCDN3ServerURL: String { shared.textSecureCDN3ServerURL }
    public static var storageServiceURL: String { shared.storageServiceURL }
    public static var sfuURL: String { shared.sfuURL }
    public static var sfuTestURL: String { shared.sfuTestURL }
    public static var svr2URL: String { shared.svr2URL }
    public static var registrationCaptchaURL: String { shared.registrationCaptchaURL }
    public static var challengeCaptchaURL: String { shared.challengeCaptchaURL }
    public static var kUDTrustRoots: [String] { shared.kUDTrustRoots }
    public static var updatesURL: String { shared.updatesURL }
    public static var updates2URL: String { shared.updates2URL }

    public static var censorshipFReflectorHost: String { shared.censorshipFReflectorHost }
    public static var censorshipGReflectorHost: String { shared.censorshipGReflectorHost }

    public static var serviceCensorshipPrefix: String { shared.serviceCensorshipPrefix }
    public static var cdn0CensorshipPrefix: String { shared.cdn0CensorshipPrefix }
    public static var cdn2CensorshipPrefix: String { shared.cdn2CensorshipPrefix }
    public static var cdn3CensorshipPrefix: String { shared.cdn3CensorshipPrefix }
    public static var storageServiceCensorshipPrefix: String { shared.storageServiceCensorshipPrefix }
    public static var svr2CensorshipPrefix: String { shared.svr2CensorshipPrefix }

    static var svr2Enclave: MrEnclave { shared.svr2Enclave }
    static var svr2PreviousEnclaves: [MrEnclave] { shared.svr2PreviousEnclaves }

    public static var applicationGroup: String { shared.applicationGroup }

    public static var serverPublicParams: Data { shared.serverPublicParams }
    public static var callLinkPublicParams: Data { shared.callLinkPublicParams }
    public static var backupServerPublicParams: Data { shared.backupServerPublicParams }

    public static let shared: TSConstantsProtocol = {
        switch environment {
        case .production:
            return TSConstantsProduction()
        case .staging:
            return TSConstantsProduction()
        }
    }()

    public static let libSignalEnv: Net.Environment = {
        switch environment {
        case .production:
            return .production
        case .staging:
            return .staging
        }
    }()
}

// MARK: -

public protocol TSConstantsProtocol: AnyObject {
    var mainServiceURL: String { get }
    var textSecureCDN0ServerURL: String { get }
    var textSecureCDN2ServerURL: String { get }
    var textSecureCDN3ServerURL: String { get }
    var storageServiceURL: String { get }
    var sfuURL: String { get }
    var sfuTestURL: String { get }
    var svr2URL: String { get }
    var registrationCaptchaURL: String { get }
    var challengeCaptchaURL: String { get }
    var kUDTrustRoots: [String] { get }
    var updatesURL: String { get }
    var updates2URL: String { get }

    var censorshipFReflectorHost: String { get }
    var censorshipGReflectorHost: String { get }

    var serviceCensorshipPrefix: String { get }
    var cdn0CensorshipPrefix: String { get }
    var cdn2CensorshipPrefix: String { get }
    var cdn3CensorshipPrefix: String { get }
    var storageServiceCensorshipPrefix: String { get }
    var svr2CensorshipPrefix: String { get }

    var svr2Enclave: MrEnclave { get }
    var svr2PreviousEnclaves: [MrEnclave] { get }

    var applicationGroup: String { get }

    var serverPublicParams: Data { get }
    var callLinkPublicParams: Data { get }
    var backupServerPublicParams: Data { get }
}

public struct MrEnclave: Equatable {
    public let dataValue: Data
    public let stringValue: String

    init(_ stringValue: StaticString) {
        self.stringValue = String(describing: stringValue)
        // This is a constant -- it should never fail to parse.
        self.dataValue = Data.data(fromHex: self.stringValue)!
        // All of our MrEnclave values are currently 32 bytes.
        owsPrecondition(self.dataValue.count == 32)
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.dataValue == rhs.dataValue
    }
}

// MARK: - Production

// MARK: - Production

public class TSConstantsProduction: TSConstantsProtocol {

    public init() {}

    public let mainServiceURL = "https://chat.notechat.me"
    public let textSecureCDN0ServerURL = "https://chat.notechat.me"
    public let textSecureCDN2ServerURL = "https://chat.notechat.me"
    public let textSecureCDN3ServerURL = "https://upload.notechat.me"
//    public let storageServiceURL = "https://storage.signal.org"
    public let storageServiceURL = "https://storage.notechat.me"

//    public let sfuURL = "https://sfu.voip.signal.org"
//    public let sfuTestURL = "https://sfu.test.voip.signal.org"
    public let sfuURL = "https://calling.notechat.me"
    public let sfuTestURL = "https://calling.notechat.me"
    
//    public let svr2URL = "wss://svr2.signal.org"
    public let svr2URL = "wss://chat.notechat.me"

//    public let registrationCaptchaURL = "https://signalcaptchas.org/registration/generate.html"
//    public let challengeCaptchaURL = "https://signalcaptchas.org/challenge/generate.html"
    public let registrationCaptchaURL = ""
    public let challengeCaptchaURL = ""
    
//    public let kUDTrustRoots = ["BXu6QIKVz5MA8gstzfOgRQGqyLqOwNKHL6INkv3IHWMF", "BUkY0I+9+oPgDCn4+Ac6Iu813yvqkDr/ga8DzLxFxuk6"]
    public let kUDTrustRoots = ["Bc9JVWTApS5ejX3C0A6PijspWuaVO7eaTCl5qUZyrfl+"]
    public let updatesURL = "https://updates.signal.org"
    public let updates2URL = "https://updates2.signal.org"
//    public let updatesURL = ""
//    public let updates2URL = ""

//    public let censorshipFReflectorHost = "reflector-signal.global.ssl.fastly.net"
//    public let censorshipGReflectorHost = "reflector-nrgwuv7kwq-uc.a.run.app"
    public let censorshipFReflectorHost = ""
    public let censorshipGReflectorHost = ""

    public let serviceCensorshipPrefix = "service"
    public let cdn0CensorshipPrefix = "cdn"
    public let cdn2CensorshipPrefix = "cdn2"
    public let cdn3CensorshipPrefix = "cdn3"
    public let storageServiceCensorshipPrefix = "storage"
    public let svr2CensorshipPrefix = "svr2"

    public let svr2Enclave = MrEnclave("1240acbd4aa26974184844c8a46b1022d3957ac8a76c1fd8f5b1a15141ee0708")

    // An array of previously used enclaves that we should try and restore
    // key material from during registration. These must be ordered from
    // newest to oldest, so we check the latest enclaves for backups before
    // checking earlier enclaves.
    public let svr2PreviousEnclaves: [MrEnclave] = [
        MrEnclave("29cd63c87bea751e3bfd0fbd401279192e2e5c99948b4ee9437eafc4968355fb"),
    ]

    public let applicationGroup = "group." + Bundle.main.bundleIdPrefix + ".signal.group"

    /// We *might* need to clear credentials (or perform some other migration)
    /// when this value changes, depending on how it's changing. If you do need
    /// to perform a migration, check out `ZkParamsMigrator`.
    public let serverPublicParams = Data(base64Encoded: "AOLedOPsnFJLRqt6txHTA/j2mHJkpaO7+HvutOIKGpIphLm9MvRwIXMtnp3K6Xj9AHmmOu1gKVBvawSKTtyGe1WK1lmqYXYo7FweQCts0C/+1yO7sD4ZxsExA93JvvFGVgwbkjod1FgHtM/s8K3Aqzaek+YKUEX0Jgh4t5SD6bgs3IOkxr9Qi9MBXuh37+k7N4/pFXKi3SmcuCl2BEzGkHu2SYIf2mBYDo8V1/tZD3PXgoaYF2foDZ5ZafHtWMB7ATq2Ndt90osJ2bbVnWA6Q/zkPZfS8jcpb7NI2eUej2JaPoFhYWTtV62zhRYg2Ht9M1iXgT8zQqN7tEc4/7DWDUt04rINj5B8OFaooVmb0vbBKqupzHHDS7HW30bxh7JucbiTx0vCGPhWGJChliCMyEkUojYR+sICoxJzanolh2YrjOsWQmLgsfbLaWijNeM92p01/pR+i3EnVPrc6HB9/gsgqlBHydLl0M3+SYHhWpZ1KtstfEFcTn1/eV8hWYqJWUyd7NJ7MfrgbKG+LZPgxOf/EDIPSilSAMaDmrksacEbzF6BUiOyDsvOeLnWjKhrj3lEkENZ2af0J9lMpIN2CldAjzh6b+86v8zRxixGcwsqDOzY1teU6L8UimXBQPY4fR4h4LuIUheYK9pKa61skJKaNangrnUCFDEbEbQThKZQ5HBxRCmForp8+/vkR7Yee+dcejGP90Y3kAzTR6lsEBW8USbx8uxzvDWYqtfL9tpqhOyMIjN2ZHwrXXZ5fZyCV9gqhhJJAhXTQZPNq2XLBeRona1gdG5+lxNzDXroa2ZBpCZCZrWK5OcIAUFhF5GauxW0AKOZC+ewyhWgVsJhiGTsXHjNGAco/KGdCFaGT2VP5NWryDVwU5Hkbx9829ZGBQ==")!

    public let callLinkPublicParams = Data(base64Encoded: "AGz1Su40LS2e9g4yyUsA3XhUKz7xgtu+pjvaaF4Tv9gA4oaBgApDtPnu3K5hSAuh31aefWQ2qQrYcI+174f7UE0qjjnFUaH9zSR1hvMAchYv3SfbghPUdw1eqN5eh7JVJC5kOho20PzrKckvle99viKBpTNsiJl52oUOds5K0/lhVA7ZXlVU3zVcDCmuD8Uu8FlYZq5DDK5HPTJKiKAVJ3nWCuomrJ0k8amy1cnXmPt6V9hPGxJNiOFxUSo0DwDQRgBzxMUs+gT9pLuHZ9meukyoZTbvLbj2j/gPX1npG0Va")!

    public let backupServerPublicParams = Data(base64Encoded: "AJhiOJTg9iN2jLn+Ic13FSi30Bmm3F2uZEzt7XpVrLhQXGsoeQz/yX2HDxDsipMXPCxVtahSHkzHWKK+n62HgWL+n2z6SGkTyL0pGz+pJou2ubaREYmNIdL7jT5SAN+5dnAxwm/TFxH8qGaCrkhheW2lTekoe76lc62Js0wLlNh2GAACuuhb+Pv+BMbQhL6Fu1oUSsub1+q7zkzKLd/3XEaUHLEhlTNM/CipjJqa5abyA6l1gp72w/N4L/3ocwL6Iu5M5CNfpObvK7Jm+X+F72momDVhuaf+MfqKYYiGq1w0")!
}

// MARK: - Staging

//public class TSConstantsStaging: TSConstantsProtocol {
//
//    public init() {}
//
//    public let mainServiceURL = "https://chat.staging.signal.org"
//    public let textSecureCDN0ServerURL = "https://cdn-staging.signal.org"
//    public let textSecureCDN2ServerURL = "https://cdn2-staging.signal.org"
//    public let textSecureCDN3ServerURL = "https://cdn3-staging.signal.org"
//    public let storageServiceURL = "https://storage-staging.signal.org"
//    public let sfuURL = "https://sfu.staging.voip.signal.org"
//    public let svr2URL = "wss://svr2.staging.signal.org"
//    public let registrationCaptchaURL = "https://signalcaptchas.org/staging/registration/generate.html"
//    public let challengeCaptchaURL = "https://signalcaptchas.org/staging/challenge/generate.html"
//    // There's no separate test SFU for staging.
//    public let sfuTestURL = "https://sfu.test.voip.signal.org"
//    public let kUDTrustRoots = ["BbqY1DzohE4NUZoVF+L18oUPrK3kILllLEJh2UnPSsEx", "BYhU6tPjqP46KGZEzRs1OL4U39V5dlPJ/X09ha4rErkm"]
//    // There's no separate updates endpoint for staging.
//    public let updatesURL = "https://updates.signal.org"
//    public let updates2URL = "https://updates2.signal.org"
//
//    public let censorshipFReflectorHost = "reflector-staging-signal.global.ssl.fastly.net"
//    public let censorshipGReflectorHost = "reflector-nrgwuv7kwq-uc.a.run.app"
//
//    public let serviceCensorshipPrefix = "service-staging"
//    public let cdn0CensorshipPrefix = "cdn-staging"
//    public let cdn2CensorshipPrefix = "cdn2-staging"
//    public let cdn3CensorshipPrefix = "cdn3-staging"
//    public let storageServiceCensorshipPrefix = "storage-staging"
//    public let svr2CensorshipPrefix = "svr2-staging"
//
//    public let svr2Enclave = MrEnclave("97f151f6ed078edbbfd72fa9cae694dcc08353f1f5e8d9ccd79a971b10ffc535")
//
//    // An array of previously used enclaves that we should try and restore
//    // key material from during registration. These must be ordered from
//    // newest to oldest, so we check the latest enclaves for backups before
//    // checking earlier enclaves.
//    public let svr2PreviousEnclaves: [MrEnclave] = [
//        MrEnclave("a75542d82da9f6914a1e31f8a7407053b99cc99a0e7291d8fbd394253e19b036"),
//    ]
//
//    public let applicationGroup = "group." + Bundle.main.bundleIdPrefix + ".signal.group.staging"
//
//    /// We *might* need to clear credentials (or perform some other migration)
//    /// when this value changes, depending on how it's changing. If you do need
//    /// to perform a migration, check out `ZkParamsMigrator`.
//    public let serverPublicParams = Data(base64Encoded: "ABSY21VckQcbSXVNCGRYJcfWHiAMZmpTtTELcDmxgdFbtp/bWsSxZdMKzfCp8rvIs8ocCU3B37fT3r4Mi5qAemeGeR2X+/YmOGR5ofui7tD5mDQfstAI9i+4WpMtIe8KC3wU5w3Inq3uNWVmoGtpKndsNfwJrCg0Hd9zmObhypUnSkfYn2ooMOOnBpfdanRtrvetZUayDMSC5iSRcXKpdlukrpzzsCIvEwjwQlJYVPOQPj4V0F4UXXBdHSLK05uoPBCQG8G9rYIGedYsClJXnbrgGYG3eMTG5hnx4X4ntARBgELuMWWUEEfSK0mjXg+/2lPmWcTZWR9nkqgQQP0tbzuiPm74H2wMO4u1Wafe+UwyIlIT9L7KLS19Aw8r4sPrXZSSsOZ6s7M1+rTJN0bI5CKY2PX29y5Ok3jSWufIKcgKOnWoP67d5b2du2ZVJjpjfibNIHbT/cegy/sBLoFwtHogVYUewANUAXIaMPyCLRArsKhfJ5wBtTminG/PAvuBdJ70Z/bXVPf8TVsR292zQ65xwvWTejROW6AZX6aqucUjlENAErBme1YHmOSpU6tr6doJ66dPzVAWIanmO/5mgjNEDeK7DDqQdB1xd03HT2Qs2TxY3kCK8aAb/0iM0HQiXjxZ9HIgYhbtvGEnDKW5ILSUydqH/KBhW4Pb0jZWnqN/YgbWDKeJxnDbYcUob5ZY5Lt5ZCMKuaGUvCJRrCtuugSMaqjowCGRempsDdJEt+cMaalhZ6gczklJB/IbdwENW9KeVFPoFNFzhxWUIS5ML9riVYhAtE6JE5jX0xiHNVIIPthb458cfA8daR0nYfYAUKogQArm0iBezOO+mPk5vCNWI+wwkyFCqNDXz/qxl1gAntuCJtSfq9OC3NkdhQlgYQ==")!
//
//    public let callLinkPublicParams = Data(base64Encoded: "AHILOIrFPXX9laLbalbA9+L1CXpSbM/bTJXZGZiuyK1JaI6dK5FHHWL6tWxmHKYAZTSYmElmJ5z2A5YcirjO/yfoemE03FItyaf8W1fE4p14hzb5qnrmfXUSiAIVrhaXVwIwSzH6RL/+EO8jFIjJ/YfExfJ8aBl48CKHgu1+A6kWynhttonvWWx6h7924mIzW0Czj2ROuh4LwQyZypex4GuOPW8sgIT21KNZaafgg+KbV7XM1x1tF3XA17B4uGUaDbDw2O+nR1+U5p6qHPzmJ7ggFjSN6Utu+35dS1sS0P9N")!
//
//    public let backupServerPublicParams = Data(base64Encoded: "AHYrGb9IfugAAJiPKp+mdXUx+OL9zBolPYHYQz6GI1gWjpEu5me3zVNSvmYY4zWboZHif+HG1sDHSuvwFd0QszSwuSF4X4kRP3fJREdTZ5MCR0n55zUppTwfHRW2S4sdQ0JGz7YDQIJCufYSKh0pGNEHL6hv79Agrdnr4momr3oXdnkpVBIp3HWAQ6IbXQVSG18X36GaicI1vdT0UFmTwU2KTneluC2eyL9c5ff8PcmiS+YcLzh0OKYQXB5ZfQ06d6DiINvDQLy75zcfUOniLAj0lGJiHxGczin/RXisKSR8")!
//
//}

#if TESTABLE_BUILD

public class TSConstantsMock: TSConstantsProtocol {

    public init() {}

    private let defaultValues = TSConstantsProduction()

    public lazy var mainServiceURL = defaultValues.mainServiceURL

    public lazy var textSecureCDN0ServerURL = defaultValues.textSecureCDN0ServerURL

    public lazy var textSecureCDN2ServerURL = defaultValues.textSecureCDN2ServerURL

    public lazy var textSecureCDN3ServerURL = defaultValues.textSecureCDN3ServerURL

    public lazy var storageServiceURL = defaultValues.storageServiceURL

    public lazy var sfuURL = defaultValues.sfuURL

    public lazy var sfuTestURL = defaultValues.sfuTestURL

    public lazy var svr2URL = defaultValues.svr2URL

    public lazy var registrationCaptchaURL = defaultValues.registrationCaptchaURL

    public lazy var challengeCaptchaURL = defaultValues.challengeCaptchaURL

    public lazy var kUDTrustRoots = defaultValues.kUDTrustRoots

    public lazy var updatesURL = defaultValues.updatesURL

    public lazy var updates2URL = defaultValues.updates2URL

    public lazy var censorshipFReflectorHost = defaultValues.censorshipFReflectorHost
    public lazy var censorshipGReflectorHost = defaultValues.censorshipGReflectorHost

    public lazy var serviceCensorshipPrefix = defaultValues.serviceCensorshipPrefix

    public lazy var cdn0CensorshipPrefix = defaultValues.cdn0CensorshipPrefix

    public lazy var cdn2CensorshipPrefix = defaultValues.cdn2CensorshipPrefix

    public lazy var cdn3CensorshipPrefix = defaultValues.cdn3CensorshipPrefix

    public lazy var storageServiceCensorshipPrefix = defaultValues.storageServiceCensorshipPrefix

    public lazy var svr2CensorshipPrefix = defaultValues.svr2CensorshipPrefix

    public lazy var svr2Enclave = defaultValues.svr2Enclave

    public lazy var svr2PreviousEnclaves = defaultValues.svr2PreviousEnclaves

    public lazy var applicationGroup = defaultValues.applicationGroup

    public lazy var serverPublicParams = defaultValues.serverPublicParams

    public lazy var callLinkPublicParams = defaultValues.callLinkPublicParams

    public lazy var backupServerPublicParams = defaultValues.backupServerPublicParams
}

#endif
