//
//  main.swift
//  Day4
//
//  Created by Mia Koring on 04.12.24.
//

import Foundation

let sample = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

func parse(input: String) -> [[String]] {
    input.split(separator: "\n").map({$0.map { char in
        String(char)
    }})
}

func main(input: String, isFirst: Bool = true) {
    let parsed = parse(input: input)
    
    let indices = indices(input: parsed, filter: isFirst ? "X": "A")
    var count = 0
    if isFirst {
        for index in indices {
            if index.0 > 2 {
                if "X\(parsed[index.1][index.0 - 1])\(parsed[index.1][index.0 - 2])\(parsed[index.1][index.0 - 3])" == "XMAS" { count += 1 } // left
                if index.1 > 2 && "X\(parsed[index.1 - 1][index.0 - 1])\(parsed[index.1 - 2][index.0 - 2])\(parsed[index.1 - 3][index.0 - 3])" == "XMAS" { count += 1 }  //topLeft
                if index.1 < parsed.count - 3 && "X\(parsed[index.1 + 1][index.0 - 1])\(parsed[index.1 + 2][index.0 - 2])\(parsed[index.1 + 3][index.0 - 3])" == "XMAS" { count += 1 }  //bottomLeft
            }
            if index.1 < parsed.count - 3 && "X\(parsed[index.1 + 1][index.0])\(parsed[index.1 + 2][index.0])\(parsed[index.1 + 3][index.0])" == "XMAS" { count += 1 } //top-bottom
            if index.1 > 2  && "X\(parsed[index.1 - 1][index.0])\(parsed[index.1 - 2][index.0])\(parsed[index.1 - 3][index.0])" == "XMAS" { count += 1 } //bottom-top
            if index.0 < parsed[0].count - 3 {
                if "X\(parsed[index.1][index.0 + 1])\(parsed[index.1][index.0 + 2])\(parsed[index.1][index.0 + 3])" == "XMAS" { count += 1 } // right
                if index.1 > 2 && "X\(parsed[index.1 - 1][index.0 + 1])\(parsed[index.1 - 2][index.0 + 2])\(parsed[index.1 - 3][index.0 + 3])" == "XMAS" { count += 1 }  //topRight
                if index.1 < parsed.count - 3 && "X\(parsed[index.1 + 1][index.0 + 1])\(parsed[index.1 + 2][index.0 + 2])\(parsed[index.1 + 3][index.0 + 3])" == "XMAS" { count += 1 }  //bottomRight
            }
        }
        print(count)
        return
    }
    let filter = ["SAM", "MAS"]
    for index in indices {
        if !(1..<parsed[0].count - 1).contains(index.0 ) || !(1..<parsed.count - 1).contains(index.1) { continue }
        if filter.contains("\(parsed[index.1 - 1][index.0 - 1])A\(parsed[index.1 + 1][index.0 + 1])") &&
            filter.contains("\(parsed[index.1 + 1][index.0 - 1])A\(parsed[index.1 - 1][index.0 + 1])")
        {
            count += 1
        }
    }
    print(count)
}

func indices(input: [[String]], filter: String) -> [(Int, Int)] {
    var results = [(Int, Int)]()
    for i in 0..<input.count {
        let ranges = input[i].indices(of: filter).ranges
        for range in ranges {
            for x in range {
                results.append((x, i))
            }
        }
    }
    return results
}

main(input: input, isFirst: false)
