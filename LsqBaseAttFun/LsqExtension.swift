//
//  LsqExtension.swift
//  XYZ
//
//  Created by 罗石清 on 2020/4/27.
//  Copyright © 2020 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

extension UIViewController {
    //底部tabbar高度
    public var tabBarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
    //导航栏和状态栏高度
    public var navStatusHeigh: CGFloat {
        return LsqScreen.statusHeight + self.navHeigh
    }
    //导航栏高度
    public var navHeigh: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0
    }
}

//MARK:UIColor扩展
extension UIColor {
    //16进制颜色
    public class func hexColor(with string:String) -> UIColor? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count < 6 {
            return nil
        }
        if cString.hasPrefix("0X") {
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index...])
        }
        if cString .hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index...])
        }
        if cString.count != 6 {
            return nil
        }
        
        let rrange = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rrange])
        let grange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[grange])
        let brange = cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[brange])
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
    //RGB颜色
    public class func rgbColor(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    //随机颜色
    public class var randomColor: UIColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
    //UIColor转成颜色图片
    public func conversionToImage(size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension String{
    //根据宽度跟字体，计算文字的高度
    public func textAutoHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with: CGSize(width: width, height: 0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.height
    }
    //根据高度跟字体，计算文字的宽度
    public func textAutoWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with: CGSize(width: 0, height: height), options: [origin,lead], attributes: [NSAttributedString.Key.font:font], context: nil)
        return rect.width
    }
    //判断正则
    public func isRegex(with regex: LsqRegex) -> Bool {
        return MyRegex(regex.rawValue).match(input: self)
    }
    //字符串转date
    public func toDate(type: LsqTimeFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        let date = formatter.date(from: self)
        return date
    }
    //字符串T时间格式转Date
    public func toTDate() -> Date? {
        let replac = self.replacingOccurrences(of: "T", with: " ")
        if replac.count < 19 { return nil }
        let sub = String(replac[0..<19])
        if let tmpDate = sub.toDate(type: .yyyy_MM_dd_HH_mm_ss) {
            let timeInterval = tmpDate.timeIntervalSince1970 + 8 * 60 * 60
            let date = Date(timeIntervalSince1970: timeInterval)
            return date
        }
        return nil
    }
    //判断是否只包含空格
    public var isSpace: Bool {
        let set = CharacterSet.whitespacesAndNewlines
        let trimedString = self.trimmingCharacters(in: set)
        if trimedString.count == 0 {
            return true
        } else {
            return false
        }
    }
    //json字符串转换成字典
    public var dictionary: [String:Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        guard let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else {
            return nil
        }
        return dict
    }
    //去除表情
    public var disable_emoji: String? {
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let modifiedString = regex?.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        return modifiedString
    }
    //字符串插入
    public func insert(_ string: String, count: Int)->String{
        var index = 0
        var endString = ""
        for char in self{
            if index % count == 0 && index != 0{
                endString.append("\(string)\(char)")
            }else{
                endString.append(char)
            }
            index += 1
        }
        return endString
    }
    
    //判断字符串中是否有中文
    public func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { return true } // 中文字符范围：0x4e00 ~ 0x9fff
        }
        return false
    }
    /// 将中文字符串转换为拼音
    ///
    /// - Parameter hasBlank: 是否带空格（默认不带空格）
    public func transformToPinyin(hasBlank: Bool = false) -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as String
        return hasBlank ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }
    //获取中文首字母
    public func getFirstChar() -> String {
        if self.isIncludeChinese() {
            let a = self.transformToPinyin()
            if let f = a.first {
                return "\(f)"
            }
        }
        return ""
    }

}
extension String{//字符串截取
    //读取某个下标字符
    subscript(index: Int)->String{
        get{//读取
            let idx = self.index(self.startIndex, offsetBy: index)
            return String(self[idx])
        }
        set{//修改
            self.remove(at: self.index(self.startIndex, offsetBy: index))
            let new = newValue
            for i in 0..<new.count{
                let character = Character(new[i])
                let idx = self.index(self.startIndex, offsetBy: index + i)
                self.insert(character, at: idx)
            }
        }
    }
    //读取闭区间字符串
    subscript(rang: ClosedRange<Int>) ->String{
        let range = self.index(startIndex, offsetBy: rang.lowerBound )...self.index(startIndex, offsetBy: rang.upperBound)
        return String(self[range])
    }
    //读取开区间字符串
    subscript(rang: Range<Int>) ->String{
        let range = self.index(startIndex, offsetBy: rang.lowerBound )..<self.index(startIndex, offsetBy: rang.upperBound)
        return String(self[range])
    }
    
}

extension String {
    public var attribute: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

extension String {
    
    public var int: Int { return Int(self) ?? 0 }
    public var double: Double { return Double(self) ?? 0 }
    public var float: Float { return Float(self) ?? 0 }
    public var cgFloat: CGFloat { return CGFloat(self.float) }
    
    public var intValue: Int? { return Int(self) }
    public var doubleValue: Double? { return Double(self) }
    public var floatValue: Float? { return Float(self) }
    public var cgFloatValue: CGFloat? {
        guard let floatV = self.floatValue else { return nil }
        return CGFloat(floatV)
    }
}

extension UISearchBar {
    //获取UISearchBar的输入框
    public func getTextFiled() -> UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }else{
            let textF = self.value(forKey: "_searchField") as? UITextField
            return textF
        }
    }
}

extension Array where Element: Equatable {
    //数组去重复
    public var toRepeat: [Element] {
        var result = [Element]()
        for item in self {
            if !result.contains(item) {
                result.append(item)
            }
        }
        return result
    }
    
}

extension UIView {
    
    //获取视图的控制器
    public var viewController: UIViewController? {
        var next: UIResponder?
        next = self.next
        repeat {
            if (next as? UIViewController) != nil {
                return (next as? UIViewController)
            } else {
                next = next?.next
            }
        } while next != nil
        return (next as? UIViewController)
    }
    //位置
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
    }
    public var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
    }
    
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.height
        }
        set {
            let y = newValue - self.frame.height
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.width
        }
        set {
            let x = newValue - self.frame.width
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
    public func setBorder(width: CGFloat, color: UIColor, top: Bool, right: Bool, bottom: Bool, left: Bool) {
        if top {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        if right {
            let layer = CALayer()
            layer.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        if bottom {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.height - width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        if left {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
    }
    //圆角
    public func setRoundBorder(rect: CGRect? = nil, rectCorners: UIRectCorner, cornerRadii: CGSize) {
        let bds = rect == nil ? self.bounds : rect!
        let mask = UIBezierPath(roundedRect: bds, byRoundingCorners: rectCorners, cornerRadii: cornerRadii)
        let shape = CAShapeLayer()
        shape.path = mask.cgPath
        shape.frame = bds
        self.layer.mask = shape
    }
   
}
