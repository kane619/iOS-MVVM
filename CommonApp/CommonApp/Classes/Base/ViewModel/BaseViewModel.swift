//
//  BaseViewModel.swift
//  CommonApp
//
//  Created by apple on 2020/8/9.
//  Copyright © 2020 aaronlee. All rights reserved.
//

import UIKit

class BaseViewModel: NSObject {
    //Mark: -数据源更新
    typealias AddDataBlock = () ->Void
    var updateDataBlock:AddDataBlock?
}
extension BaseViewModel{
    func refreshDataSource() {
        
        self.updateDataBlock?()
    }
}
