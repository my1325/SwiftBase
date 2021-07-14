//
//  LinkedList.swift
//  SwifBase
//
//  Created by my on 2021/7/13.
//

import Foundation

/// 使用数组实现的链表
public class LinkedList<T> {
    
    public typealias Index = Int
    
    private var n: [T] = []
    private var ne: [Index] = []
    
    public convenience init(head val: T) {
        self.init()
        self.addToHead(val)
    }
    
    public private(set) var head: Index = .EMPTY_HEAD
    
    public var count: Int {
        return size
    }
    
    public var description: String {
        var res: [T] = []
        var i = head
        while i != .NOT_INDEX {
            res.append(n[i])
            i = ne[i]
        }
        return String(format: "[%@]", res.map({ "\($0)" }).joined(separator: "->"))
    }
    
    private var size: Int = 0
    
    /// 添加到头结点
    public func addToHead(_ val: T) {
        if head == .EMPTY_HEAD {
            ne.append(.NOT_INDEX)
            head = .LINK_START
        } else {
            ne.append(ne[head])
            head = n.count
        }
        n.append(val)
        size += 1
    }
    
    /// 在第k个结点插入val， 从0开始，0表示头结点
    public func insert(to k: Index, val: T) {
        guard k <= size && k >= 0 else { fatalError() }
        
        if k == .LINK_START { addToHead(val) }
        else {
            let i: Index = find(k - 1)
            if k == size {
                ne.append(.NOT_INDEX)
            } else {
                ne.append(ne[i])
            }
            ne[i] = n.count
            n.append(val)
        }
        size += 1
    }
    
    /// 追加一个val
    public func append(_ val: T) {
        insert(to: size, val: val)
    }
    
    /// 删除第k个元素, 从0开始，0标识头结点
    public func remove(_ k: Int) {
        guard k < size else { fatalError() }
        
        if (k == .LINK_START) {
            head = .EMPTY_HEAD
            n.removeAll()
            ne.removeAll()
        } else {
            let i: Index = find(k - 1)
            ne[i] = ne[ne[i]]
        }
        size -= 1
    }
    
    public func get(_ k: Int) -> T {
        return n[find(k)]
    }
    
    public subscript(_ k: Int) -> T {
        get { get(k) }
        set { insert(to: k, val: newValue) }
    }
    
    private func find(_ k: Int) -> Index {
        guard k >= 0 else { fatalError() }
        var i: Int = head
        var _k = k
        while _k > 0 {
            i = ne[i]
            _k -= 1
        }
        return i
    }
}

extension LinkedList.Index {
    public static let NOT_INDEX = -2
    public static let EMPTY_HEAD = -1
    public static let LINK_START = 0
}
