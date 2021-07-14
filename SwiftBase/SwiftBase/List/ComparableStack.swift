//
//  MinStack.swift
//  SwiftBase
//
//  Created by my on 2021/7/14.
//

import Foundation

public protocol Stack {
    associatedtype T
    func push(x: T)
    
    func pop() -> T
}

/// 最大最小栈
open class ComparableStack<T>: Stack {
    public typealias Comparator = (T, T) -> Bool
    
    private var origin: [T] = []
    private var comparedValue: [T] = []
    private var size: Int = 0
    public let comparator: Comparator
    public init(comparator: @escaping Comparator) {
        self.comparator = comparator
    }
    
    public var count: Int {
        return size
    }
    
    public var currentCompared: T {
        guard size > 0 else { fatalError("stack is empty") }
        return comparedValue[size - 1]
    }
    
    public func push(x: T) {
        origin.append(x)
        if size == 0 {
            comparedValue.append(x)
        } else {
            comparedValue.append(comparator(comparedValue[size - 1], x) ? comparedValue[size - 1] : x)
        }
        size += 1
    }
    
    public func pop() -> T {
        guard size > 0 else { fatalError("stack is empty") }
        size -= 1
        comparedValue.removeLast()
        return origin.removeLast()
    }
}

public class MinStack<V: Comparable>: ComparableStack<V> {
    public init() {
        super.init(comparator: { $0 < $1 })
    }
    
    public var currentMinValue: V {
        return currentCompared
    }
}

public class MaxStack<V: Comparable>: ComparableStack<V> {
    public init() {
        super.init(comparator: { $0 > $1 })
    }
    
    public var currentMaxValue: V {
        return currentCompared
    }
}
