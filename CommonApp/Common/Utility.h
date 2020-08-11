//
//  Utility.h
//  MusicRecogn
//
//  Created by AaronLee on 2020/4/7.
//  Copyright © 2020 AaronLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
};
@interface Utility : NSObject

+ (BOOL) isValidString:(id)input;
+ (BOOL) isValidDictionary:(id)input;
+ (BOOL) isValidArray:(id)input;
+ (BOOL) isValidMobile:(NSString *)input;

// 显示一段时间后消失的自定义提示框
+ (void)showToastView:(NSString *)message delay:(CGFloat)delay;
+ (void)showToastView:(NSString *)message;

//点击动画
+ (void)animateWithLayer:(CALayer *)layer block:(void (^)(void))block;

//晃动动画
+ (void)bagShakeAnimation:(CALayer *)layer;
+ (void)shakeAnimationWithView:(UIView *)view;

//获取对应图片
+ (UIImage *)imageWithimageName:(NSString *)imagename;

//判断是否为表情
+(BOOL)isContainsEmoji:(NSString *)string;

//根据色值生成图片
+ (UIImage *)getImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

//判断是否是同一天
+ (BOOL)compareCurrentTime:(NSString *)str;

//世界标准时间UTC /GMT 转为当前系统时区对应的时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;

//设备信息
+ (NSString *)getDeviceId;
+ (NSString *)getDeviceModel;
+ (NSString *)getOSVersion;
+ (NSString *)getOSLang;
+ (NSString *)getAppVersion;
+ (NSString *)getNetType;

+ (void)fadeLayer:(CALayer *)layer;

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+ (NSString *)formatCurrency:(NSNumber *)amount;

//获取当前的时间字符串
+ (NSString *)getCurrentTimes;

//获取当前的时间戳字符串
+(NSString *)getNowTimestamp;

+ (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content;

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(CGRect)bounds fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr cornerRadius:(CGFloat)cornerRadius Direction:(GradientType)direction;

//拨打电话
+ (BOOL)callWithString:(NSString *)phoneStr;

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//64编码
+ (NSString *)encode:(NSString *)string;

//64解码
+ (NSString *)dencode:(NSString *)base64String;

+ (NSString *)getAppBundleId;
   
+ (UIViewController *)findCurrentViewController;

+ (BOOL)isNum:(NSString *)checkedNumString;

+ (NSString *)wifiMac;

+ (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString;

+ (void)showGifImageOnlyOnceWithImageView:(UIImageView*)imageView path:(NSString*)path;

//旋转动画
+ (UIButton *)rotate360DegreeWithImageView:(UIButton *)imageView;

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
+ (void)goToAppSystemSetting;

+ (void)exitApplication; //强制退出APP

+ (NSString *)getTotalTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+ (NSString *)returnBankCard:(NSString *)BankCardStr;

+ (void)sentPhoneCodeTimeMethod:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
