//
//  Utility.m
//  MusicRecogn
//
//  Created by AaronLee on 2020/4/7.
//  Copyright © 2020 AaronLee. All rights reserved.
//

#import "Utility.h"
#import <sys/utsname.h>
#import <Accelerate/Accelerate.h>
#import <AdSupport/AdSupport.h>
#import <NetworkExtension/NetworkExtension.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#define kScreenWIDTH [UIScreen mainScreen].bounds.size.width

#define kScreenHEIGHT [UIScreen mainScreen].bounds.size.height

@implementation Utility

+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    if ([input isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+ (BOOL) isValidDictionary:(id)input
{
    if (!input) {
        return NO;
    }
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    if (![input isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([input count] <= 0) {
        return NO;
    }
    return YES;
}

+ (BOOL) isValidArray:(id)input
{
    if (!input) {
        return NO;
    }
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    if (![input isKindOfClass:[NSArray class]]) {
        return NO;
    }
    if ([input count] <= 0) {
        return NO;
    }
    return YES;
}

+ (BOOL) isValidMobile:(NSString *)input{
    NSString * regex=@"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:input];
}

// 显示一段时间后消失的自定义提示框
+ (void)showToastView:(NSString *)message delay:(CGFloat)delay {
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    CGSize size = [message boundingRectWithSize:CGSizeMake(kScreenWIDTH-66*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 10;
    label.preferredMaxLayoutWidth = kScreenWIDTH-66*2;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [label sizeToFit];
    
    view.frame = ({
        CGRect frame;
        frame.size.width = size.width +28*2;
        frame.size.height = size.height + 17*2 +5;
        frame.origin.y = (kScreenHEIGHT -frame.size.height)*3/4.0;
        frame.origin.x = (kScreenWIDTH -frame.size.width)/2.0;
        frame;
    });
    
    label.frame = (CGRect){28,17,size.width,size.height+5};
    [view addSubview:label];
    label = nil;
    [window addSubview:view];
    [window bringSubviewToFront:view];
    
    __block UIView *tempView = view;
    [UIView animateWithDuration:0.5f
                          delay:delay-0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         tempView.alpha = 0;
                     }completion:^(BOOL finished){
                         [tempView removeFromSuperview];
                         tempView = nil;
                     }];
}

+ (void)showToastView:(NSString *)message{
    [self showToastView:message delay:3];
}

+ (void)animateWithLayer:(CALayer *)layer block:(void (^)(void))block {
    NSNumber *animationScale1 = @(0.7);
    NSNumber *animationScale2 = @(1.15);
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            !block ? : block();
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

+ (void)bagShakeAnimation:(CALayer *)layer {
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:- 0.2];
    shake.toValue   = [NSNumber numberWithFloat:+ 0.2];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    [layer addAnimation:shake forKey:@"bagShakeAnimation"];
}

+ (void)shakeAnimationWithView:(UIView *)view {
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = view.transform.tx;
    
    animation.duration = 0.5;
    animation.values = @[ @(currentTx), @(currentTx + 10), @(currentTx-8), @(currentTx + 8), @(currentTx -5), @(currentTx + 5), @(currentTx) ];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:@"kAFViewShakerAnimationKey"];
}

//获取对应图片
+ (UIImage *)imageWithimageName:(NSString *)imagename
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imagename]];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+(BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

+ (UIImage *)getImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//判断是否是同一天
+ (BOOL)compareCurrentTime:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *msgDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:currentDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    return (nowDateComponents.year != msgDateComponents.year && nowDateComponents.month != msgDateComponents.month && nowDateComponents.day != msgDateComponents.day);
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSString *)getAnalysisEventID:(NSInteger)eventID target:(NSString *)target{
    
    NSDictionary *eventDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EventID" ofType:@"plist"]];
    if (eventDic != nil && [[eventDic allKeys] containsObject:[NSString stringWithFormat:@"%ld",eventID]]) {
        NSDictionary *aDic = eventDic[[NSString stringWithFormat:@"%ld",eventID]];
        
        if (aDic != nil && [[aDic allKeys] containsObject:target])
            
            return aDic[target];
    }

    return @"007";
}

+ (NSString *)getDeviceId{
    static NSString *udid;
    if(!udid){
        udid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        if(udid ==nil  || [udid hasPrefix:@"00000000"]){
            udid = [NSString stringWithFormat:@"_%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        }
    }
    return udid;
}
+ (NSString *)getDeviceModel{
    static NSString *model;
    if(!model){
        struct utsname systemInfo;
        uname(&systemInfo);
        model = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    }
    return model;
}
+ (NSString *)getOSVersion{
    static NSString *version;
    if(!version){
        version = [[UIDevice currentDevice] systemVersion];
    }
    return version;
}
+ (NSString *)getOSLang{
    static NSString *lang;
    if(!lang){
        lang = [NSLocale preferredLanguages][0];
    }
    return lang;
}
+ (NSString *)getAppVersion{
    static NSString *version;
    if(!version){
        version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return version;
}
+ (NSString *)getNetType{
    return @"Unknow";
}

+ (void)fadeLayer:(CALayer *)layer {
    CATransition *transition = [CATransition animation];
    
    transition.duration = .5;
    
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    [transition setValue:@"kCATransitionFade" forKey:@"type"];
    
    [layer addAnimation:transition forKey:@"fade"];
    
}

+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

+ (NSString *)formatCurrency:(NSNumber *)amount{
    NSNumberFormatter *_currencyFormatter = [[NSNumberFormatter alloc] init];
    [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_currencyFormatter setCurrencySymbol:@""];
    [_currencyFormatter setMaximumFractionDigits:2];
    return [_currencyFormatter stringFromNumber:amount];
}

//获取当前的时间
+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
//    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

//获取当前的时间戳字符串
+(NSString *)getNowTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a*1000];//转为字符型
    return timeString;
    
}

/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param secret       秘钥
 *  @param content 要加密的文本
 *
 *  @return 加密后的字符串
 */
+ (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content
{
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [content cStringUsingEncoding:NSUTF8StringEncoding];// 有可能有中文 所以用NSUTF8StringEncoding -> NSASCIIStringEncoding
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualChangingColor:(CGRect)bounds fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr cornerRadius:(CGFloat)cornerRadius Direction:(GradientType)direction{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[Utility colorWithHex:fromHexColorStr].CGColor,(__bridge id)[Utility colorWithHex:toHexColorStr].CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    if (direction == GradientTypeLeftToRight) {
        gradientLayer.endPoint = CGPointMake(1, 0);
    }else{
        gradientLayer.endPoint = CGPointMake(0, 1);
    }
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    if (cornerRadius) {
        gradientLayer.cornerRadius = cornerRadius;
        gradientLayer.masksToBounds = YES;
    }
    return gradientLayer;
    
}

//获取16进制颜色的方法
+ (UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexColor length] < 6) {
        return nil;
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
    } else {
        a = 255;
    }
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}

//拨打电话
+ (BOOL)callWithString:(NSString *)phoneStr{
    NSMutableString *callPhone=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    // 大于等于10.0系统使用此openURL方法
    static BOOL callResult;
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:^(BOOL success) {
            callResult = success;
        }];
    } else {
        // Fallback on earlier versions
    }
    return callResult;
}

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)encode:(NSString *)string
{
    //先将string转换成data
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}

+ (NSString *)dencode:(NSString *)base64String
{
    //NSData *base64data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

+ (NSString *)getAppBundleId{
    static NSString *version;
    if(!version){
        version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleIdentifier"];
    }
    return version;
}
    
+ (UIViewController *)findCurrentViewController
{
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIViewController *topViewController = [window rootViewController];
        
        while (true) {
            
            if (topViewController.presentedViewController) {
                
                topViewController = topViewController.presentedViewController;
                
            } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
                
                topViewController = [(UINavigationController *)topViewController topViewController];
                
            } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
                
                UITabBarController *tab = (UITabBarController *)topViewController;
                topViewController = tab.selectedViewController;
                
            } else {
                break;
            }
        }
        return topViewController;
}

+ (BOOL)isNum:(NSString *)checkedNumString{
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

/*
 * 获取设备物理地址
 */
+ (NSString *)wifiMac
{
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) ifname);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *bssid = [dic objectForKey:@"BSSID"];
    if ([Utility isValidString:bssid]) {
        return bssid;
    }else{
        return @"";
    }
}

+ (NSDictionary *)convertjsonStringToDict:(NSString *)jsonString{
    NSDictionary *retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}

+ (void)showGifImageOnlyOnceWithImageView:(UIImageView*)imageView path:(NSString*)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    CGImageSourceRef gifSource = CGImageSourceCreateWithData(CFBridgingRetain(data), nil);
    size_t gifCount =CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    UIImage *finalImage = [[UIImage alloc] init];
    for(size_t i =0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i,NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [frames addObject:image];
        CGImageRelease(imageRef);
        if (i == (gifCount-1)) {
            finalImage = [UIImage imageWithCGImage:imageRef];
        }
    }
    //从这里开始是不是很熟悉
    imageView.animationImages = frames;
    imageView.animationDuration = 3;
//    imageView.animationRepeatCount = 1;
    
    //倒计时时间 - 3S
    __block NSInteger timeOut = 3;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [imageView stopAnimating];
                imageView.image = finalImage;
            });
        } else {
            //开始计时
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [imageView startAnimating];
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}

//旋转动画
+ (UIButton *)rotate360DegreeWithImageView:(UIButton *)imageView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2.0, 0.0, 0.0, 1.0) ];
    animation.duration = 1.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    CGRect imageRrect = CGRectMake(0, 0,imageView.imageView.frame.size.width, imageView.imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    [imageView.currentImage drawInRect:CGRectMake(1,1,imageView.imageView.frame.size.width-2,imageView.imageView.frame.size.height-2)];
    [imageView setImage: UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
    [imageView.layer addAnimation:animation forKey:@"transform360"];
    return imageView;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
+ (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}

+ (void)exitApplication{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.1 animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        abort();
    }];
}

+ (NSString *)getTotalTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    //按照日期格式创建日期格式句柄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //将日期字符串转换成Date类型
    NSDate *startDate = [dateFormatter dateFromString:startTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    //将日期转换成时间戳
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    NSTimeInterval end = [endDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    //计算具体的天，时，分，秒
//    int second = (int)value %60;//秒
//    int minute = (int)value / 60 % 60;
//    int house = (int)value / 3600;
    int day = (int)value / (24 * 3600);
    //将获取的int数据重新转换成字符串
    NSString *str;
//    if (day != 0) {
//        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
//    }else if (day==0 && house != 0) {
//        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
//    }else if (day== 0 && house== 0 && minute!=0) {
//        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
//    }else{
//        str = [NSString stringWithFormat:@"%d秒",second];
//    }
    str = [NSString stringWithFormat:@"%d",day];
    //返回string类型的总时长
    return str;
}

+ (NSString *)returnBankCard:(NSString *)BankCardStr{
     NSString *formerStr = [BankCardStr substringToIndex:4];
     NSString *str1 = [BankCardStr stringByReplacingOccurrencesOfString:formerStr withString:@""];
     NSString *endStr = [BankCardStr substringFromIndex:BankCardStr.length-4];
     NSString *str2 = [str1 stringByReplacingOccurrencesOfString:endStr withString:@""];
     NSString *middleStr = [str2 stringByReplacingOccurrencesOfString:str2 withString:@"****"];
     NSString *CardNumberStr = [formerStr stringByAppendingFormat:@"%@%@",middleStr,endStr];
     return CardNumberStr;
}

+ (void)sentPhoneCodeTimeMethod:(UIButton *)sender{
    //倒计时时间 - 60S
    __block NSInteger timeOut = 59;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(timer);
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                // 倒计时结束
                [sender setTitle:@"重发验证码" forState:UIControlStateNormal];
                [sender setTitleColor:[Utility colorWithHex:@"#999999"] forState:UIControlStateNormal];
//                [sender setBackgroundColor:[Utility colorWithHex:@"#5C3AFF"]];
                [sender setEnabled:YES];
                [sender setUserInteractionEnabled:YES];
            });
        } else {
            //开始计时
            //剩余秒数 seconds
            NSInteger seconds = timeOut % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.1ld", seconds];
            //主线程设置按钮样式
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:@"%@s",strTime];
                [sender setTitle:title forState:UIControlStateNormal];
                // 设置按钮title居中 上面注释的方法无效
                [sender setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                [sender setTitleColor:[Utility colorWithHex:@"#FF5438"] forState:UIControlStateNormal];
//                [sender setBackgroundColor:kRGB(208, 212, 235)];
                //计时器间不允许点击
                [sender setEnabled:NO];
                [sender setUserInteractionEnabled:NO];
            });
            timeOut--;
        }
    });
    dispatch_resume(timer);
}


@end
