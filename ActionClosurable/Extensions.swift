//
//  Extensions.swift
//  ActionClosurable
//
//  Created by Yoshitaka Seki on 2016/04/11.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import UIKit

extension ActionClosurable where Self: UIControl {
    public func on(controlEvents: UIControlEvents, closure: (Self) -> Void) {
        registerClosure(closure: closure) {
            self.addTarget($0, action: $1, for: controlEvents)
        }
    }
}

extension ActionClosurable where Self: UIButton {
    public func onTap(closure: (Self) -> Void) {
        registerClosure(closure: closure) {
            self.addTarget($0, action: $1, for: .touchUpInside)
        }
    }
}


extension ActionClosurable where Self: UIGestureRecognizer {
    public func onGesture(closure: (Self) -> Void) {
        registerClosure(closure: closure) {
            self.addTarget($0, action: $1)
        }
    }
    public init(closure: (Self) -> Void) {
        self.init()
        onGesture(closure: closure)
    }
}

extension ActionClosurable where Self: UIBarButtonItem {
    public init(title: String, style: UIBarButtonItemStyle, closure: (Self) -> Void) {
        self.init()
        self.title = title
        self.style = style
        self.onTap(closure: closure)
    }
    public init(image: UIImage?, style: UIBarButtonItemStyle, closure: (Self) -> Void) {
        self.init()
        self.image = image
        self.style = style
        self.onTap(closure: closure)
    }
    public func onTap(closure: (Self) -> Void) {
        registerClosure(closure: closure) {
            self.target = $0
            self.action = $1
        }
    }
}

extension ActionClosurable where Self: NSTimer {
    public static func timerWithTimeInterval(ti: NSTimeInterval, repeats yesOrNo: Bool, closure: (Self) -> Void) -> Self {
        return registerClosure(closure: closure) {
            let timer = Self.init(timeInterval: ti, target: $0, selector: $1, userInfo: nil, repeats: yesOrNo)
            return timer
        }
    }
    public static func scheduledTimerWithTimeInterval(ti: NSTimeInterval, repeats yesOrNo: Bool, closure: (Self) -> Void) -> Self {
        let timer = timerWithTimeInterval(ti: ti, repeats: yesOrNo, closure: closure)
        NSRunLoop.current().add(timer, forMode: NSDefaultRunLoopMode)
        return timer
    }
}
