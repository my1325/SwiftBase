//
//  LRUList.swift
//  SwiftBase
//
//  Created by my on 2022/1/14.
//

import Foundation

/// LRU链表
public class LRUList<T> {
    private class Node<T> {
        var pre: Node<T>?
        var next: Node<T>?
        let key: String
        var value: T
        var cost: Int
        
        init(key: String, value: T, cost: Int) {
            self.key = key
            self.value = value
            self.cost = cost
        }
    }
    
    private var head: Node<T>?
    
    private var tail: Node<T>?
    
    private var map: [String: Node<T>] = [:]
    
    public private(set) var count = 0
    
    public private(set) var cost = 0
    
    public var limitCount: Int = .max
    
    public var limitCost: Int = .max

    private func insertNode(_ node: Node<T>) {
        if let head = head {
            node.next = head.next
            node.pre = head
            head.next = node
            node.next?.pre = node
        } else {
            head = node
            tail = node
        }
    }
    
    private func bringNodeToHead(_ node: Node<T>) {
        if node === head { return }
        
        let pre = node.pre
        let next = node.next
        if node === tail {
            pre?.next = nil
            tail = pre
        } else {
            pre?.next = next
            next?.pre = pre
        }
        node.next = head
        node.pre = nil
        head?.pre = node
        head = node
    }
    
    private func removeNode(_ node: Node<T>) {
        let pre = node.pre
        let next = node.next
        if let p = pre {
            p.next = next
            next?.pre = p
        } else {
            /// node是头结点
            head = next
        }
        node.next = nil
        node.pre = nil
        
        count -= 1
        cost -= node.cost
        map[node.key] = nil
    }
    
    private func removeTail() {
        let tailNode = tail
        tail = tailNode?.pre
        tailNode?.pre = nil
        if let node = tailNode {
            map[node.key] = nil
            count -= 1
            cost -= node.cost
        }
    }
}

public extension LRUList {
    
    subscript(key: String) -> T? {
        get { getObject(for: key) }
        set {
            if let value = newValue {
                setObject(value, for: key, cost: 0)
            } else {
                removeObject(for: key)
            }
        }
    }
    
    func contains(_ key: String) -> Bool {
        return map[key] != nil
    }
    
    func setObject(_ object: T, for key: String, cost: Int) {
        if let node = map[key] {
            self.cost -= node.cost
            self.cost += cost
            
            node.cost = cost
            node.value = object
            bringNodeToHead(node)
        } else {
            self.cost += cost
            self.count += 1
            let node = Node(key: key, value: object, cost: cost)
            map[key] = node
            insertNode(node)
        }
        
        /// 判断count和cost
        if count > limitCount {
            removeTail()
        }
        
        if cost > limitCost {
            trimToCost(limitCost)
        }
    }
    
    func getObject(for key: String) -> T? {
        if let node = map[key] {
            bringNodeToHead(node)
            return node.value
        }
        return nil
    }
    
    @discardableResult
    func removeObject(for key: String) -> T? {
        if let node = map[key] {
            removeNode(node)
            return node.value
        }
        return nil
    }
    
    func removeAll() {
        head = nil
        tail = nil
        count = 0
        cost = 0
        map.removeAll()
    }
    
    func trimToCount(_ count: Int) {
        if count == 0 { removeAll() }
        
        while (self.count > count) {
            removeTail()
        }
    }
    
    func trimToCost(_ cost: Int) {
        if cost == 0 { removeAll() }
        
        while (self.cost > cost) {
            removeTail()
        }
    }
}
