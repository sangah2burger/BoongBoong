//
//  MapPointViewSample.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/10/24.
//

import UIKit
import KakaoMapsSDK
import CoreLocation

class MapPointViewSample : BaseViewController {
    
    
    override func addViews() {
        let defaultPosition : MapPoint = MapPoint(longitude: 127.108678, latitude : 37.402001)
        let mapviewInfo : MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 14)
        
        mapController?.addView(mapviewInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

            let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
            // PoiBadge를 생성하여 POI에 추가한다.
            let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "noti.png")!, offset: CGPoint(x: 0.1, y: 0.1), zOrder: 1)
            poi1?.addBadge(badge)
            poi1?.show()
            poi1?.showBadge(badgeID: "noti")
            
        }
}
