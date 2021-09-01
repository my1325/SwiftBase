//
//  OrderedSet.swift
//  SwiftBase
//
//  Created by my on 2021/9/1.
//

import Foundation

/// 有序集合
public class OrderdSet<E: Comparable> {
    
    private var container: [E] = []
    
    var isEmpty: Bool {
        return count == 0
    }
    
    var count: Int {
        return container.count
    }
    
    public func contains(_ val: E) -> Bool {
        var l = 0, r = count - 1
        while l < r {
            let m = (l + r) / 2
            if container[m] == val { return true }
            if container[m] > val { r = m }
            else { l = m + 1 }
        }
        return false
    }
    
    /// 有序集合的添加
    public func insert(_ val: E) {
        if isEmpty {
            container.append(val)
        } else if count == 1 {
            if container[0] >= val {
                container.insert(val, at: 0)
            } else {
                container.append(val)
            }
        } else {
            let index = findPrev(val)
            if index == 0, container[0] >= val {
                container.insert(val, at: 0)
            } else if index == count - 1 {
                container.append(val)
            } else {
                container.insert(val, at: index + 1)
            }
        }
    }
    
    /// 有序集合的删除
    public func removeFirst(_ val: E) {
        guard !isEmpty else { return }
        var l = 0, r = count - 1
        while l < r {
            let m = (l + r) / 2
            if container[m] >= val { r = m }
            else { l = m + 1 }
        }
        if container[r] == val {
            container.remove(at: r)
        }
    }
    
    /// 有序集合的删除
    public func removeLast(_ val: E) {
        guard !isEmpty else { return }
        var l = 0, r = count - 1
        while l < r {
            let m = (l + r + 1) / 2
            if container[m] <= val { l = m }
            else { r = m - 1 }
        }
        if container[r] == val {
            container.remove(at: r)
        }
    }
    
    public func findPrev(_ val: E) -> Int {
        var l = 0, r = count - 1
        while l < r {
            let m = (l + r + 1) / 2
            if container[m] >= val { r = m - 1 }
            else { l = m }
        }
        return r
    }
}
