//
//  GoogleLoginService.swift
//  imdang
//
//  Created by 임대진 on 11/27/24.
//

// GoogleLoginService.swift
import RxSwift
import GoogleSignIn
import NetworkKit

class GoogleLoginService {
    static let shared = GoogleLoginService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func signIn() -> Observable<Bool> {
        return Observable.create { observer in
            guard let rootViewController = UIApplication.shared.currentRootViewController else {
                observer.onError(NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "No root view controller available"]))
                observer.onCompleted()
                return Disposables.create()
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [self] signInResult, error in
                if let error = error {
                    print("Google sign-in error: \(error)")
                    observer.onNext(false)
                    observer.onCompleted()
                } else {
                    print("Google sign-in success: \(signInResult?.user.profile?.name ?? "")")
                    
                    if let accessToken = signInResult?.user.accessToken {
//                        let parameters: [String: Any] = [
//                            "accessToken": accessToken.tokenString
//                        ]
//                        
//                        let endpoint = Endpoint<User>(
//                            baseURL: .imdangAPI,
//                            path: "/auth/google",
//                            method: .post,
//                            parameters: parameters
//                        )
                        
                        let parameters: [String: Any] = [
                            "provider" : "GOOGLE",
                            "token": accessToken.tokenString
                        ]

                        let endpoint = Endpoint<UserResponse>(
                            baseURL: .imdangAPI,
                            path: "/login",
                            method: .post,
                            parameters: parameters
                        )
                        
                        networkManager.request(with: endpoint)
                            .subscribe(
                                onNext: { entity in
                                    UserdefaultKey.isJoined = entity.user.isJoined
                                    UserdefaultKey.accessToken = entity.user.accessToken
                                    UserdefaultKey.refreshToken = entity.user.refreshToken
                                    UserdefaultKey.tokenTimeInterval = Date().timeIntervalSince1970
                                    UserdefaultKey.memberId = entity.user.memberId
                                    UserdefaultKey.signInType = SignInType.google.rawValue
                                    observer.onNext(true)
                                    observer.onCompleted()
                                },
                                onError: { error in
                                    observer.onNext(false)
                                    observer.onCompleted()
                                }
                            )
                            .disposed(by: disposeBag)
                    } else {
                        print("token not found")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func withdrawalToServer() -> Observable<Bool> {
        guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
            print("GIDSignIn.sharedInstance.currentUser is nil")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SigninViewController(), animated: true)
            return Observable.just(false)
        }
        return Observable.create { [self] observer in
            var parameters: [String: Any] = [:]
            
            if currentUser.accessToken.expirationDate?.timeIntervalSinceNow ?? 0 > 0 {
                parameters["token"] = currentUser.accessToken.tokenString
            } else {
                currentUser.refreshTokensIfNeeded {  user, error in
                    if let error = error {
                        print("Token refresh error: \(error.localizedDescription)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }

                    if let newAccessToken = user?.accessToken.tokenString {
                        parameters["token"] = newAccessToken
                    }
                }
            }
            
            let endpoint = Endpoint<BasicResponse>(
                baseURL: .imdangAPI,
                path: "/members/withdrawal/google",
                method: .post,
                headers: [
                    .contentType("application/json"),
                    .authorization(bearerToken: UserdefaultKey.accessToken)
                ],
                parameters: parameters
            )
            
            networkManager.requestOptional(with: endpoint)
                .subscribe(onNext: { _ in
                    UserdefaultKey.resetUserDefaults()
                    observer.onNext(true)
                    observer.onCompleted()
                },
                onError: { error in
                    print("Google Withdrawal request failed with error: \(error)")
                    observer.onNext(false)
                    observer.onCompleted()
                }
            )
            .disposed(by: disposeBag)
            return Disposables.create()
        }
    }
}

