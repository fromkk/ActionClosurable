//
//  Extensions.swift
//  ActionClosurable
//
//  Created by Yoshitaka Seki on 2016/04/11.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import UIKit

extension ActionClosurable where Self: UIControl {
    public func on(_ controlEvents: UIControlEvents, closure: (Self) -> Void) {
        registerClosure(closure) {
            self.addTarget($0, action: $1, for: controlEvents)
        }
    }
}

extension ActionClosurable where Self: UIButton {
    public func onTap(_ closure: (Self) -> Void) {
        registerClosure(closure) {
            self.addTarget($0, action: $1, for: .touchUpInside)
        }
    }
}


extension ActionClosurable where Self: UIGestureRecognizer {
    public func onGesture(_ closure: (Self) -> Void) {
        registerClosure(closure) {
            self.addTarget($0, action: $1)
        }
    }
    public init(closure: (Self) -> Void) {
        self.init()
        onGesture(closure)
    }
}

extension ActionClosurable where Self: UIBarButtonItem {
    public init(title: String, style: UIBarButtonItemStyle, closure: (Self) -> Void) {
        self.init()
        self.title = title
        self.style = style
        self.onTap(closure)
    }
    public init(image: UIImage?, style: UIBarButtonItemStyle, closure: (Self) -> Void) {
        self.init()
        self.image = image
        self.style = style
        self.onTap(closure)
    }
    public func onTap(_ closure: (Self) -> Void) {
        registerClosure(closure) {
            self.target = $0
            self.action = $1
        }
    }
}

extension ActionClosurable where Self: Timer {
    public static func timerWithTimeInterval(_ ti: TimeInterval, repeats yesOrNo: Bool, closure: (Self) -> Void) -> Self {
        return registerClosure(closure) {
            let timer = Self.init(timeInterval: ti, target: $0, selector: $1, userInfo: nil, repeats: yesOrNo)
            return timer
        }
    }
    public static func scheduledTimerWithTimeInterval(_ ti: TimeInterval, repeats yesOrNo: Bool, closure: (Self) -> Void) -> Self {
        let timer = timerWithTimeInterval(ti, repeats: yesOrNo, closure: closure)
        RunLoop.current().add(timer, forMode: RunLoopMode.defaultRunLoopMode)
        return timer
    }
}

