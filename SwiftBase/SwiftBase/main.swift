//
//  main.swift
//  SwiftBase
//
//  Created by my on 2021/7/13.
//

import Foundation

func println() {
    print("\n")
}


func testLinkedList() {
    let list = LinkedList(head: 0)
    list.append(1)
    print(list.description)
    list.insert(to: 1, val: 2)
    print(list.description)
    list.insert(to: 1, val: 3)
    print(list.description)
    list.remove(1)
    print(list.description)
    list.append(4)
    print(list.description)
    list.remove(2)
    print(list.description)
    list.insert(to: 2, val: 5)
    print(list.description)
}

func testPriorityQueue() {
    let q = PriorityQueue<Int>(origin: [9,2,1,4,5,6,7,8,10,39,1])
    print(q.description)
    print(q.peek())
    println()
    print(q.poll())
    println()
    print(q.description)
    print(q.peek())
    println()
    print(q.poll())
    println()
    print(q.description)
    q.offer(0)
    print(q.peek())
    println()
    q.offer(20)
    q.offer(22)
    print(q.description)
    print(q.peek())
}

func testHashLinkedSet() {
    let set = HashLinkedSet<Int>()
    set.insert(1)
    set.insert(2)
    set.insert(3)
    print(set.description)
    set.remove(2)
    print(set.description)
    print(set.contains(2))
    print(set.contains(1))
}

testHashLinkedSet()
