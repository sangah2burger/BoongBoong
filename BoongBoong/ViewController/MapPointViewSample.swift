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
        showBasicGUIs()
        createSpriteGUI()
        createInfoWindow()
        
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
    
    func showBasicGUIs() {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.setCompassPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .left), position: CGPoint(x: 10.0, y: 10.0))
        view.showCompass()
        view.setScaleBarPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .right), position: CGPoint(x: 10.0, y: 10.0))
        view.showScaleBar()
        view.setScaleBarFadeInOutOption(FadeInOutOptions(fadeInTime: 1000, fadeOutTime: 1000, retentionTime: 5000))
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

extension MapPointViewSample : GuiEventDelegate {
    func createSpriteGUI() {
        let mapView = mapController?.getView("mapview") as! KakaoMap
        let spriteLayer = mapView.getGuiManager().spriteGuiLayer
        let spriteGui = SpriteGui("testSprite") //SpriteGui를 만듬. SpriteGui는 화면좌표상의 특정지점에 고정되는 GUI이다. 구성방법은 InfoWindow와 동일하다.
        
        spriteGui.arrangement = .horizontal
        spriteGui.bgColor = UIColor.clear
        spriteGui.splitLineColor = UIColor.white
        spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right) //화면의 우하단으로 배치
        
        
        let button = GuiButton("button1")
        button.image = UIImage(named: "track_location_btn.png")
        
        spriteGui.addChild(button)
        
        spriteLayer.addSpriteGui(spriteGui)
        spriteGui.delegate = self
        spriteGui.show()
    }

    func createInfoWindow() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let infoWindow = InfoWindow("infoWindow");
        
        // bodyImage
        let bodyImage = GuiImage("bgImage")
        bodyImage.image = UIImage(named: "white_black_round10.png")
        bodyImage.imageStretch = GuiEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        
        // tailImage
        let tailImage = GuiImage("tailImage")
        tailImage.image = UIImage(named: "white_black.png")
        
        //bodyImage의 child로 들어갈 layout.
        let layout: GuiLayout = GuiLayout("layout")
        layout.arrangement = .horizontal    //가로배치
        let button1: GuiButton = GuiButton("button1")
        button1.image = UIImage(named: "noti.png")!
        
        let text = GuiText("text")
        let style = TextStyle(fontSize: 20)
        text.addText(text: "안녕하세요~", style: style)
        //Text의 정렬. Layout의 크기는 child component들의 크기를 모두 합친 크기가 되는데, Layout상의 배치에 따라 공간의 여분이 있는 component는 align을 지정할 수 있다.
        text.align = GuiAlignment(vAlign: .middle, hAlign: .left)   // 좌중단 정렬.
        
        bodyImage.child = layout
        infoWindow.body = bodyImage
        infoWindow.tail = tailImage
        infoWindow.bodyOffset.y = -10
        
        layout.addChild(button1)
        layout.addChild(text)
        
        infoWindow.position = MapPoint(longitude: 127.108678, latitude: 37.402001)
        infoWindow.delegate = self
        
        let infoWindowLayer = view.getGuiManager().infoWindowLayer
        infoWindowLayer.addInfoWindow(infoWindow)
        infoWindow.show()
    }
    
    func guiDidTapped(_ gui: KakaoMapsSDK.GuiBase, componentName: String) {
        print("Gui: \(gui.name), Component: \(componentName) tapped")
        // GuiButton만 tap 이벤트가 발생할 수 있다.
        let guitext = gui.getChild("text") as? GuiText
        if let style = guitext?.textStyle(index: 0) {
            let newStyle = TextStyle(fontSize: style.fontSize, fontColor: UIColor.red, strokeThickness: style.strokeThickness, strokeColor: style.strokeColor)
            guitext?.updateText(index: 0, text: "Button pressed", style: newStyle)
            gui.updateGui() //Gui를 갱신한다
        }
        if componentName == "button" {
            //do something
            
        }
        
    }
    
}


