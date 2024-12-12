//
//  main.swift
//  Day11
//
//  Created by Mia Koring on 12.12.24.
//

import Foundation

let sample = """
125 17
"""

func parse(_ input: String) -> [Int] {
    return input.split(separator: " ").compactMap { Int($0) }
}

func main(_ input: String) {
    let parsed = parse(input)
    
    var stones = [Int: Int]()
    for item in parsed {
        stones[item] = 1
    }
    
    for _ in 0..<75 {
        var new = [Int: Int]()
        for key in stones.keys {
            if key == 0 {
                new[1] = (new[1] ?? 0) + (stones[0] ?? 0)
            } else if "\(key)".count % 2 == 0 {
                guard let amount = stones[key] else { continue }
                let str = "\(key)"
                if let left = Int(str.prefix(str.count / 2)), let right = Int(str.suffix(str.count / 2)) {
                    new[left] = (new[left] ?? 0) + amount
                    new[right] = (new[right] ?? 0) + amount
                }
            } else {
                new[key * 2024] = (new[key * 2024] ?? 0) + (stones[key] ?? 0)
            }
        }
        stones = new
    }
    
    print(stones.values.reduce(0, {$0 + $1}))
}

let time = DispatchTime.now().uptimeNanoseconds
main(input)
let end = Double(DispatchTime.now().uptimeNanoseconds - time) / 1000000000.0
print(end)
