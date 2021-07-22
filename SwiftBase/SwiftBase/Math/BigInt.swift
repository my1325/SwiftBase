//
//  BigInt.swift
//  SwiftBase
//
//  Created by my on 2021/7/22.
//

import Foundation

public struct BigInt {
    
    private let bigNumber: [Int]
    
    private let isNegative: Bool
    
    public var description: String {
        var res = ""
        for val in bigNumber.reversed() {
            res.append(String(val))
        }
        return res
    }
    
    init(bigNumber: [Int], isNegative: Bool) {
        self.bigNumber = bigNumber
        self.isNegative = isNegative
    }
    
    public init(origin: String) {
        var value = origin
        if value.first == "-" {
            value.removeFirst()
            isNegative = true
        } else {
            isNegative = false
        }
        
        var numbers: [Int] = []
        for char in value.reversed() {
            guard let val = Int(String(char)) else { fatalError("can not format \(char) to number in \(origin)") }
            numbers.append(val)
        }
        bigNumber = numbers
    }
    
    public init(origin: Int64) {
        isNegative = origin < 0
        var value = abs(origin)
        var numbers: [Int] = []
        while value > 0 {
            let v = value % 10
            numbers.append(Int(v))
            value /= 10
        }
        bigNumber = numbers
    }
}

extension BigInt {
    public static func + (lhs: BigInt, rhs: BigInt) -> BigInt {
        if lhs.isNegative, !rhs.isNegative {
            return rhs - BigInt(bigNumber: lhs.bigNumber, isNegative: false)
        } else if !lhs.isNegative, rhs.isNegative {
            return lhs - BigInt(bigNumber: rhs.bigNumber, isNegative: false)
        } else if lhs.bigNumber.count < rhs.bigNumber.count {
            return rhs + lhs
        }
        
        let l = lhs.bigNumber
        let r = lhs.bigNumber
        var p: Int = 0
        
        var resInt: [Int] = []
        var i = 0
        while i < l.count {
            p += l[i]
            if i < r.count { p += r[i] }
            resInt.append(p % 10)
            p /= 10
            i += 1
        }
        
        if p > 0 { resInt.append(p) }
        return BigInt(bigNumber: resInt.reversed(), isNegative: lhs.isNegative)
    }
    
    public static func - (lhs: BigInt, rhs: BigInt) -> BigInt {
        if !lhs.isNegative, rhs.isNegative {
            return lhs + BigInt(bigNumber: rhs.bigNumber, isNegative: false)
        } else if lhs.isNegative, rhs.isNegative {
            return BigInt(bigNumber: rhs.bigNumber, isNegative: false) - BigInt(bigNumber: lhs.bigNumber, isNegative: false)
        } else if lhs.isNegative, !rhs.isNegative {
            return BigInt(bigNumber: (BigInt(bigNumber: lhs.bigNumber, isNegative: false) + rhs).bigNumber, isNegative: true)
        } else if lhs < rhs {
            return BigInt(bigNumber: (rhs - lhs).bigNumber, isNegative: true)
        }
        
        let l = lhs.bigNumber
        let r = rhs.bigNumber
        var p: Int = 0
        var resInt: [Int] = []
        
        var i = 0
        while i < r.count {
            p = l[i] - p
            p -= r[i]
            /// 借位减法，此时保证了l大于b，所以相减的时候肯定可以向前借位
            resInt.append((p + 10) % 10)
            if p < 0 { p = 1 }
            else { p = 0 }
            i += 1
        }
        /// 去除高位的0
        while resInt.count > 1, resInt.last == 0 { resInt.removeLast() }
        return BigInt(bigNumber: resInt, isNegative: false)
    }
    
    public static func * (lhs: BigInt, rhs: Int) -> BigInt {
        let isNegative = rhs < 0 && !lhs.isNegative || rhs > 0 && lhs.isNegative
        
        let l = lhs.bigNumber
        var resInt: [Int] = []
        var t = 0
        var i = 0
        while i < l.count || t > 0 {
            if i < l.count { t = l[i] * rhs }
            resInt.append(t % 10)
            t /= 10
            i += 1
        }
        return BigInt(bigNumber: resInt, isNegative: isNegative)
    }
    
    /// 返回商和余数
    public static func / (lhs: BigInt, rhs: Int) -> (BigInt, Int) {
        let isNegative = rhs < 0 && !lhs.isNegative || rhs > 0 && lhs.isNegative
        var resInt: [Int] = []
        let l = lhs.bigNumber
        var i = 0
        var c = l.count - 1
        
        while i >= 0 {
            c = c * 10 + l[i]
            resInt.append(c / rhs)
            c %= rhs
            i -= 1
        }
        
        resInt.reverse()
        while resInt.count > 1 && resInt.last == 0 { resInt.removeLast() }
        
        return (BigInt(bigNumber: resInt, isNegative: isNegative), c)
    }
}

extension BigInt: Comparable {
    
    public static func == (lhs: BigInt, rhs: BigInt) -> Bool {
        return lhs.description == rhs.description
    }
    
    public static func < (lhs: BigInt, rhs: BigInt) -> Bool {
        guard lhs.bigNumber.count >= rhs.bigNumber.count else { return true }
        for i in stride(from: rhs.bigNumber.count - 1, through: 0, by: -1) {
            if lhs.bigNumber[i] != rhs.bigNumber[i] {
                return lhs.bigNumber[i] < rhs.bigNumber[i]
            }
        }
        return false
    }
}
