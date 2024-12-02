//
//  main.swift
//  Day1
//
//  Created by Mia Koring on 01.12.24.
//

import Foundation



func parse() -> ([Int], [Int]) {
    let lines = input.split(separator: "\n")
    var left: [Int] = []
    var right: [Int] = []
    _ = lines.map { line in
        let split = line.split(separator: " ")
        left.append(Int("\(split[0])") ?? 0)
        right.append(Int("\(split[1])") ?? 0)
    }
    return (left, right)
}

func main(_ isFirst: Bool = true) {
    var (left, right) = parse()
    
    var count = 0
    
    if isFirst {
        left.sort()
        right.sort()
        for i in 0..<left.count {
            count += abs(left[i] - right[i])
        }
    } else {
        let leftSet = Set(left)
        for leftNumber in leftSet {
            let amount = right.count(where: {$0 == leftNumber})
            count += leftNumber * amount
        }
    }
    print(count)
}

main(false)
