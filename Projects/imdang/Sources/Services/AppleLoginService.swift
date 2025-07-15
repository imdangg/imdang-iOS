//
//  AppleLoginService.swift
//  imdang
//
//  Created by daye on 11/14/24.
//

import Foundation
import AuthenticationServices
import RxSwift
import NetworkKit

class AppleLoginService: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private let networkManager = NetworkManager()
    static let shared = AppleLoginService()
    let disposebag = DisposeBag()
    
    let loginResult = PublishSubject<Result<ASAuthorizationAppleIDCredential, Error>>()
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
    
    func startSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email] //이름, 메일
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let code = String(data: authorizationCode, encoding: .utf8) {
                print("Authorization Code: \(code)")
//                UserdefaultKey.refreshToken = appleIDCredential.authorizationCode.
                
                // 서버로 authorizationCode 전송
                sendAppleInfoToServer(authorizationCode: code)
                    .subscribe(
                        onNext: { success in
                            if success {
                                print("Apple 로그인 성공: 사용자 정보가 서버에 저장되었습니다.")
                                self.loginResult.onNext(.success(appleIDCredential))
                            } else {
                                print("Apple 로그인 실패: 서버 처리 중 문제가 발생했습니다.")
                                self.loginResult.onNext(.failure(NSError(domain: "AppleLogin", code: -1, userInfo: [NSLocalizedDescriptionKey: "서버 처리 실패"])))
                            }
                        },
                        onError: { error in
                            print("Apple 로그인 네트워크 에러: \(error.localizedDescription)")
                            self.loginResult.onNext(.failure(error))
                        }
                    )
                    .disposed(by: disposebag)
            }
        }
    }

    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let nsError = error as NSError
            if nsError.domain == ASAuthorizationError.errorDomain && nsError.code == ASAuthorizationError.canceled.rawValue {
                print("취소됨")
            } else {
                print("Apple Login Error: \(error.localizedDescription)")
                loginResult.onNext(.failure(error))
            }
    }
}

extension AppleLoginService {
    func sendAppleInfoToServer(authorizationCode: String) -> Observable<Bool> {
        return Observable.create { [self] observer in
            
            let parameters: [String: Any] = [
                "provider" : "GOOGLE",
                "token": authorizationCode
            ]
            let endpoint = Endpoint<User>(
                baseURL: .imdangAPI,
                path: "/login",
                method: .post,
                parameters: parameters
            )
            
            networkManager.request(with: endpoint)
                .subscribe(
                    onNext: { response in
                        UserdefaultKey.isJoined = response.isJoined
                        UserdefaultKey.accessToken = response.accessToken
                        UserdefaultKey.memberId = response.memberId
                        UserdefaultKey.tokenTimeInterval = Date().timeIntervalSince1970
                        UserdefaultKey.refreshToken = response.refreshToken
                        UserdefaultKey.signInType = SignInType.apple.rawValue
                        observer.onNext(true)
                        observer.onCompleted()
                    },
                    onError: { error in
                        print("Request failed with error: \(error)")

                        observer.onNext(false)
                        observer.onCompleted()
                    }
                )
                .disposed(by: disposebag)
            
            return Disposables.create()
        }
    }
    
    
    
    func sendAppleWithdrawalToServer() -> Observable<Bool> {
        
        let parameters: [String: Any] = [
            "token": UserdefaultKey.refreshToken
        ]
        
        let endpoint = Endpoint<EmptyResponse>(
            baseURL: .imdangAPI,
            path: "/members/withdrawal/apple",
            method: .post,
            encodingType: .body,
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
                print("Withdrawal request failed with error: \(error)")
                return Observable.just(false)
            }
    }
}

