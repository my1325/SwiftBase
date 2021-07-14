//
//  PriorityQueue.swift
//  SwiftBase
//
//  Created by my on 2021/7/14.
//

import Foundation

/// 优先级队列(小顶堆)
public class PriorityQueue<T> {
    public typealias Comparator = (T, T) -> Bool
    
    private var size: Int = 0
    private var heap: [T] = []
    private let comparator: Comparator
    public init(comparator: @escaping Comparator) {
        self.comparator = comparator
    }
    
    public var description: String {
        return String(format: "[%@]", heap.map({ "\($0)" }).joined(separator: ","))
    }
    
    public var count: Int {
        return size
    }

    /// 入队
    public func offer(_ x: T) {
        heap.append(x)
        up(size, size + 1)
        size += 1
    }
    
    /// 出队
    @discardableResult
    public func poll() -> T {
        guard size > 0 else { fatalError("empty queue") }
        let res = heap.removeFirst()
        size -= 1

        return res
    }
    
    /// 顶部元素
    public func peek() -> T {
        guard size > 0 else { fatalError("empty queue") }
        return heap[0]
    }
        
// MARK: - heap method
    private func down(_ k: Int, _ n: Int) {
        var u = k
        if k * 2 + 1 < n && comparator(heap[u], heap[k * 2 + 1]) { u  = k * 2 + 1 }
        if k * 2 + 2 < n && comparator(heap[u], heap[k * 2 + 2]) { u = k * 2 + 2 }
        
        if u != k {
            heap.swapAt(u, k)
            down(u, n)
        }
    }
    
    private func up(_ k: Int, _ n: Int) {
        guard k > 0 else { return }
        
        let p = (k - 1) / 2
        var u = p
        if comparator(heap[u], heap[p * 2 + 1]) { u = p * 2 + 1 }
        if p * 2 + 2 < n && comparator(heap[u], heap[p * 2 + 2]) { u = p * 2 + 2 }
        
        if u != p {
            heap.swapAt(u, p)
            up(p, n)
        }
    }
    
    /// 原地建堆
    private func makeHeap() {
        for i in stride(from: size / 2, through: 0, by: -1) {
            down(i, size)
        }
    }
}

extension PriorityQueue where T: Comparable {
    
    public convenience init() {
        self.init(comparator: { $0 > $1 })
    }
    
    public convenience init(origin: [T]) {
        self.init()
        self.heap.append(contentsOf: origin)
        self.size = origin.count
        self.makeHeap()
    }
}
