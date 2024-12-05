//
//  main.swift
//  Day5
//
//  Created by Mia Koring on 05.12.24.
//

import Foundation


let sample = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

func parse(input: String) -> ([(Int, Int)], [[Int]]) {
    let parts = input.split(separator: "\n\n")
    let p1res = parts[0].split(separator: "\n").map { line in
        let split = line.split(separator: "|")
        return (Int(split[0]) ?? 0, Int(split[1]) ?? 0)
    }
    let p2res = parts[1].split(separator: "\n").map { line in
        line.split(separator: ",").map { Int($0) ?? 0}
    }
    return (p1res, p2res)
}

func main(input: String, isFirst: Bool = true) {
    let (rules, updates) = parse(input: input)
    var count = 0
    var unordered = [[Int]]()
    
    for update in updates {
        var visited = Set<Int>()
        visited.insert(update[0])
        var isValid = true
        for page in update.dropFirst() {
            let rules = rules.filter { ($0 == page || $1 == page) && update.contains($0) && update.contains($1) }
            var nextUpdate = false
            for rule in rules {
                if rule.1 == page && !visited.contains(rule.0) {
                    nextUpdate = true
                    break
                }
                if rule.0 == page && !update.suffix(update.count - 1 - (update.firstIndex(of: page) ?? 0)).contains(rule.1) {
                    nextUpdate = true
                    break
                }
            }
            if nextUpdate {
                isValid = false
                break
            } else {
                visited.insert(page)
            }
        }
        if isValid {
            count += update[update.count  / 2]
        } else if !isFirst {
            unordered.append(update)
        }
    }
    if isFirst {
        print(count)
        return
    }
    count = 0
    for toOrder in unordered {
        var relevantRules = [(Int, Int)]()
        for page in toOrder.dropFirst() {
            relevantRules.append(contentsOf: rules.filter { ($0 == page || $1 == page) && toOrder.contains($0) && toOrder.contains($1) })
        }
        let sorted = toOrder.sorted(by: { x, y in
            let currentRules = relevantRules.filter({$0 == x || $1 == x})
            var valid = [Bool]()
            for currentRule in currentRules {
                if currentRule.1 == x && currentRule.0 == y {
                    valid.append(false)
                    break
                }
                if currentRule.0 == x && currentRule.1 == y {
                    valid.append(true)
                    break
                }
            }
            return !valid.contains(false)
        })
        count += sorted[sorted.count  / 2]
    }
    print(count)
}


main(input: input, isFirst: false)
