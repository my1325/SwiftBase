//
//  MathUtils.swift
//  SwiftBase
//
//  Created by my on 2021/7/15.
//

import Foundation

public class Math {
    
    /// 判断一个数是否是质数,时间复杂度sqrt(n)
    public static func isPrime(_ x: Int) -> Bool {
        guard x > 1 else { return false }
        var i = 2
        while i <= x / i {
            if x % i == 0 { return false }
            i += 1
        }
        return true
    }
    
    /// 分解质因数(底数，指数 eg: 12 = [(2, 2), (3, 1)])，试除法，时间复杂度sqrt(n)
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
    
    /// 筛选2-n的所有质数(10^7次方的数用方法2)，
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
    
    /// 筛选2-n的所有质数，线性筛选时间复杂度为O(n)
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
    
    /// 求一个数的所有约数(没有排序)
    public static func divisors(_ x: Int) -> [Int] {
        var res: [Int] = []
        var i = 1
        while i <= x / i {
            if x % i == 0 {
                res.append(i)
                if i != x / i {
                    res.append(x / i)
                }
            }
            i += 1
        }
        return res
    }
    
    /// 求一组数的乘积的约数个数(结果会取模10的9次方+7)，主要针对数特别大的时候做分解
    /// D = p1^a1 * p2 ^ a2 * … pk ^ ak
    /// 对于D的任意一个约数d则有
    /// d = p1 ^ b1 * p2 ^ b2 * pk ^ bk 其中 0 <= bi <= ai
    /// 也就是说，对于D的任意约数从是p1中选出0 ~ a1个，p2中选出0 ~ a2个，… pk中选出
    /// 0 ~ ak个的排列组合，如果是算出D的所有约数即(1+a1) * (1 + a2) * … * (1 + ak)
    public static func numberOfDevisors(_ x: [Int]) -> Int {
        var p: [Int: Int] = [:]
        
        for n in x {
            var _n = n
            var i = 2
            while i <= _n / i {
                while _n % i == 0 {
                    _n /= i
                    p[i] = (p[i] ?? 0) + 1
                }
                i += 1
            }
            
            if _n  > 1 { p[_n] = (p[_n] ?? 0) + 1 }
        }
        
        var res = 1
        for (_, v) in p {
            res = res * (v + 1) % 1000000007
        }
        return res
    }
    
    /// 求一组数的乘积的约数之和(结果会取模10的9次方+7)，主要针对数特别大的时候做分解
    /// 一个数的约数之和，基于个数的推论对于D的约数之和为
    /// （p1^0 + p1^1 + … + p1^a1） * …  * (pk^0 + pk ^ 1 + … + pk ^ ak)
    public static func sumOfDivisors(_ x: [Int]) -> Int {
        var p: [Int: Int] = [:]
        
        for n in x {
            var _n = n
            
            var i = 2
            while i <= _n / i {
                while _n % i == 0 {
                    _n /= i
                    p[i] = (p[i] ?? 0) + 1
                }
                i += 1
            }
            if _n > 1 { p[_n] = (p[_n] ?? 0) + 1 }
        }
        
        var res = 1
        for (k, a) in p {
            var _a = a
            var t = 1
            while (_a > 0) {
                t = (t * k + 1) % 1000000007
                _a -= 1
            }
            res = res * t % 1000000007
        }
        return res
    }
    
    /// 求两个数的最大公约数(欧几里得/辗转相除)
    public static func gcd(_ a: Int, _ b: Int) -> Int {
        return b > 0 ? gcd(b, a % b) : a
    }
    
    /// 一个数n的欧拉函数(1-n-1中与n互质的数的个数)
    /// 欧拉函数 phi[n] = n * (1 - 1 / p1) * (1 - 1 /p2) * … * (1 - 1 / pk), p 为n的质因子, 表示从1-n中，与n互质的数的个数
    public static func euler(_ x: Int) -> Int {
        var n = x
        var i = 2
        var res: Int = x
        while i <= n / i  {
            if n % i == 0 {
                res = res / i * (i - 1)
                while n % i == 0 {
                    n /= i
                }
            }
            i += 1
        }
        
        if x > 1 { res = res / x * (x - 1) }
        return res
    }
    
    /// 求1-n所有数的欧拉函数
    /// 1.如果n为质数，则n的欧拉函数为n - 1
    /// 2.一个数i与一个质数p的乘积的欧拉函数
    ///     1)、如果p也是i的质数，则phi[p * i] = p * phi[i],
    ///     2)、如果p不是i的质数，则phi[p * j] = p * phi[i] * (1 - 1/p) = (p - 1) * phi[i]
    public static func eulers(of x: Int) -> [Int] {
        var res: [Int] = Array(repeating: 1, count: x + 1)
        var t: [Bool] = Array(repeating: false, count: x + 1)
        var p: [Int] = []
        
        for i in 2 ... x {
            if !t[i] {
                p.append(i)
                res[i] = i - 1
            }
            
            var j = 0
            while p[j] <= x / i {
                t[p[j] * i] = true
                if i % p[j] == 0 {
                    res[p[j] * i] = res[i] * p[j]
                    break
                }
                res[p[j] * i] = res[i] * (p[j] - 1)
                j += 1
            }
        }
        if !res.isEmpty {
            res.removeFirst()
        }
        return res
    }
    
    /// 快速幂
    /// a: 底数
    /// k: 指数
    /// m: 需要模上的数，由于数比较大可能溢出，所以需要模上一个数(a: 3, k: 31 是 m: Int64.Max能计算的最大值)
    static func qmi(_ a: Int64, _ k: Int64, _ m: Int64 = .max) -> Int64 {
        var res: Int64 = 1
        var n = k
        var x = a
        while n > 0 {
            if (n & 1) == 1 { res = res * x % m }
            n >>= 1
            x = x * x % m
        }
        return res
    }
}
