// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "Alamofire": .framework, // default is .staticFramework
            "Then": .framework,
            "SnapKit": .framework,
            "ReactorKit": .framework,
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "Kingfisher": .framework,
            "KakaoSDKAuth": .framework,
            "KakaoSDKCommon": .framework,
            "FirebaseAuth": .framework,
            "GoogleSignIn": .framework
        ]
    )
#endif

let package = Package(
    name: "imdangg",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMinor(from:"5.7.0")),
        .package(url: "https://github.com/devxoul/Then", .upToNextMinor(from: "3.0.0")),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", .upToNextMinor(from: "3.2.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMinor(from: "6.8.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMinor(from: "8.1.0")),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", .upToNextMinor(from: "2.22.1")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", .upToNextMinor(from: "11.5.0")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", .upToNextMinor(from: "8.0.0"))
    ]
)

