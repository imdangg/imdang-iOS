 //
//  Insight.swift
//  SharedLibraries
//
//  Created by 임대진 on 11/26/24.
//

import UIKit

struct Insight: Equatable {
    let id: String
    let titleName: String
    let titleImageUrl: String
    let userName: String
    let profileImageUrl: String
    let adress: String
    let likeCount: Int
    let state: DetailExchangeState
    
    static var testImage = "https://img1.newsis.com/2023/07/12/NISI20230712_0001313626_web.jpg"
    static var myInsight: [Insight] = [Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .beforeRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .afterRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .waiting),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .done)]
    static var todayInsight: [Insight] = [Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .beforeRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .afterRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .waiting),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .done)]
    static var topInsight: [Insight] = [Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .beforeRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .afterRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .waiting),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .done),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .beforeRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .afterRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .waiting),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .done),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .beforeRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .afterRequest),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .waiting),Insight(id: "0", titleName: "초역세권 대단지 아파트 후기", titleImageUrl: testImage, userName: "홍길동", profileImageUrl: "", adress: "강남구 신논현동", likeCount: 20, state: .done)]
    
}
