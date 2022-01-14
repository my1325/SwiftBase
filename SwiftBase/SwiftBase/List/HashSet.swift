//
//  HashList.swift
//  SwiftBase
//
//  Created by my on 2021/7/14.
//

import Foundation

public protocol HashValue: Equatable {
    var hashCode: Int { get }
}
 
/// 开发地址法(10^5的容量)
public class HashSet<T: HashValue> {
    
    public var count: Int {
        return size
    }
    
    private var size: Int = 0
    
    /// 容量的2倍
    private let capacity: Int = 200003
    
    private lazy var container: [T?] = Array(repeating: nil, count: capacity)
    
    public var description: String {
        return String(format: "[%@]", container.filter({ $0 != nil }).map({ "\($0!)" }).joined(separator: ","))
    }
    
    public func insertValue(_ val: T) {
        container[find(val)] = val
        size += 1
    }
    
    public func contains(_ val: T) -> Bool {
        return container[find(val)] != nil
    }
    
    public func remove(_ val: T) {
        container[find(val)] = nil
        size -= 1
    }
    
    private func find(_  val: T) -> Int {
        /// 此处加一个capacity是防止val的hashCode为负的情况
        var k = (val.hashCode % capacity + capacity) % capacity
        
        while let value = container[k], value != val {
            k += 1
            if k == capacity {
                k = 0
            }
        }
        return k
    }
}

/// 链地址法（10^5的容量）
public class HashLinkedSet<T: HashValue> {
    
    public var count: Int {
        return size
    }
    
    private var size: Int = 0
    
    /// 容量的2倍
    private let capacity: Int = 100003
    
    private lazy var container: [Int] = Array(repeating: -1, count: capacity)
    
    private lazy var n: [T?] = Array(repeating: nil, count: capacity)
    
    private lazy var ne: [Int] = Array(repeating: -1, count: capacity)
    
    private var idx: Int = 0
    
    public var description: String {
        var res: [T] = []
        var count = 0
        while count < size {
            for k in 0 ..< capacity {
                var i = container[k]
                while i != -1, let value = n[i] {
                    res.append(value)
                    i = ne[i]
                    count += 1
                }
            }
        }
        return String(format: "[%@]", res.map({ "\($0) "}).joined(separator: ","))
    }
    
    public func insert(_ val: T) {
        /// 此处加一个capacity是防止val的hashCode为负的情况
        let k = (val.hashCode % capacity + capacity) % capacity
        
        n[idx] = val
        ne[idx] = container[k]
        container[k] = idx
        idx += 1
        size += 1
    }
    
    public func contains(_ val: T) -> Bool {
        /// 此处加一个capacity是防止val的hashCode为负的情况
        let k = (val.hashCode % capacity + capacity) % capacity
        var i = container[k]
        while i != -1, n[i] != val {
            i = ne[i]
        }
        return i != -1
    }
    
    public func remove(_ val: T) {
        /// 此处加一个capacity是防止val的hashCode为负的情况
        let k = (val.hashCode % capacity + capacity) % capacity
        var i = container[k]
        while i != -1, n[i] != val {
            i = ne[i]
        }
        if i != -1 {
            n[i] = nil
        }
        size -= 1
    }
}

extension Int: HashValue {
    public var hashCode: Int {
        return self
    }
}

extension String: HashValue {
    public var hashCode: Int {
        return self.hashValue
    }
}
