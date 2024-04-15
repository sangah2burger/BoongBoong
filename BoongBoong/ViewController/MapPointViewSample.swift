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


var regionPoint : RegionPointModel?
var rangeOilBank : RangeOilBankModel?
var oilAvgPrice : OilAvgPriceModel?
var infoOilBank : [InfoOilBankList] = []
var coord: CoordModel?


class MapPointViewSample : BaseViewController {
    let restKey = Bundle.main.restKey!
    let oilKey = Bundle.main.oilKey!
    var locationManager: CLLocationManager?
    
    override func addViews() {
        let defaultPosition : MapPoint = MapPoint(longitude: 126.8461, latitude : 37.5358)
        let mapviewInfo : MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
        
        mapController?.addView(mapviewInfo)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//        manager.allowsBackgroundLocationUpdates = true
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        //locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        
        
//        searchXYWithAddressName(query: "학동", restKey: restKey)
//        searchOilBankWithXY(oilKey: oilKey, prodcd: "B027")
//        dump(rangeOilBank?.rangeOilBankResult.rangeOilBank[0])
//        searchOilAvgPrice(oilKey: oilKey)
//        convertCoordinateBySystem(x:299017.76990 , y: 550893.57210, inputCoord: "KTM", ouputCoord: "WGS84", restKey: restKey)
        searchOilBankBoundary()
    }
    
    override func viewInit(viewName: String) {
        print("OK")
        createLabelLayer()
        createPoiStyle()
        //createCurrentPoiStyle()
        
        createPois()
        //createCurrentPois()
        
        showBasicGUIs()
        createSpriteGUI()
        createInfoWindow()
        locationManager?.startUpdatingLocation()
        
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
        let iconStyle = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
        let poiStyle = PoiStyle(styleID: "customStyle1", styles: [perLevelStyle])
        manager.addPoiStyle(poiStyle)
        view.poiScale = .small
    }
    
    func createPois() {
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let poiOption = PoiOptions(styleID: "customStyle1",poiID: "poi1")
        poiOption.rank = 0
        
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 127, latitude: 37))
        // PoiBadge를 생성하여 POI에 추가한다.
        let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "noti.png")!, offset: CGPoint(x: 0.1, y: 0.1), zOrder: 1)
        poi1?.addBadge(badge)
        poi1?.show()
        poi1?.showBadge(badgeID: "noti")
        poi1?.moveAt(MapPoint(longitude: 127, latitude: 38), duration: 5000)
    }
    
//    func createCurrentPoiStyle() {
//        let view = mapController?.getView("mapview") as! KakaoMap
//        let manager = view.getLabelManager()
//        let iconStyle = PoiIconStyle(symbol: UIImage(named: "pin_green.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
//        let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
//        let poiStyle = PoiStyle(styleID: "customStyle2", styles: [perLevelStyle])
//        manager.addPoiStyle(poiStyle)
//    }
//    
//    func createCurrentPois() {
//        let view = mapController?.getView("mapview") as! KakaoMap
//        let manager = view.getLabelManager()
//        let layer = manager.getLabelLayer(layerID: "PoiLayer")
//        let poiOption = PoiOptions(styleID: "customStyle2",poiID: "poi1")
//        poiOption.rank = 0
//        
//        guard let currentX = CLLocationManager().location?.coordinate.longitude,
//              let currentY = CLLocationManager().location?.coordinate.latitude else { return }
//        
//        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: currentX, latitude: currentY))
//        // PoiBadge를 생성하여 POI에 추가한다.
//        let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "noti.png")!, offset: CGPoint(x: 0.1, y: 0.1), zOrder: 1)
//        poi1?.addBadge(badge)
//        poi1?.show()
//        poi1?.showBadge(badgeID: "noti")
//
//    }
    
    func showBasicGUIs() {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.setCompassPosition(origin: GuiAlignment(vAlign: .bottom, hAlign: .left), position: CGPoint(x: 10.0, y: 30.0))
        view.showCompass()
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
        spriteGui.position = CGPoint(x: 50, y: 50)
        
        
        let button = GuiButton("currentLocation")
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
        let button1: GuiButton = GuiButton("currentLocation")
        button1.image = UIImage(named: "noti.png")!
        
        let text = GuiText("text")
        let style = TextStyle(fontSize: 20)
        text.addText(text: "안녕하세용", style: style)
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
            
        } else if componentName == "currentLocation" {
            moveCameraToCurrentLocation()
            showModal()
        }
    }
    
    func showModal() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let modalViewController = storyboard.instantiateViewController(withIdentifier: "modal") as? ModalViewController else { return }

        print(modalViewController)
        
        modalViewController.view.backgroundColor = .white
        modalViewController.modalPresentationStyle = .formSheet
        
        
        if let sheetController = modalViewController.sheetPresentationController { //모달 스타일 설정
            sheetController.detents = [.large(), .medium()]
            sheetController.preferredCornerRadius = 12
            sheetController.prefersGrabberVisible = true
        }
        present(modalViewController, animated: true, completion: nil)
    }
    
    
    func searchOilBankBoundary() {
        searchXYWithAddressName(query: "화곡동", size: 10, page: 1, restKey: restKey) { [unowned self] doc in
            guard let x = Double(doc.x), let y = Double(doc.y) else { return }
            convertCoordinateBySystem(x: x, y: y, inputCoord: "WGS84", ouputCoord: "KTM", restKey: self.restKey) { [unowned self] doc in
                searchOilBankWithXY(katecX: doc.x, katecY: doc.y, radius: 1000, oilKey: self.oilKey) { [unowned self] oilBanks in
                    let view = self.mapController?.getView("mapview") as! KakaoMap
                    let manager = view.getLabelManager()
                    let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10001)
                    let _ = manager.addLabelLayer(option: layerOption)
                    
                    let iconStyle = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5))
                    let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
                    let poiStyle = PoiStyle(styleID: "customStyle3", styles: [perLevelStyle])
                    manager.addPoiStyle(poiStyle)
                    
                    let layer = manager.getLabelLayer(layerID: "PoiLayer")
                    let poiOption = PoiOptions(styleID: "customStyle3")
                    poiOption.rank = 0

                    for oilBank in oilBanks {
                        convertCoordinateBySystem(x: oilBank.gisXCoor, y: oilBank.gisYCoor, inputCoord: "KTM", ouputCoord: "WGS84", restKey: self.restKey) { doc in
                            searchOilBankInfo(uniId: oilBank.uniID, oilKey: self.oilKey)
                            
                            print(doc.x, doc.y)
                            guard let layer else { return }
                            let poi1 = layer.addPoi(option: poiOption, at: MapPoint(longitude: doc.x, latitude: doc.y))
                            guard let poi1 else { return }
                            poi1.show()
                            //poi1?.addPoiTappedEventHandler(target: <#T##U#>, handler: <#T##(U) -> (PoiInteractionEventParam) -> Void#>)
                        }
                    }
                }
            }
        }
    }
    
    
    func moveCameraToCurrentLocation () {
        guard let currentLoc = locationManager?.location?.coordinate else { return }
        let view = mapController?.getView("mapview") as! KakaoMap
        let cameraUpdate = CameraUpdate.make(target: MapPoint(longitude: currentLoc.longitude, latitude: currentLoc.latitude),  zoomLevel: 15 ,  mapView: view)
        view.animateCamera(cameraUpdate: cameraUpdate, options: CameraAnimationOptions(autoElevation: false, consecutive: true, durationInMillis: 300))
    }
}


extension MapPointViewSample : CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0])
        guard let location = locations.last else { return }
        let view = mapController?.getView("mapview") as! KakaoMap
        let manager = view.getLabelManager()
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        let currentPOI = layer?.getPoi(poiID: "poi1")
        print("바뀜")
        currentPOI?.moveAt(MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude), duration: 300)

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("error\(error.localizedDescription)")
    }
}
