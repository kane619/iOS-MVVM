//
//  CloudAPI.swift
//  Lan8Tax
//
//  Created by apple on 2020/7/23.
//  Copyright © 2020 aaronlee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let TIMEOUT = 30.0
private let baseUrl = "http://121.196.189.28:8080"      //线上环境
let h5HostUrl = "http://test.lan8.cn/flexible_worker/#/"

private let tokenRefreshUrl = "/freeemployment/api/tokenRefresh" //Token刷新

protocol NetworkToolDelegate {
    
}

struct CloudAPI: NetworkToolDelegate {
    
    // Get 请求
    static func makeCommonGetRequest(baseUrl : String,parameters : [String: Any],successHandler: @escaping(_ json:JSON) ->(),errorMsgHandler : @escaping(_ errorMsg : String) ->()){

        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
             // 网络连接或者服务错误的提示信息
             guard response.result.isSuccess else
             {
                 Utility.showToastView(response.error!.localizedDescription)
                 return errorMsgHandler("")
             }
             if let value = response.result.value {
                let json = JSON(value)
                guard json["code"].intValue == 0 else {
                     if Utility.isValidString(json["message"].stringValue) {
                         Utility.showToastView(json["message"].stringValue)
                     }
                     errorMsgHandler(json["message"].stringValue)
                     return
                }
                successHandler(json["data"])
            }
        }
        
    }
    //POST
    static func makePostRequest(baseUrl : String,parameters : [String: Any],successHandler: @escaping(_ json:JSON) ->(),errorMsgHandler : @escaping(_ errorMsg : String) ->()){
        let headers:HTTPHeaders = [
            "Accept":"application/json"
        ]
        Alamofire.request(baseUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard response.result.isSuccess else{
                return errorMsgHandler(response.error!.localizedDescription)
            }
            if let value = response.result.value {
                let json = JSON(value)
                successHandler(json)
            }
        }
    }
    //POST jsonbody
    static func makePostBodyRequest(baseUrl : String,parameters : [String: Any],HUDText:String, successHandler: @escaping(_ json:JSON) ->(),errorMsgHandler : @escaping(_ errorMsg : String) ->()){   // 提交jsonbody
          var postRequest = URLRequest(url: URL(string: baseUrl)!)
          postRequest.httpMethod = HTTPMethod.post.rawValue
          postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
          postRequest.timeoutInterval = TIMEOUT
          var token = ""
          if AppContext.defaultAppContext.token != nil {
            if Utility.isValidString(AppContext.defaultAppContext.token as Any) {
              token = AppContext.defaultAppContext.token!
              postRequest.setValue(token, forHTTPHeaderField: "Authorization")
            }
          }
          let data : NSData! = try! JSONSerialization.data(withJSONObject: parameters as Any, options: []) as NSData?
          postRequest.httpBody = data as Data?
          if HUDText != "" {
            UtilTools.showLoadingWithMessage(message: HUDText)
          }
          Alamofire.request(postRequest).responseJSON { (response) in
 //                print("resopnse===\(response)")
                 // 网络连接或者服务错误的提示信息
            if HUDText != "" {
                UtilTools.stopSVProgressHUD()
            }
                 guard response.result.isSuccess else
                 {
                     Utility.showToastView(response.error!.localizedDescription)
                     return errorMsgHandler(response.error!.localizedDescription)
                 }
                 if let value = response.result.value {
                     let json = JSON(value)
                     // 请求成功 但是服务返回的报错信息
                     guard json["code"].intValue == 0 else {
                         if(json["code"].intValue == 300){ // Token 过期刷新
//                            if AppContext.defaultAppContext.userInfo == nil {
//                                return
//                            }
//                            let dict = ["refreshToken":AppContext.defaultAppContext.refreshToken!]
//                            CloudAPI.tokenRefresh(dict: dict, successHandler: { (json) in
//                                if json["code"].intValue == 300 {
//                                    AppContext.defaultAppContext.token = nil
//                                    AppContext.defaultAppContext.refreshToken = nil
//                                    let nav = BaseNavigationController.init(rootViewController: ChooseLoginViewController())
//                                    UIApplication.shared.keyWindow?.rootViewController = nav
//                                    Utility.showToastView("请重新登录")
//                                }else if json["code"].intValue == 0 {
//                                    let dict = json["data"]
//                                    AppContext.defaultAppContext.refreshToken = dict["refreshToken"].stringValue
//                                    AppContext.defaultAppContext.token = dict["token"].stringValue
//                                }
//                            }) { (error) in
//                                
//                            }
                         }
                         if Utility.isValidString(json["msg"].stringValue) {
                             Utility.showToastView(json["msg"].stringValue)
                         }
                         errorMsgHandler(json["msg"].stringValue)
                         return
                     }

                     let code = json["code"].intValue
                     if(code == 0){ //success
                         if json.dictionaryObject != nil {
                             successHandler(json)
                         }
                     }else {
                         if Utility.isValidString(json["msg"].stringValue) {
                             Utility.showToastView(json["msg"].stringValue)
                         }
                         successHandler(json)
                     }
                     return
             }
          }
    }
    /**!
        * 文件或图片上传
        * @para strUrl String 上传地址
        * @para image NSData
        * @para successBack  成功回调
        * @para failureBack  失败回调
        */
    static func postImageUploadToServer(strUrl:String,image:Data,successHandler: @escaping(_ json:JSON) ->(),errorMsgHandler : @escaping(_ errorMsg : String) ->(),isLoading:Bool = true){
       if isLoading == true {
           UtilTools.showLoadingWithMessage(message: "上传中")
       }
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(image, withName: "file", fileName: "file", mimeType: "image/*")
        }, to: strUrl) { (encodingResult) in
            if isLoading == true {
              UtilTools.stopSVProgressHUD()
           }
           switch(encodingResult){
           case .success(let upload,_,_):
               upload.responseJSON { response in
                   print("上传结果：\(response)")
                   let result = response.result
                   if result.isSuccess {
                       if let value = response.result.value {
                       //请求成功
                        let json = JSON(value)
                        // 请求成功 但是服务返回的报错信息
                        if json["code"].intValue == 0  {
                            if json.dictionaryObject != nil {
                            successHandler(json)
                           }
                        }else{
                            if json.dictionaryObject != nil {
                                let msg = json["msg"].stringValue
                                errorMsgHandler(msg)
                                Utility.showToastView(msg)
                           }
                        }
                     }
                   }
                   else{
                       errorMsgHandler("请求数据不存在")
                   }
               }
                     .validate()
               break
           case .failure(let error):
               errorMsgHandler("\(error.localizedDescription)")
               break
           }
        }
       }
    static func tokenRefresh(dict:[String : Any],successHandler: @escaping(_ json:JSON) ->(),errorMsgHandler : @escaping(_ errorMsg : String) ->()){
        //提交jsonbody
        var postRequest = URLRequest.init(url: URL.init(string: baseUrl+tokenRefreshUrl)!)
        postRequest.httpMethod = HTTPMethod.post.rawValue
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data : NSData! = try! JSONSerialization.data(withJSONObject: dict as Any, options: []) as NSData?
        postRequest.httpBody = data as Data?
        UtilTools.showLoadingWithMessage(message: "加载中")
        Alamofire.request(postRequest).responseJSON { (response) in
            guard response.result.isSuccess else{
                return errorMsgHandler("")
            }
            if let value = response.result.value {
                let json = JSON(value)
                successHandler(json)
                return
            }
        }
    }
//    static func uploadFile(image:Data,successHandler: @escaping(_ json:JSON) ->(),errorMsgHandler : @escaping(_ errorMsg : String) ->()){
//        self.postImageUploadToServer(strUrl: baseUrl+uploadFileUrl, image: image, successHandler: successHandler, errorMsgHandler: errorMsgHandler, isLoading: true)
//    }
    static let defaultCloudAPI = CloudAPI()
}
