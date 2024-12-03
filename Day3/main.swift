//
//  main.swift
//  Day3
//
//  Created by Mia Koring on 03.12.24.
//

import Foundation

let sampleInput = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
let sampleInput2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

func main(_ input: String, isFirst: Bool = true) {
    if isFirst {
        print(firstMain(input))
    } else {
        let matches = input.matches(of: /(?:mul\((\d{1,3},\d{1,3})\)|don't\(\)|do\(\))/)
        var mulEnabled = true
        var result = 0
        for match in matches {
            if match.output.0 == "do()" { mulEnabled = true }
            else if match.output.0 == "don't()" { mulEnabled = false }
            else {
                if !mulEnabled { continue }
                result += match.output.1?.split(separator: ",").map {String($0)}.compactMap {Int($0)}.reduce(1, {$0 * $1}) ?? 0
            }
        }
        print(result)
    }
}
func firstMain(_ input: String) -> Int {
    return input.matches(of: /mul\((\d{1,3},\d{1,3})\)/).map { $0.output.1.split(separator: ",").map {String($0)}.compactMap {Int($0)}.reduce(1, {$0 * $1})}.reduce(0, {$0 + $1})
}
