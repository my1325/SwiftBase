//
//  main.swift
//  SwiftBase
//
//  Created by my on 2021/7/13.
//

import Foundation


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
