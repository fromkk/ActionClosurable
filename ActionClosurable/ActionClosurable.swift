//
//  ActionClosurable.swift
//  ActionClosurable
//
//  Created by Yoshitaka Seki on 2016/04/11.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import Foundation

public class Actor<T> {
    typealias ActorClosure = (T) -> Void
    @objc func act(_ sender: AnyObject) { closure(sender as! T) }
    private let closure: ActorClosure
    init(_ closure: ActorClosure) {
        self.closure = closure
    }
}

fileprivate class GreenRoom {
    fileprivate var actors: [Any] = []
}
private var GreenRoomKey: UInt32 = 893

func register<T>(_ actor: Actor<T>, to object: AnyObject) {
    let room = objc_getAssociatedObject(object, &GreenRoomKey) as? GreenRoom ?? {
        let room = GreenRoom()
        objc_setAssociatedObject(object, &GreenRoomKey, room, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return room
        }()
    room.actors.append(actor)
}

public protocol ActionClosurable {}
public extension ActionClosurable where Self: AnyObject {
    typealias ActionClosure = (Self) -> Void
    public func registerClosure(_ closure: ActionClosure, configure: (Actor<Self>, Selector) -> Void) {
        let actor = Actor(closure)
        configure(actor, #selector(Actor<AnyObject>.act(_:)))
        register(actor, to: self)
    }
    public static func registerClosure(_ closure: ActionClosure, configure: (Actor<Self>, Selector) -> Self) -> Self {
        let actor = Actor(closure)
        let instance = configure(actor, #selector(Actor<AnyObject>.act(_:)))
        register(actor, to: instance)
        return instance
    }
}

extension NSObject: ActionClosurable {}
