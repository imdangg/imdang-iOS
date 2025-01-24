//
//  ExchangeViewReactor.swift
//  imdang
//
//  Created by daye on 12/5/24.
//

import Foundation
import ReactorKit

final class ExchangeReactor: Reactor {
    
    struct State {
        var insights: [Insight] = []
        var selectedExchangeState: ExchangeState
        var selectedRequestState: ExchangeRequestState
    }
    
    enum Action {
        case tapExchangeStateButton(ExchangeState)
        case selectedRequestSegmentControl(ExchangeRequestState)
        case loadInsights
    }
    
    enum Mutation {
        case changeSelectedExchangeState(ExchangeState)
        case changeSelectedRequestState(ExchangeRequestState)
        case setInsights([Insight])
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(selectedExchangeState: .waiting, selectedRequestState: .request)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadInsights:
            let insights = (1...20).map { index in
                Insight(
                    id: "index",
                    titleName: "Insight \(index)",
                    titleImageUrl: "https://img1.newsis.com/2023/07/12/NISI20230712_0001313626_web.jpg",
                    userName: "User \(index)",
                    profileImageUrl: "",
                    adress: "Seoul",
                    likeCount: index * 5, state: .beforeRequest
                )
            }
            return Observable.just(.setInsights(insights))
        case .tapExchangeStateButton(let exchangeState):
            return Observable.just(.changeSelectedExchangeState(exchangeState))
            case .selectedRequestSegmentControl(let requestState):
                return Observable.just(.changeSelectedRequestState(requestState))
            }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .changeSelectedExchangeState(let exchangeState):
            state.selectedExchangeState = exchangeState
            print("\(exchangeState)")
        case .changeSelectedRequestState(let requestState):
            state.selectedRequestState = requestState
            print("\(requestState)")
        case let .setInsights(insights):
            state.insights = insights
        }
        return state
    }
}
