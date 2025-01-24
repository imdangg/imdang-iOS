//
//  InsightWriteService.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/17/25.
//

import UIKit
import NetworkKit
import RxSwift
import Alamofire

final class InsightWriteService {
    static let shared = InsightWriteService()
    
    private var disposeBag = DisposeBag()
    private let networkManager = NetworkManager()

    func createInsight(dto: InsightDTO, image: UIImage) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let url = "http://imdang.info/insights/create"
            
            guard let jsonData = try? JSONEncoder().encode(dto) else {
                return Disposables.create()
            }
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserdefaultKey.accessToken)"
            ]
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(jsonData, withName: "createInsightCommand", mimeType: "application/json")
                
                if let imageData = image.jpegData(compressionQuality: 0.2) {
                    multipartFormData.append(imageData, withName: "mainImage", fileName: "image.jpg", mimeType: "image/jpeg")
                }
                
            }, to: url, method: .post, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        print("Upload successful: \(String(data: data, encoding: .utf8) ?? "")")
                        observer.onNext(true)
                    } else {
                        print("Upload successful but no data received.")
                        observer.onNext(true)
                    }
                case .failure(let error):
                    print("Upload error: \(error)")
                    observer.onNext(false)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    let dtoTest = InsightDTO(
        memberId: UserdefaultKey.memberId,
        score: 0,
        title: "제목제목",
        address: InsightDTO.Address(
            siDo: "서울",
            siGunGu: "강남구",
            eupMyeonDong: "대치동",
            roadName: "",
            buildingNumber: "1025",
            detail: "string",
            latitude: 0,
            longitude: 0
        ),
        apartmentComplex: InsightDTO.ApartmentComplex(name: "롯데캐슬리베아파트"),
        visitAt: "2022-12-11",
        visitTimes: ["아침"],
        visitMethods: ["자차"],
        summary: "stringstringstringstringstring",
        access: "제한됨",
        infra: InsightDTO.Infra(
            transportations: ["해당_없음"],
            schoolDistricts: ["해당_없음"],
            amenities: ["해당_없음"],
            facilities: ["해당_없음"],
            surroundings: ["해당_없음"],
            landmarks: ["해당_없음"],
            unpleasantFacilities: ["해당_없음"],
            text: "string"
        ),
        complexEnvironment: InsightDTO.ComplexEnvironment(
            buildingCondition: "잘_모르겠어요",
            security: "잘_모르겠어요",
            childrenFacility: "잘_모르겠어요",
            seniorFacility: "잘_모르겠어요",
            text: "string"
        ),
        complexFacility: InsightDTO.ComplexFacility(
            familyFacilities: ["해당_없음"],
            multipurposeFacilities: ["해당_없음"],
            leisureFacilities: ["해당_없음"],
            surroundings: ["해당_없음"],
            text: "string"
        ),
        favorableNews: InsightDTO.FavorableNews(
            transportations: ["잘_모르겠어요"],
            developments: ["잘_모르겠어요"],
            educations: ["잘_모르겠어요"],
            environments: ["잘_모르겠어요"],
            cultures: ["잘_모르겠어요"],
            industries: ["잘_모르겠어요"],
            policies: ["잘_모르겠어요"],
            text: "string"
        )
    )
}


