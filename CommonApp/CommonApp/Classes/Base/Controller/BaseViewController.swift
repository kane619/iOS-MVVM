//
//  BaseViewController.swift
//  Lan8Tax
//
//  Created by apple on 2020/7/23.
//  Copyright © 2020 aaronlee. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initBackButton() {   //返回按钮
        let backImage = UtilTools.imageWithImageName(name: "btn_back")
        let backItem = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(backBtnClick))
        self.navigationItem.leftBarButtonItem = backItem
        self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as UIGestureRecognizerDelegate)
    }

    @objc func backBtnClick() {
        
    }

}
