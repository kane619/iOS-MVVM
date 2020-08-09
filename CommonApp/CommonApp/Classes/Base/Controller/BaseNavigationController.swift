//
//  BaseNavigationController.swift
//  Lan8Tax
//
//  Created by apple on 2020/7/23.
//  Copyright © 2020 aaronlee. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarAppearence()
    }
    
    func setupNavBarAppearence() {
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.shadowImage = UIImage()
    }
}

extension BaseNavigationController{
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
