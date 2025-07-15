//
//  KakaoLoginService.swift
//  imdang
//
//  Created by 임대진 on 11/27/24.
//

import UIKit
import RxSwift
import RxKakaoSDKUser
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import Alamofire
import NetworkKit

class KakaoLoginService {
    static let shared = KakaoLoginService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func signIn() -> Observable<Bool> {
        return UserApi.shared.rx.loginWithKakaoTalk()
            .flatMap { oauthToken in
                return self.getKakaoInfo(oauthToken: oauthToken)
                    .flatMap { profile in
                        guard profile != nil else {
                            return Observable.just(false)
                        }
                        
                        return self.sendKakaoInfoToServer(oauthToken: oauthToken)
                    }
            }
            .catchAndReturn(false)
    }
    
    func getKakaoInfo(oauthToken: OAuthToken) -> Observable<Profile?> {
        return UserApi.shared.rx.me()
            .asObservable()
            .map { user in
                return user.kakaoAccount?.profile
            }
            .catch { error in
                print("Error in getKakaoInfo: \(error)")
                return Observable.just(nil)
            }
    }
    
    func sendKakaoInfoToServer(oauthToken: OAuthToken) -> Observable<Bool> {
        return Observable.create { [self] observer in
            
            let parameters: [String: Any] = [
                "provider" : "KAKAO",
                "token": oauthToken.accessToken
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
                        UserdefaultKey.signInType = SignInType.kakao.rawValue
                        observer.onNext(true)
                        observer.onCompleted()
                    },
                    onError: { error in
                        print("Request failed with error: \(error)")
                        observer.onNext(false)
                        observer.onCompleted()
                    }
                )
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func withdrawalToServer() -> Observable<Bool> {
        guard AuthApi.hasToken() else {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(SigninViewController(), animated: true)
            return Observable.just(false)
        }

        return UserApi.shared.rx.accessTokenInfo()
            .asObservable()
            .flatMap { _ in
                return Observable.just(AUTH.tokenManager.getToken()?.accessToken)
            }
            .catch { error -> Observable<String?> in
                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() {
                    return AuthApi.shared.rx.refreshToken()
                        .asObservable()
                        .map { $0.accessToken }
                }
                return Observable.just(nil)
            }
            .compactMap { $0 }
            .flatMap { [self] token in
                let parameters: [String: Any] = ["token": token]
                let endpoint = Endpoint<BasicResponse>(
                    baseURL: .imdangAPI,
                    path: "/members/withdrawal/kakao",
                    method: .post,
                    headers: [
                        .contentType("application/json"),
                        .authorization(bearerToken: UserdefaultKey.accessToken)
                    ],
                    parameters: parameters
                )

                return networkManager.requestOptional(with: endpoint)
                    .map { _ in
                        UserdefaultKey.resetUserDefaults()
                        return true
                    }
                    .catch { error in
                        print("Kakao Withdrawal request failed with error: \(error)")
                        return Observable.just(false)
                    }
            }
    }

}
