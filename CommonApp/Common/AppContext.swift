//
//  AppContext.swift
//  Mall
//
//  Created by AaronLee0619 on 2019/10/25.
//  Copyright © 2019 budian. All rights reserved.
//

import UIKit
private let TOKEN = "TOKEN"
private let REFRESHTOKEN = "REFRESHTOKEN"
private let USERINFO = "USERINFO"
private let ENTERPRISEINFO = "ENTERPRISEINFO"
private let USERBASICINFO = "USERBASICINFO"
private let ACCESSTOKEN = "ACCESSTOKEN"
class AppContext:  NSObject{
//    private var _userInfo: UserInfo?
//    var userInfo:UserInfo? {
//        set{
//            let ud = UserDefaults.standard
//            _userInfo = newValue
//            DispatchQueue.global(qos: .userInitiated).async {
//                if newValue == nil {
//                    ud.removeObject(forKey: USERINFO)
//                }else{
//                    let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
//                    ud.set(data, forKey: USERINFO)
//                    ud.synchronize()
//                }
//            }
//        }
//        get{
//            let ud = UserDefaults.standard
//            let data = ud.object(forKey: USERINFO)
//            if (data != nil){
//                return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? UserInfo
//            }else{
//                return nil
//            }
//        }
//    }
//
    private var _token: String?
    var token : String?{
        set{
            let ud = UserDefaults.standard
            _token = newValue
            DispatchQueue.global(qos: .background).async {
                if newValue == nil{
                    ud.removeObject(forKey: TOKEN)
                }else{
                    let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                    ud.set(data, forKey: TOKEN)
                    ud.synchronize()
                }
            }
        }
        get{
            let ud = UserDefaults.standard
            let data = ud.object(forKey: TOKEN)
            if (data != nil){
                return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? String
            }else{
                return nil
            }
        }
    }
    private var _refreshToken: String?
    var refreshToken:String?{
        set{
            let ud = UserDefaults.standard
            _refreshToken = newValue
            DispatchQueue.global(qos: .background).async {
                if newValue == nil{
                    ud.removeObject(forKey: REFRESHTOKEN)
                }else{
                    let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                    ud.set(data, forKey: REFRESHTOKEN)
                    ud.synchronize()
                }
            }
        }
        get{
            let ud = UserDefaults.standard
            let data = ud.object(forKey: REFRESHTOKEN)
            if data != nil {
                return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? String
            }else{
                return nil
            }
        }
    }
    private var _accessToken:String?
    var accessToken:String?{
        set{
            let ud = UserDefaults.standard
            _accessToken = newValue
            DispatchQueue.global(qos: .background).async {
                if newValue == nil{
                    ud.removeObject(forKey: ACCESSTOKEN)
                }else{
                    let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                    ud.set(data, forKey: ACCESSTOKEN)
                    ud.synchronize()
                }
            }
        }
        get{
            let ud = UserDefaults.standard
            let data = ud.object(forKey: ACCESSTOKEN)
            if data != nil {
                return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? String
            }else{
                return nil
            }
        }
    }
    //单例
    static let defaultAppContext = AppContext()

}
