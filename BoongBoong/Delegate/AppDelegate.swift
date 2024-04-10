//
//  AppDelegate.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/8/24.
//

import UIKit
import KakaoMapsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let apiKey = Bundle.main.nativeKey else {
            print("API 키를 로드하지 못했습니다.")
            return true
        }
        print(apiKey)
        SDKInitializer.InitSDK(appKey: apiKey)
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension Bundle {
    var nativeKey : String? {
        return infoDictionary?["NAT_KEY"] as? String
    }
    var restKey : String? {
        return infoDictionary?["REST_KEY"] as? String
    }
    var oilKey : String? {
        return infoDictionary?["OIL_KEY"] as? String
    }
    var parkingKey : String? {
        return infoDictionary?["PARK_KEY"] as? String
    }
    
}

