//
//  ContainerViewController.swift
//  BoongBoong
//
//  Created by 상아이버거 on 4/10/24.
//

import UIKit


class ViewController: UIViewController {

    var _sampleToLoad = ""
    
    var sampleToLoad: String {
        get {
            return _sampleToLoad
        }
        
        set {
            _sampleToLoad = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = _sampleToLoad
        
        let childViewController = self.storyboard!.instantiateViewController(identifier: _sampleToLoad)
        self.addChild(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        
        self.navigationController?.hidesBarsOnSwipe = false
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let vc = self.navigationController {
            if vc.isMovingFromParent {
                self.removeChildren()
            }
        }
    }
    
}


extension UIViewController {

    func removeChildren() {
        self.children.forEach {
            $0.remove()
        }
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
