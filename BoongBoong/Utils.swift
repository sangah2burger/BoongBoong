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
    func searchXYWithAddressName(query: String, size: Int = 10, page: Int = 1, restKey: String, completion: @escaping (RegionDocument) -> Void) {
        let endPoint = "https://dapi.kakao.com/v2/local/search/address"
        let params: Parameters = ["query" : query, "size" : size, "page": page]
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(restKey)"]
        
        AF.request(endPoint, method: .get, parameters: params, headers: headers).responseDecodable(of: RegionPointModel.self, completionHandler: { response in
            switch response.result {
            case .success(let result):
                guard let doc = result.regionDocuments.first else { return }
                completion(doc)
            case .failure(let error):
                print("실패 : \(error.localizedDescription)")
            }
        })
    }
    
    func searchOilBankWithXY(katecX: Double = 299017.76990, katecY: Double = 550893.57210, radius:Int = 1000, oilKey: String, prodcd:String = "B027", completion: @escaping ([RangeOilBank]) -> Void) {
        let endPoint = "http://www.opinet.co.kr/api/aroundAll.do"
        let params : Parameters = ["code" : "\(oilKey)", "out":"json", "x" : katecX, "y" : katecY, "radius" : 1000, "prodcd" : "B027", "sort" : 2]
        AF.request(endPoint, method: .get, parameters: params).responseDecodable(of: RangeOilBankModel.self) { response in
            switch response.result {
            case .success(let result) :
                completion(result.rangeOilBankResult.rangeOilBank)
            case .failure(let error) :
                print("실패 : \(error.localizedDescription)")
            }
        }
    }
    
    func searchOilAvgPrice(oilKey:String) {
        let endPoint = "http://www.opinet.co.kr/api/avgAllPrice.do"
        let params : Parameters = ["code" : "\(oilKey)", "out" : "json"]
        AF.request(endPoint, method: .get, parameters: params).responseDecodable(of: OilAvgPriceModel.self) { response in
            switch response.result {
            case .success(let result) :
                oilAvgPrice = result
                //guard let oilAvgPrice = oilAvgPrice else { return }
            case .failure(let error) :
                print("실패 : \(error.localizedDescription)")
                
            }
        }
    }
    
    func searchOilBankInfo(uniId:String, oilKey:String) {
        let endPoint = "http://www.opinet.co.kr/api/detailById.do"
        let params : Parameters = ["code":"\(oilKey)", "out":"json","id":uniId ]
        AF.request(endPoint, method: .get, parameters: params).responseDecodable(of: InfoOilBankModel.self) { response in
            switch response.result {
            case .success(let result) :
                infoOilBank = result
                //guard let infoOilBank = infoOilBank else { return }
            case .failure(let error) :
                print("실패 : \(error.localizedDescription)")
            }
        }
    }
    func convertCoordinateBySystem(x:Double, y:Double, inputCoord:String, ouputCoord:String, restKey:String, completion: @escaping (Document) -> Void){
            let endPoint = "https://dapi.kakao.com/v2/local/geo/transcoord"
            let params: Parameters = ["x": x,"y": y, "input_coord" : inputCoord, "output_coord": ouputCoord]
            let headers: HTTPHeaders = ["Authorization":"KakaoAK \(restKey)"]
            AF.request(endPoint, method: .get, parameters: params, headers: headers).responseDecodable(of: CoordModel.self) { response in
                switch response.result {
                case .success(let result) :
                    coord = result
                    guard let doc = coord?.documents.first else {return}
                    print("위도 : \(x) -> \(doc.x)\n경도 : \(y)) -> \(doc.y)")
                    completion(doc)
                case .failure(let error) :
                    print("에러 발생 : \(error.localizedDescription)")
                }
            }
        }

}

