//
//  InsightDetailViewModel.swift
//  SharedLibraries
//
//  Created by 임대진 on 2/1/25.
//

import UIKit
import NetworkKit
import RxSwift
import Alamofire

enum RecommendResult {
    case success
    case failure
//    case recommended
//    case beforeExchange
}

final class InsightDetailViewModel {
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    func loadInsightDetail(id: String) -> Observable<InsightDetail?> {
        let parameters: [String: Any] = [
            "insightId": id
        ]
        
        let endpoint = Endpoint<InsightDetailResponse>(
            baseURL: .imdangAPI,
            path: "/insights/detail",
            method: .get,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { data in
                return data.toDetail()
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(nil)
            }
    }
    
    func recommendInsight(insightId: String) -> Observable<RecommendResult> {
        let parameters: [String: Any] = [
            "insightId": insightId,
            "recommendMemberId": UserdefaultKey.memberId
        ]
        
        let endpoint = Endpoint<EmptyResponse>(
            baseURL: .imdangAPI,
            path: "/insights/recommend",
            method: .post,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.requestOptional(with: endpoint)
            .map { _ in
                return .success
            }
            .catch { error in
                return Observable.just(.failure)
            }
    }
    
    func accueInsight(insightId: String) -> Observable<Bool> {
        let parameters: [String: Any] = [
            "insightId": insightId,
            "accuseMemberId": UserdefaultKey.memberId
        ]
        
        let endpoint = Endpoint<InsightIdResponse>(
            baseURL: .imdangAPI,
            path: "/insights/accuse",
            method: .post,
            headers: [.contentType("application/json"), .authorization(bearerToken: UserdefaultKey.accessToken)],
            parameters: parameters
        )
        
        return networkManager.request(with: endpoint)
            .map { _ in
                return true
            }
            .catch { error in
                print("Error: \(error.localizedDescription)")
                return Observable.just(false)
            }
    }
}


