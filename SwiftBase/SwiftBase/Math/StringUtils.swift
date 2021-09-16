//
//  StringUtils.swift
//  SwiftBase
//
//  Created by my on 2021/9/16.
//

import Foundation

fileprivate let P: Double = 131
fileprivate let mod: Double = 18446744073709551616
public class StringUtils {
    
    private let charctars: [Character]
    
    private var p: [UInt64]
    
    private var h: [UInt64]
    
    public let origin: String
    
    public init(_ string: String) {
        origin = string
        
        var chars: [Character] = []
        for char in string { chars.append(char) }
        
        charctars = chars
        
        /// 字符串hash
        p = Array(repeating: 1, count: string.count + 10)
        h = Array(repeating: 0, count: string.count + 10)

        for i in 1 ... string.count {
            let pvalue: Double = (Double(p[i - 1]) * P).truncatingRemainder(dividingBy: mod)
            p[i] = UInt64(pvalue)
            
            let hvalue: Double = (Double(h[i - 1]) * P + Double(chars[i - 1].asciiValue ?? 0)).truncatingRemainder(dividingBy: mod)
            
            h[i] = UInt64(hvalue)
        }
    }
    
    private func get(_ l: Int, _ r: Int) -> UInt64 {
        return h[r] - h[l - 1] * p[r - l + 1]
    }
    
    /// 判断两个子字符串是否相等
    public func equal(_ range1: ClosedRange<Int>, _ range2: ClosedRange<Int>) -> Bool {
        let l1 = range1.lowerBound, r1 = range1.upperBound
        let l2 = range2.lowerBound, r2 = range2.upperBound
        return get(l1, r1) == get(l2, r2)
    }
    
    /// KMP查找子串
    public func contains(_ subString: String) -> Bool {
        var subChars: [Character] = []
        for char in subString { subChars.append(char) }
        
        var next: [Int] = Array(repeating: 0, count: subString.count)
        var i = 1, j = 0
        while i < subChars.count {
            while j > 0 && subChars[i] != subChars[j] { j = next[j - 1] }
            if subChars[i] == subChars[j] { j += 1 }
            next[i] = j
            i += 1
        }
        
        i = 0; j = 0
        while i < charctars.count {
            while j > 0 && charctars[i] != subChars[i] { j = next[i - 1] }
            if charctars[i] == subChars[j] { j += 1 }
            if j == subChars.count {
                return true
            }
            i += 1
        }
        return false
    }
    
    /// KMP查找子串
    public func fistIndex(of subString: String) -> String.Index? {
        var subChars: [Character] = []
        for char in subString { subChars.append(char) }
        
        var next: [Int] = Array(repeating: 0, count: subString.count)
        var i = 1, j = 0
        while i < subChars.count {
            while j > 0 && subChars[i] != subChars[j] { j = next[j - 1] }
            if subChars[i] == subChars[j] { j += 1 }
            next[i] = j
            i += 1
        }
        
        i = 0; j = 0
        while i < charctars.count {
            while j > 0 && charctars[i] != subChars[i] { j = next[i - 1] }
            if charctars[i] == subChars[j] { j += 1 }
            if j == subChars.count {
                let index = origin.index(origin.startIndex, offsetBy: i - subChars.count + 1)
                return index
            }
            i += 1
        }
        return nil
    }
}
