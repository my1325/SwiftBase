//
//  MathUtils.swift
//  SwiftBase
//
//  Created by my on 2021/7/15.
//

import Foundation

public class Math {
    
    /// 判断一个数是否是质数
    public static func isPrime(_ x: Int) -> Bool {
        guard x > 1 else { return false }
        var i = 2
        while i <= x / i {
            if x % i == 0 { return false }
            i += 1
        }
        return true
    }
    
    /// 分解质因数(底数，指数 eg: 12 = [(2, 2), (3, 1)])
    public static func devidePrime(_ x: Int) -> [(Int, Int)] {
        guard x > 1 else { return [] }
        var n = x
        var res: [(Int, Int)] = []
        var i = 2
        while i <= n / i {
            var s = 0
            while n % i == 0 {
                n /= i
                s += 1
            }
            if s > 0 { res.append((i, s)) }
            i += 1
        }
        
        if n > 1 { res.append((n, 1)) }
        return res
    }
    
    /// 筛选2-n的所有质数(10^7次方的数用方法2)
    public static func numberOfPrime1(_ x: Int) -> [Int] {
        var b: [Bool] = Array(repeating: false, count: x + 1)
        var res: [Int] = []
        
        for i in 2 ... x {
            if !b[i] {
                res.append(i)
                for j in stride(from: i + i, through: x, by: i) {
                    b[j] = true
                }
            }
        }
        return res
    }
    
    /// 筛选2-n的所有质数
    public static func numberOfPrime2(_ x: Int) -> [Int] {
        var b: [Bool] = Array(repeating: false, count: x + 1)
        var res: [Int] = []
        
        for i in 2 ... x {
            if !b[i] { res.append(i) }
            var j = 0
            while res[j] <= x /  i {
                b[res[j] * i] = true
                if i % res[j] == 0 { break }
                j += 1
            }
        }
        return res
    }
}
