//
//  UtilTools.swift
//  Mall
//
//  Created by AaronLee0619 on 2019/10/24.
//  Copyright © 2019 budian. All rights reserved.
//

import UIKit
import SVProgressHUD
import BRPickerView

class UtilTools: NSObject {

    class func showSuccessToastView(message:String) {
        stopSVProgressHUD()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showSuccess(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 1)
    }
    
    class func showErrorToastView(message:String) {
        stopSVProgressHUD()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.showError(withStatus: message)
        SVProgressHUD.dismiss(withDelay: 1)
    }
    
    class func showLoadingWithMessage(message:String) {
        stopSVProgressHUD()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        if message != "" {
            SVProgressHUD.show(withStatus: message)
        }else{
            SVProgressHUD.show()
        }
    }
    
    class func stopSVProgressHUD() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss(withDelay: 0.5)
        }
    }
    
    //
    class func setGradientColor(frame:CGRect,fromColor:UIColor,toColor:UIColor) -> CAGradientLayer{
        let gradientlayer = CAGradientLayer.init()
        gradientlayer.frame = frame
        gradientlayer.colors = [fromColor.cgColor,toColor.cgColor]
        let gradientLocations:[NSNumber] = [0.0,1.0]
        gradientlayer.locations = gradientLocations
        gradientlayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientlayer.endPoint = CGPoint.init(x: 1, y: 1)
        return gradientlayer
    }
    //设置右上右下圆角
    class func setTopRightBottomRightCornerWithView(view:UIView){
        let corner = UIRectCorner(rawValue: UIRectCorner.topRight.rawValue | UIRectCorner.bottomRight.rawValue)
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    //设置左上左下圆角
    class func setTopLeftBottomLeftCornerWithWith(view:UIView){
        let corner = UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.bottomLeft.rawValue)
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    //设置左上右上圆角
    class func setTopLeftTopRightCornerWithWith(view:UIView){
        let corner = UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue)
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    //设置首页图片切角
    class func setHomeTopImageBottom(view:UIView){
        let corner = UIRectCorner(rawValue: UIRectCorner.bottomLeft.rawValue | UIRectCorner.topRight.rawValue)
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: 50, height: 50))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
    class func imageWithImageName(name:String) -> UIImage{
        var image = UIImage.init(named: name+".png")
        image = image?.withRenderingMode(.alwaysOriginal)
        return image!
    }
    //MARK:获取字符串的高度的封装
    class func kGetLabelH(labelStr:String,font:UIFont,width:CGFloat) -> CGFloat{
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: width, height: 900)
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        return strSize.height
    }
    //MARK:获取字符串的宽度的封装
    class func KGetLabWidth(labelStr:String,font:CGFloat,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: kScreenWIDTH, height: height)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: font), forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context:nil).size
        return strSize.width + 5
    }
    //View转Image
    class func getViewScreenshot(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK: - 传进去字符串,生成二维码图片
    class func setupQRCodeImage(_ text: String, image: UIImage?) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: 300)
            //如果有一个头像的话，将头像加入二维码中心
            if var image = image {
                //给头像加一个白色圆边（如果没有这个需求直接忽略）
                image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
                //合成图片
                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: 100, height: 100)
                
                return newImage
            }
            
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    //image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    class func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat, height: CGFloat) -> UIImage{
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }

    //MARK: - 生成高清的UIImage
    class func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }

    //生成边框
    class func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    // JSONString转换为字典
    class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    // 字典转换JSONString
    class func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
    
    class func getCacheMamery() -> String {
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 打印路径,需要测试的可以往这个路径下放东西
//        print(cachePath!)
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        var big = CGFloat();
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            let path = cachePath!.appendingFormat("/\(p)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size{
                    big += CGFloat(truncating: (bcd as AnyObject) as! NSNumber)
                }
            }
        }
        big = big/2
        var mamery:String = ""
        if big > 1024*1024 {
            mamery = String.init(format: "%.2f", 0.007*big/1024/1024)+"M"
        }else if big > 1024 && big < 1024*1024 {
            mamery = String.init(format: "%.2f", big/1024)+"KB"
        }else{
            mamery = "0KB"
        }
        return mamery

    }
    
    class func clearCacheMamery() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        // 遍历删除
        for file in fileArr! {
            let path = cachePath?.appendingFormat("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    
                }
            }
        }
    }
    
    // MARK: 生成不同颜色字符串
    class func generateAttributeString(colors: [UIColor], ranges: [Int], string: String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString.init(string: string)
        
        for i in 0..<colors.count {
            if i == 0 {
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[i], range: NSMakeRange(0, ranges[0]))
            } else {
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[i], range: NSMakeRange(ranges[i-1], ranges[i]))
            }
        }
        return str
    }
        
    class func addScaleAnimationOnView(animationView:UIView) {
        //需要实现的帧动画，这里根据需求自定义
        let animation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        animation.values = [1.0,1.3,0.9,1.15,0.95,1.02,1.0]
        animation.duration = 1
        animation.calculationMode = CAAnimationCalculationMode.cubic
        animationView.layer.add(animation, forKey: nil)
    }
    
    class func rotationZAnimation(animationView:UIView) {
        //需要实现的帧动画，这里根据需求自定义
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.duration = 0.5
        animation.repeatCount = 1
        animation.fromValue = 0
        animation.toValue = CGFloat.pi
        animationView.layer.add(animation, forKey: nil)
    }
    
    class func showAlertWith(title:String,cancelTitle:String,okTitle:String,handler:@escaping((UIAlertAction) -> Void)){
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: cancelTitle, style: .cancel, handler: nil)
        let okAction = UIAlertAction.init(title: okTitle, style: .destructive) { (action) in
            handler(action)
        }
        okAction.setValue(UIColor.hexadecimalColor(hexadecimal: "#FF5337"), forKey: "_titleTextColor")
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        Utility.findCurrentViewController().present(alert, animated: true, completion: nil)
    }
    class func isValidString(value:AnyObject!) -> Bool {
        if value == nil {
            return false
        }else {
            if let myValue = value as? String {
                if myValue == "" || myValue == "(null)" || 0 == myValue.count {
                    return false
                }else{
                    return true
                }
            }
        }
        return true
    }
    
    class func showPickerViewWith(dataSource:Array<String>,block:@escaping((BRResultModel) -> Void)){
        let pickerView = BRStringPickerView.init()
        pickerView.pickerMode = .componentSingle
        let style = BRPickerStyle.init()
        style.cancelBtnTitle = "取消"
        style.doneBtnTitle = "确定"
        style.titleBarColor = UIColor.hexadecimalColor(hexadecimal: "#F5F5F5")
        style.cancelTextColor = UIColor.hexadecimalColor(hexadecimal: "#656565")
        style.cancelTextFont = kSystemFONT(size: 14)
        style.doneTextFont = kSystemFONT(size: 14)
        style.doneTextColor = UIColor.hexadecimalColor(hexadecimal: "#FF5338")
        style.separatorColor = UIColor.hexadecimalColor(hexadecimal: "#EFEFEF")
        style.selectRowTextColor = UIColor.hexadecimalColor(hexadecimal: "#FF5338")
        style.selectRowTextFont = kSystemFONT(size: 14)
        style.pickerTextFont = kSystemFONT(size: 14)
        style.pickerTextColor = UIColor.hexadecimalColor(hexadecimal: "#333333")
        pickerView.pickerStyle = style
        pickerView.dataSourceArr = dataSource
        pickerView.resultModelBlock = { (resultModel)->Void in
            block(resultModel!)
        }
        pickerView.show()
    }
    
    class func showDatePickerView(isNeedMinDate:Bool,block:@escaping((NSDate,NSString) ->Void)){
        let datePickerView = BRDatePickerView.init(pickerMode: .YMD)
        let currentDate = Date.init(timeIntervalSinceNow: 0)
        if isNeedMinDate == true {
            datePickerView.minDate = currentDate
        }
        //设置自定义样式
        let customStyle = BRPickerStyle.init()
        customStyle.cancelBtnTitle = "取消"
        customStyle.doneBtnTitle = "确定"
        customStyle.cancelTextColor = UIColor.hexadecimalColor(hexadecimal: "#656565")
        customStyle.cancelTextFont = kSystemFONT(size: 14)
        customStyle.doneTextFont = kSystemFONT(size: 14)
        customStyle.doneTextColor = UIColor.hexadecimalColor(hexadecimal: "#FF5338")
        customStyle.separatorColor = UIColor.hexadecimalColor(hexadecimal: "#EFEFEF")
        customStyle.selectRowTextColor = UIColor.hexadecimalColor(hexadecimal: "FF5338")
        datePickerView.pickerStyle = customStyle
        datePickerView.resultBlock = { (selectDate,selectValue) -> Void in
            block(selectDate! as NSDate,selectValue! as NSString)
        }
        datePickerView.show()
    }
    
    class func rootViewController() ->(UIViewController){
        var root = UIApplication.shared.keyWindow?.rootViewController
        if (root?.isKind(of: UINavigationController.self))! {
            root = (root as? UINavigationController)?.viewControllers.first
        }
        if (root?.isKind(of: UITabBarController.self))! {
            root = (root as? UITabBarController)?.selectedViewController
        }
        return root!
    }
    class func getAppledate() -> AppDelegate {
        let appDeledate = UIApplication.shared.delegate as! AppDelegate
        return appDeledate
    }
}
    
