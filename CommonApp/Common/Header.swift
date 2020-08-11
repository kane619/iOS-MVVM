//
//  Global.swift
//  Mall
//
//  Created by AaronLee0619 on 2019/10/22.
//  Copyright © 2019 budian. All rights reserved.
//

import Foundation
import SnapKit
import IQKeyboardManagerSwift

let TAOBAOAppKey = "28288843"
let kJdappkey = "ccf63b02d31e0450149aca128ef2499c"
let kJdSecretkey = "e305e1de4196409298caaa017f84d447"
let WXappId = "wxf7809a371f806f95"
let WXAppSecret = "bCX2KghqYg9095d810iVmf5844D9dbP5"
let UMAppKey = "5dc5048c4ca35762d40006a2"
let universalLink = "https://www.chakrat.cn/apple-app-site-association/"
//MARK:状态栏高度
let kStatusBarHeight = UIApplication.shared.statusBarFrame.height
// 屏幕宽
let kScreenWIDTH = UIScreen.main.bounds.size.width
// 屏幕高
let kScreenHEIGHT = UIScreen.main.bounds.size.height
// tabbar高度
func kTabBarHeight () ->CGFloat {
    if isiPhoneX() {
        return 49.0+34.0
    }else{
        return 49.0
    }
}
// 判断是否iPhone X以上机型
func isiPhoneX() ->Bool {
    let screenHeight = UIScreen.main.nativeBounds.size.height;
    if screenHeight == 2436 || screenHeight == 1792 || screenHeight == 2688 || screenHeight == 1624 {
        return true
    }
    return false
}

func kNavigationHeight() ->CGFloat {
    if isiPhoneX() {
        return 88
    }else {
        return 64
    }
}

func kSystemFONT(size:CGFloat) -> UIFont{
    return UIFont.systemFont(ofSize: size)
}

extension UIColor{
    class func hexadecimalColor(hexadecimal:String)->UIColor{
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if(cstr.length < 6){
            return UIColor.clear;
        }
        if(cstr.hasPrefix("0X")){
            cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")){
            cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6){
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0;
        var g :UInt32 = 0x0;
        var b :UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1);
    }
}

extension UIImage {
    /// 通过图片url获取图片尺寸
    ///
    /// - Parameter url: 图片路径
    /// - Returns: 返回图片尺寸，有可能为zero
    class func getImageSizeWithURL(url:String?) -> CGSize {
        var imageSize:CGSize = .zero
        guard let imageUrlStr = url else { return imageSize }
        guard imageUrlStr != "" else {return imageSize}
        guard let imageUrl = URL(string: imageUrlStr) else { return imageSize }

        guard let imageSourceRef = CGImageSourceCreateWithURL(imageUrl as CFURL, nil) else {return imageSize}
        guard let imagePropertie = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil)  as? Dictionary<String,Any> else {return imageSize }
        imageSize.width = CGFloat((imagePropertie[kCGImagePropertyPixelWidth as String] as! NSNumber).floatValue)
        imageSize.height = CGFloat((imagePropertie[kCGImagePropertyPixelHeight as String] as! NSNumber).floatValue)
        return imageSize
    }
}


extension UILabel {
     func strike() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

extension String {
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    /// 截取到任意位置
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //md5加密 大写
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash.uppercased as String)
    }
}

extension URL {
    public var parametersFromQueryString : [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

func kLocalString(input:String) -> String {
    return NSLocalizedString(input, comment: "")
}

//MARK:快速设置颜色
func kSetRGBColor (r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    
}

//MARK:带透明色的颜色
func kSetRGBAColor (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    
}

//MARK: APP主色调
func kThemeColor() -> UIColor {
    return UIColor.hexadecimalColor(hexadecimal: "#FF5337")
}

//MARK:快速获得灰色
func kGaryColor(num : NSInteger) -> UIColor {
    return kSetRGBColor(r: CGFloat(num), g: CGFloat(num), b: CGFloat(num))
}

//MARK:渐变色
func kGradientColor(num : CGFloat) -> UIColor {
    return UIColor (red: num, green: num, blue: num, alpha: 1)
}

//调试模式输出
func kDeBugPrint<T>(item message:T, file:String = #file, function:String = #function,line:Int = #line) {
    #if DEBUG
    //获取文件名
    let fileName = (file as NSString).lastPathComponent
    //打印日志内容
    print("\(fileName):\(line) | \(message)")
    #endif
    
}
