//
//  main.swift
//  Day7
//
//  Created by Mia Koring on 08.12.24.
//

import Foundation

let sample = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""

func fastGenerateOperatorStrings(bitLength: Int, isFirst: Bool) -> [[String]] {
    let maxNumber = isFirst ? (1 << bitLength) : Int(pow(3.0, Double(bitLength)))
    var operatorStrings = [[String]]()
    operatorStrings.reserveCapacity(maxNumber)
    
    for number in 0..<maxNumber {
        var operatorString = [String]()
        operatorString.reserveCapacity(bitLength)
        
        var remainingNumber = number
        for _ in 0..<bitLength {
            let digit = remainingNumber % (isFirst ? 2 : 3)
            
            switch digit {
            case 0 where isFirst:
                operatorString.append("+")
            case 1 where isFirst:
                operatorString.append("*")
            case 0 where !isFirst:
                operatorString.append("+")
            case 1 where !isFirst:
                operatorString.append("*")
            case 2 where !isFirst:
                operatorString.append("|")
            default:
                fatalError("Unexpected digit")
            }
            
            remainingNumber /= (isFirst ? 2 : 3)
        }
        
        operatorStrings.append(operatorString.reversed())
    }
    
    return operatorStrings
}

func parse(_ input: String) -> [(Int, [Int])] {
    let lines = input.split(separator: "\n")
    return lines.map { line in
        let parts = line.split(separator: ":")
        let values = parts[1].split(separator: " ").compactMap({Int($0)})
        return (Int(parts[0]) ?? 0, values)
    }
}

func operators(_ bitlength: Int, isFirst: Bool) -> [Int: [[String]]] {
    var maps = [Int: [[String]]]()
    let all = fastGenerateOperatorStrings(bitLength: bitlength, isFirst: isFirst)
    for i in 1...bitlength {
        maps[i] = all.filter({
            !$0.prefix(bitlength - i).contains("*") && !$0.prefix(bitlength - i).contains("|")
        }).map {
            $0.suffix(i)
        }
    }
    return maps
}

func main(_ input: String, isFirst: Bool = true) {
    let parsed = parse(input)
    let maxOperators = parsed.map { $0.1.count - 1}.max() ?? 0
    let maps = operators(maxOperators, isFirst: isFirst)
    
    var sum = 0
    
    for row in parsed {
        for opStr in maps[row.1.count - 1] ?? [] {
            let currentNumbers = row.1
            let operations = opStr
            var calcVal = currentNumbers[0]
            for i in 1..<currentNumbers.count {
                if operations[i - 1] == "*" {
                    calcVal *= currentNumbers[i]
                } else if operations[i - 1] == "+" {
                    calcVal += currentNumbers[i]
                } else {
                    calcVal = Int("\(calcVal)\(currentNumbers[i])") ?? 0
                }
            }
            if calcVal == row.0 {
                sum += row.0
                break
            }
        }
    }
    print(sum)
}

func partTwoMultithreaded(_ input: String) {
    let time = DispatchTime.now().uptimeNanoseconds
    let parsed = parse(input)
    let maxOperators = parsed.map { $0.1.count - 1}.max() ?? 0
    var maps = operators(maxOperators, isFirst: false)
    
    let group = DispatchGroup()
    let resultQueue = DispatchQueue(label: "result.queue")
    var sums = [Int]()
    
    for z in 0..<5 {
        group.enter()
        let toWorkThrough = parsed[z * 170...z * 170 + 169]
        DispatchQueue.global(qos: .userInitiated).async {
            var sum = 0
            for row in toWorkThrough {
                for opStr in maps[row.1.count - 1] ?? [] {
                    let currentNumbers = row.1
                    let operations = opStr
                    var calcVal = currentNumbers[0]
                    for i in 1..<currentNumbers.count {
                        if operations[i - 1] == "*" {
                            calcVal *= currentNumbers[i]
                        } else if operations[i - 1] == "+" {
                            calcVal += currentNumbers[i]
                        } else {
                            calcVal = Int("\(calcVal)\(currentNumbers[i])") ?? 0
                        }
                    }
                    if calcVal == row.0 {
                        sum += row.0
                        break
                    }
                }
            }
            resultQueue.async {
                sums.append(sum)
                group.leave()
            }
        }
        
    }
    group.notify(queue: resultQueue) {
        print("Analyse abgeschlossen. Ergebnis:", sums.reduce(0, {$0 + $1}))
        print(Double(DispatchTime.now().uptimeNanoseconds - time) / 1000000000)
    }
}
/*
let time = DispatchTime.now().uptimeNanoseconds
main(input, isFirst: false)
print(Double(DispatchTime.now().uptimeNanoseconds - time) / 1000000000)
*/
partTwoMultithreaded(input)
dispatchMain()

