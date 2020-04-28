//
//  LsqAtt.swift
//  XYZ
//
//  Created by 罗石清 on 2020/4/28.
//  Copyright © 2020 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

public struct LsqScreen {
    //屏幕宽度
    public static let width: CGFloat = UIScreen.main.bounds.width
    //屏幕高度
    public static let height: CGFloat = UIScreen.main.bounds.height
    //适配比例
    public static let scale375: CGFloat = LsqScreen.width / 375.0
    //状态栏高度
    public static let statusHeight: CGFloat = UIApplication.shared.statusBarFrame.height
}

public struct LsqApp {
    //app版本号
    public static var appVersion: String {
        let infoDictionary = Bundle.main.infoDictionary ?? [:]
        if let currentAppVersion = infoDictionary["CFBundleShortVersionString"] as? String {
            return currentAppVersion
        } else {
            return ""
        }
    }
    //获取版本build号
    public static var buildVersion: String {
        let infoDictionary = Bundle.main.infoDictionary
        guard let minorVersion = infoDictionary!["CFBundleVersion"] as? String else {
            return ""
        }
        return minorVersion
    }
    //是否为新版本
    public static var isNewVersion: Bool {
        let key = "LsqIsNewVersion"
        let currentVersion = LsqApp.appVersion
        if let oldVersion = UserDefaults.standard.value(forKey: key) as? String {
            if oldVersion == currentVersion {
                return false
            } else {
                //保存一下
                UserDefaults.standard.set(currentVersion, forKey: key)
                return true
            }
        } else {
            //保存一下
            UserDefaults.standard.set(currentVersion, forKey: key)
            return true
        }
    }
    //获取app应用名称
    public static var appBundleName: String {
        let infoDictionary = Bundle.main.infoDictionary ?? [:]
        guard let appBundleName = infoDictionary["CFBundleName"] as? String else {
            return ""
        }
        return appBundleName
    }
}
//TODO:转json字符串
public func getJSONString(with data: Any) -> String? {
    if !JSONSerialization.isValidJSONObject(data) {
        print("无法解析出JSONString")
        return nil
    }
    let data = try? JSONSerialization.data(withJSONObject: data, options: [])
    let jsonString = String(data: data!, encoding: .utf8)
    return jsonString
}
//TODO:延迟异步执行方法
public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
//TODO:字典相加
public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
//TODO:获取当前控制器
public func getCurrentController() -> UIViewController? {
    
    guard let window = UIApplication.shared.windows.first else {
        return nil
    }
    var tmpView: UIView?
    
    for subview in window.subviews.reversed() {
        if subview.classForCoder.description() == "UILayoutContainerView" {
            tmpView = subview
            break
        }
    }
    if tmpView == nil {
        tmpView = window.subviews.last
    }
    var nextResponder = tmpView?.next
    
    var next: Bool {
        return !(nextResponder is UIViewController) || nextResponder is UINavigationController || nextResponder is UITabBarController
    }
    while next {
        tmpView = tmpView?.subviews.first
        if tmpView == nil {
            return nil
        }
        nextResponder = tmpView!.next
    }
    return nextResponder as? UIViewController
}

//时间戳转换
public enum LsqTimeFormat: String {
    //y表示年份，m表示月份，d表示日，h表示小时，m表示分钟，s表示秒
    case yyyy_MM_dd_HH_mm_ss    = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm       = "yyyy-MM-dd HH:mm"
    case yyyy_MM_dd_HH          = "yyyy-MM-dd HH"
    case yyyy_MM_dd             = "yyyy-MM-dd"
    case yyyyMMdd               = "yyyy.MM.dd"
    case yyyyMM                 = "yyyy.MM"
    case yyyy_MM                = "yyyy-MM"
    case HH_mm                  = "HH:mm"
    case HH_mm_ss               = "HH:mm:ss"
    case yyyy                   = "yyyy"
    case MM_dd                  = "MM-dd"
    case MM                     = "MM"
}

enum RefreshType {
    case up//上拉加载更多
    case down//下拉刷新
}

public struct MyRegex {
    
    private let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    public func match(input: String) -> Bool {
        
        if let matches = self.regex?.matches(in: input, options: [], range: NSMakeRange(0, input.count)) {
            return matches.count > 0
        } else {
            return false
        }
    }
}

public enum LsqRegex: String {
    case userName   = "^[a-z0-9_-]{3,16}$"
    case phone      = "^1[0-9]{10}$"
    case idCard     = "^(\\d{14}|\\d{17})(\\d|[xX])$"
    case password   = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$"
    
    case chinese    = "^[\u{4e00}-\u{9fa5}]"
    case number     = "^[0-9]"
    case alphabet   = "^[a-zA-Z]"
}
