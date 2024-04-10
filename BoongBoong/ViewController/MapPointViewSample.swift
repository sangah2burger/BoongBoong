//
//  MapPointViewSample.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/10/24.
//

import UIKit
import KakaoMapsSDK
import CoreLocation
import Alamofire


class MapPointViewSample : BaseViewController {
    
    var regionPoint : RegionPointModel?
    let restKey = Bundle.main.restKey!
    
    override func addViews() {
        let defaultPosition : MapPoint = MapPoint(longitude: 127.108678, latitude : 37.402001)
        let mapviewInfo : MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 10)
        
        mapController?.addView(mapviewInfo)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        search(query: "학동")
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createLabelLayer()
        createPoiStyle()
        createPois()
    }
    
    func createLabelLayer() {
            let view = mapController?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
            let _ = manager.addLabelLayer(option: layerOption)
        }

    func createPoiStyle() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let iconStyle = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)
    }
    
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1")
        poiOption.rank = 0
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127, latitude: 37))
        // PoiBadge를 생성하여 POI에 추가한다.
        let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "noti.png")!, offset: CGPoint(x: 0.1, y: 0.1), zOrder: 1)
        poi1?.addBadge(badge)
        poi1?.show()
        poi1?.showBadge(badgeID: "noti")
        guard let longtitude = super.manager.location?.coordinate.longitude,
              let latitude = super.manager.location?.coordinate.latitude else { return }
        let mapPoint = MapPoint(longitude: longtitude, latitude: latitude)
        poi1?.moveAt(mapPoint, duration: 5000)
        
    }
    
    func search(query: String, size: Int = 10, page: Int = 1) {
        let endPoint = "https://dapi.kakao.com/v2/local/search/address"
        let params: Parameters = ["query" : query, "size" : size, "page": page]
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(restKey)"]
        
        AF.request(endPoint, method: .get, parameters: params, headers: headers).responseDecodable(of: RegionPointModel.self, completionHandler: { response in
            print(response)
            switch response.result {
            case .success(let result):
                self.regionPoint = result
                guard let po = self.regionPoint else { return }
                print(po)
            case .failure(let error):
                print("실패 : \(error.localizedDescription)")
            }
        })
    }
    
}

