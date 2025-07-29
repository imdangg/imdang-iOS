
import ReactorKit
import RxSwift

final class OnboardingSetOptionReactor: Reactor {

    enum Action {
        case optionSelected
        case goBack
        case completeNewView
    }

    enum Mutation {
        case goNextStep
        case goPreviousStep
        case setCurrentPage(OnboardingPage)
    }
    
    struct State {
        var currentStep: Int = 0
        var stepData: StepData
        var currentPage: OnboardingPage = .step
    }
    
    enum OnboardingPage {
        case step
        case new
        case done
    }

    let initialState: State
    //TODO: 옵셔널 처리해서 분기 나누도록 변경
    private let steps: [StepData] = [
        StepData(title: "예산은 어느 정도 고려중이신가요?", subTitle: "현금+대출 총 예산을 선택해주세요", options: ["1억 이하", "3억 이하", "5억 이하", "7억 이하", "9억 이하", "15억 이하", "20억 이하", "30억 이하", "50억 이하"]),
        StepData(title: "월수입이 어느정도 되시나요?(세후)", subTitle: "맞벌이 부부라면 총합을 선택해주세요", options: ["수입 없음", "200만원 이하", "300만원 이하", "400만원 이하", "500만원 이하", "600만원 이하", "700만원 이하", "800만원 이하", "1,000만원 이하"]),
        StepData(title: "누구와 함께 살 집을 찾고 계신가요?", subTitle: "", options: ["신혼부부", "가족(3인 이상)", "중년부부", "혼자"]),
        StepData(title: "아이와 함께 살고 계신가요?", subTitle: "", options: ["자녀 계획 없음", "자녀 계획 있음", "1명", "2명", "3명"])
    ]

    init() {
        self.initialState = State(currentStep: 0, stepData: steps[0], currentPage: .step)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .optionSelected:
            if currentState.currentStep < steps.count - 1 {
                return .just(.goNextStep)
            } else {
                return .just(.setCurrentPage(.new))
            }
            
        case .completeNewView:
            return .just(.setCurrentPage(.done))
            
        case .goBack:
            switch currentState.currentPage {
            case .step:
                return currentState.currentStep > 0 ? .just(.goPreviousStep) : .empty()
            case .new:
                return .just(.setCurrentPage(.step))
            case .done:
                return .just(.setCurrentPage(.new))
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goNextStep:
            newState.currentStep += 1
            newState.stepData = steps[newState.currentStep]
        case .goPreviousStep:
            newState.currentStep -= 1
            newState.stepData = steps[newState.currentStep]
        case .setCurrentPage(let page):
            newState.currentPage = page
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
