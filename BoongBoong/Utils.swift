//
//  Utils.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/12/24.
//

import Foundation
import Alamofire
import UIKit

extension UIViewController {
    func search(query: String, size: Int = 10, page: Int = 1, restKey: String) {
        let endPoint = "https://dapi.kakao.com/v2/local/search/address"
        let params: Parameters = ["query" : query, "size" : size, "page": page]
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(restKey)"]
        
        AF.request(endPoint, method: .get, parameters: params, headers: headers).responseDecodable(of: RegionPointModel.self, completionHandler: { response in
            switch response.result {
            case .success(let result):
                regionPoint = result
                guard let po = regionPoint else { return }
            case .failure(let error):
                print("실패 : \(error.localizedDescription)")
            }
        })
    }
    
    func searchOilbank(katecX: Double = 299017.76990, katecY: Double = 550893.57210, oilKey: String, prodcd:String) {
        let endPoint = "http://www.opinet.co.kr/api/aroundAll.do"
        let params : Parameters = ["code" : "\(oilKey)", "out":"json", "x" : katecX, "y" : katecY, "radius" : 1000, "prodcd" : "B027", "sort" : 2]
        AF.request(endPoint, method: .get, parameters: params).responseDecodable(of: RangeOilBankModel.self) { response in
            switch response.result {
            case .success(let result) :
                rangeOilBank = result
                guard let oilBank = rangeOilBank else { return }
            case .failure(let error) :
                print("실패 : \(error.localizedDescription)")
            }
        }
    }
    
    func searchOilAvgPrice(oilKey:String) {
        let endPoint = "http://www.opinet.co.kr/api/avgAllPrice.do"
        let params : Parameters = ["code" : "\(oilKey)", "out" : "json"]
        AF.request(endPoint, method: .get, parameters: params).responseDecodable(of: OilAvgPriceModel.self) { response in
            print(response)
            switch response.result {
            case .success(let result) :
                oilAvgPrice = result
                guard let oilAvgPrice = oilAvgPrice else { return }
                print(oilAvgPrice.oilAvgresult.oilPrice.self)
            case .failure(let error) :
                print("실패 : \(error.localizedDescription)")
                
            }
        }
    }
    
    func searchOilBankInfo(uniId:String, oilKey:String) {
        let endPoint = "http://www.opinet.co.kr/api/detailById.do"
        let params : Parameters = ["code":"\(oilKey)", "out":"json","id":uniId ]
        AF.request(endPoint, method: .get, parameters: params).responseDecodable(of: InfoOilBankModel.self) { response in
            print(response)
            switch response.result {
            case .success(let result) :
                infoOilBank = result
                guard let infoOilBank = infoOilBank else { return }
                print(infoOilBank.infoOilBankResult.infoOilBank.self)
            case .failure(let error) :
                print("실패 : \(error.localizedDescription)")
            }
        }
    }
}

