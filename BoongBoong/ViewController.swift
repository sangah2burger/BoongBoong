//
//  ViewController.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/8/24.
//

import UIKit
import TMapSDK
import CoreLocation
import Kingfisher
import Alamofire


class ViewController: UIViewController,TMapViewDelegate {
    var mapView : TMapView?
    
    @IBOutlet weak var mapContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView = TMapView(frame: mapContainerView.frame)
        self.mapView?.delegate = self
        guard let apiKey = Bundle.main.apiKey else {
            print("API키를 로드하지 못했습니다.")
            return
        }
        self.mapView?.setApiKey(apiKey)
        mapContainerView.addSubview(mapView!)
        print("성공..")
    }


}

extension Bundle {
    var apiKey : String? {
        return infoDictionary?["API_KEY"] as? String
    }
}
