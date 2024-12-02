//
//  main.swift
//  Day 2
//
//  Created by Mia Koring on 02.12.24.
//

import Foundation

func parse(_ input: String)-> [[Int]] {
    let lines = input.split(separator: "\n")
    return lines.map({ line in
        line.split(separator: " ").map({
            num in
            Int(num) ?? 0
        })
    })
}

func main(isFirst: Bool = true, input: String) {
    let parsed = parse(input)
    
    var count = 0
    for group in parsed {
        if group.sorted() != group && group.sorted(by: {$0 > $1}) != group {
            if isFirst { continue }
            if checkDampener(group) {
                count += 1
            }
            continue
        }
        
        if isValidSequence(group) {
            count += 1
        } else if !isFirst && checkDampener(group) {
            count += 1
        }
    }
    print(count)
}

func checkDampener(_ group: [Int]) -> Bool {
    for i in 0..<group.count {
        var newGroup = group
        newGroup.remove(at: i)
        if newGroup == newGroup.sorted() || newGroup == newGroup.sorted(by: >) {
           if isValidSequence(newGroup) {
               return true
           }
       }
    }
    return false
}

func isValidSequence(_ group: [Int]) -> Bool {
    for i in 1..<group.count {
        if !(1...3).contains(abs(group[i - 1] - group[i])) {
            return false
        }
    }
    return true
}

main(isFirst: false, input: input)

