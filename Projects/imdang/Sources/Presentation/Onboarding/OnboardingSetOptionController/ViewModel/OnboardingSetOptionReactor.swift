//
//  OnboardingSetOptionReactor.swift
//  imdang
//
//  Created by daye on 7/28/25.
//

import ReactorKit
import RxSwift

enum OnboardingType {
    case liveIn
    case gapInvestment
}

final class OnboardingSetOptionReactor: Reactor {

    enum Action {
        case optionSelected
        case goBack
        case goNextPage
        case completeNewView
        case skipNewView
        case spotSelected([String])
        case skipSpotSelection
        case prioritySelected(priority: Int, category: String, item: String)
        case setOnboardingType(OnboardingType)
    }
    
    enum Mutation {
        case goNextStep
        case goPreviousStep
        case setCurrentPage(OnboardingPage)
        case setSelectedPriority(priority: Int, category: String, item: String)
        case setSelectedSpots([String])
        case setOnboardingData(OnboardingType)
    }
    
    struct State {
        var onboardingType: OnboardingType = .liveIn
        var steps: [StepData] = []
        var currentStep: Int = 0
        var stepData: StepData
        var currentPage: OnboardingPage = .start
        var selectedSpots: [String] = []
        var selectedPriorities: [Int: (String, String)] = [:]
    }
    
    enum OnboardingPage {
        case start, step, priority, spot, done
    }

    let initialState: State
    
    private let liveInSteps: [StepData] = [
        StepData(title: "예산은 어느 정도 고려중이신가요?", subTitle: "현금+대출 총 예산을 선택해주세요", options: ["1억 이하", "3억 이하", "5억 이하", "7억 이하", "9억 이하", "15억 이하", "20억 이하", "30억 이하", "50억 이하"]),
        StepData(title: "월수입이 어느정도 되시나요?(세후)", subTitle: "맞벌이 부부라면 총합을 선택해주세요", options: ["수입 없음", "200만원 이하", "300만원 이하", "400만원 이하", "500만원 이하", "600만원 이하", "700만원 이하", "800만원 이하", "1,000만원 이하"]),
        StepData(title: "누구와 함께 살 집을 찾고 계신가요?", subTitle: "", options: ["신혼부부", "가족(3인 이상)", "중년부부", "혼자"]),
        StepData(title: "아이와 함께 살고 계신가요?", subTitle: "", options: ["자녀 계획 없음", "자녀 계획 있음", "1명", "2명", "3명"])
    ]
    
    private let gapInvestmentSteps: [StepData] = [
        StepData(title: "예산은 어느 정도 고려중이신가요?", subTitle: "현금+대출 총 예산을 선택해주세요", options: ["1억 이하", "3억 이하", "5억 이하", "7억 이하", "9억 이하", "15억 이하", "20억 이하", "30억 이하", "50억 이하"]),
        StepData(title: "월수입이 어느정도 되시나요?(세후)", subTitle: "맞벌이 부부라면 총합을 선택해주세요", options: ["수입 없음", "200만원 이하", "300만원 이하", "400만원 이하", "500만원 이하", "600만원 이하", "700만원 이하", "800만원 이하", "1,000만원 이하"]),
        StepData(title: "얼마 정도의 갭을 희망하시나요?", subTitle: "", options: ["갭 20% 이상", "갭 30% 이상", "갭 40% 이상", "갭 50% 이상", "갭 60% 이상", "상관 없어요"]),
        StepData(title: "얼마동안 투자하실 계획이신가요?", subTitle: "", options: ["1년 미만", "2년 미만", "3년 미만", "5년 미만", "10년 미만", "20년 미만", "아직 모르겠어요"])
    ]
    
    init() {
        let initialSteps = self.liveInSteps
        self.initialState = State(
            onboardingType: .liveIn,
            steps: initialSteps,
            currentStep: 0,
            stepData: initialSteps.first ?? StepData(title: "오류", subTitle: "", options: []),
            currentPage: .start
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .goNextPage:
            return .just(.setCurrentPage(.step))
            
        case .optionSelected:
            if currentState.currentStep < currentState.steps.count - 1 {
                return .just(.goNextStep)
            } else {
                return .just(.setCurrentPage(.priority))
            }
            
        case .completeNewView:
            return .just(.setCurrentPage(.spot))
            
        case .skipNewView:
            return .just(.setCurrentPage(.done))
            
        case .goBack:
            switch currentState.currentPage {
            case .start:
                return .empty()
            case .step:
                return currentState.currentStep > 0 ? .just(.goPreviousStep) : .just(.setCurrentPage(.start))
            case .priority:
                return .just(.setCurrentPage(.step))
            case .spot:
                return .just(.setCurrentPage(.priority))
            case .done:
                return .just(.setCurrentPage(.spot))
           
            }
        case let .prioritySelected(priority, category, item):
            return .just(.setSelectedPriority(priority: priority, category: category, item: item))
            
        case let .setOnboardingType(type):
            return .just(.setOnboardingData(type))
            
        case .spotSelected(let spots):
            return Observable.concat([
                .just(.setSelectedSpots(spots)),
                .just(.setCurrentPage(.done))
            ])
            
        case .skipSpotSelection:
              return  .just(.setCurrentPage(.done))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goNextStep:
            newState.currentStep += 1
            newState.stepData = newState.steps[newState.currentStep]
            
        case .goPreviousStep:
            newState.currentStep -= 1
            newState.stepData = newState.steps[newState.currentStep]
            
        case .setCurrentPage(let page):
            
            newState.currentPage = page
            
        case .setSelectedPriority(let priority, let category, let item):
            newState.selectedPriorities[priority] = (category, item)
            
        case .setOnboardingData(let type):
            newState.onboardingType = type
            let newSteps = (type == .liveIn) ? self.liveInSteps : self.gapInvestmentSteps
            newState.steps = newSteps
            newState.currentStep = 0
            newState.stepData = newSteps.first ?? StepData(title: "오류", subTitle: "", options: [])
            
        case let .setSelectedSpots(spots):
              newState.selectedSpots = spots
        }
        return newState
    }
}

struct StepData: Equatable {
    static func == (lhs: StepData, rhs: StepData) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    let subTitle: String
    let options: [String]
}
