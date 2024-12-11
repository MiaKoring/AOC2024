//
//  main.swift
//  Day9
//
//  Created by Mia Koring on 11.12.24.
//

import Foundation

let sample = "2333133121414131402"

func parse(_ input: String) -> [Int] {
    input.compactMap { Int("\($0)") }
}

func main(_ input: String, isFirst: Bool = true) {
    if isFirst {
        solveFirst(input: input)
        return
    }
    solveSecond(input: input)
}

func solveSecond(input: String) {
    let parsed = parse(input)
    
    var map = [(String, Int)]()
    for i in 0..<parsed.count {
        let element = i % 2 == 0 ? "\(i / 2)" : "."
        map.insert((element, parsed[i]), at: 0)
    }
    var count = 0
    for item in map.filter({ $0.0 != "." }) {
        guard let index = map.firstIndex(where: {$0.1 >= item.1 && $0.0 == "."}) else {
            continue
        }
        map[index].1 = map[index].1 - item.1
        map.insert(item, at: index)
        guard let itemIndex = map.lastIndex(where: {$0.0 == item.0}) else {
            print("fehler 2")
            return
        }
        map[itemIndex].0 = "."
    }
    
    var previous = 0
    for item in map {
        let intVal = Int(item.0) ?? 0
        for _ in 0..<item.1 {
            count += intVal * previous
            previous += 1
        }
    }
    print(count)
}

func solveFirst(input: String) {
    let parsed = parse(input)
    
    var map = [String]()
    for i in 0..<parsed.count {
        let element = i % 2 == 0 ? "\(i / 2)" : "."
        map.append(contentsOf: Array(repeating: element, count: parsed[i]))
    }
    
    var count = 0
    
    for i in 0..<map.count {
        if map[i] != "." {
            count += i * (Int(map[i]) ?? 0)
        } else {
            guard let numIndex = map.lastIndex(where: {$0 != "."}) else { return }
            if numIndex <= i {
                print(count)
                return
            }
            count += i * (Int(map[numIndex]) ?? 0)
            map[numIndex] = "."
        }
    }
}

let time = DispatchTime.now().uptimeNanoseconds
main(input, isFirst: false)
let end = Double(DispatchTime.now().uptimeNanoseconds - time) / 1000000000.0
print(end)
