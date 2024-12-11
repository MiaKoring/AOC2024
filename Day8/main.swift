//
//  main.swift
//  Day8
//
//  Created by Mia Koring on 08.12.24.
//

import Foundation

let sample = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""

let antinodeMap = """
......#....#
...#....0...
....#0....#.
..#....0....
....0....#..
.#....A.....
...#........
#......#....
........A...
.........A..
..........#.
..........#.
"""

func parse(input: String) -> [[String]] {
    input.split(separator: "\n").map { line in
        line.map { String($0) }
    }
}

func main(input: String, isFirst: Bool = true) {
    let parsed = parse(input: input)
    let uniqueChars = Set(input.replacingOccurrences(of: "\n", with: "").map{String($0)})
    
    var positions = [String: [Coords]]()
    
    for y in 0..<parsed.count {
        for x in 0..<parsed[0].count {
            let char = parsed[y][x]
            if char == "." { continue }
            if let _ = positions[char] {
                positions[char]?.append(Coords(x: x, y: y))
            } else {
                positions[char] = [Coords(x: x, y: y)]
            }
        }
    }
    
    var antinodePositions = [Coords]()
    let antinodeParsed = parse(input: antinodeMap)
    for y in 0..<antinodeParsed.count {
        for x in 0..<antinodeParsed[0].count {
            let char = antinodeParsed[y][x]
            if char != "#" { continue }
            antinodePositions.append(Coords(x: x, y: y))
        }
    }
    
    var pairs = [(Coords, Coords)]()
    
    for value in positions.values {
        pairs.append(contentsOf: generatePairs(value))
    }
    
    var antinodes = Set<Coords>()
    
    
    for pair in pairs {
        let dx = pair.1.x - pair.0.x
        let dy = pair.1.y - pair.0.y
        antinodes.insert(pair.0)
        antinodes.insert(pair.1)
        
        if isFirst {
            antinodes.insert(Coords(
                x: pair.0.x - dx,
                y: pair.0.y - dy
            ))
            
            antinodes.insert(Coords(
                x: pair.1.x + dx,
                y: pair.1.y + dy
            ))
            continue
        }
        var shouldBreak = false
        var count = 1
        while !shouldBreak {
            let node1 = Coords(
                x: pair.0.x - dx * count,
                y: pair.0.y - dy * count
            )
            
            let node2 = Coords(
                x: pair.1.x + dx * count,
                y: pair.1.y + dy * count
            )
            
            antinodes.insert(node1)
            
            antinodes.insert(node2)
            
            if [node1, node2].count(where: {
                $0.x >= 0 && $0.x < parsed[0].count && $0.y >= 0 && $0.y < parsed.count
            }) == 0 {
                shouldBreak = true
            }
            count += 1
        }
    }
    
    let filtered = antinodes.filter {
        $0.x >= 0 && $0.x < parsed[0].count && $0.y >= 0 && $0.y < parsed.count
    }
    print(filtered.count)
}


func generatePairs<T>(_ array: [T]) -> [(T, T)] {
    let count = array.count
    var pairs = [(T, T)]()
    pairs.reserveCapacity(count * (count - 1) / 2)
    
    for i in 0..<count {
        for j in (i+1)..<count {
            pairs.append((array[i], array[j]))
        }
    }
    
    return pairs
}

struct Coords: Hashable {
    let x: Int
    let y: Int
}

let time = DispatchTime.now().uptimeNanoseconds
main(input: input, isFirst: false)
let end = Double(DispatchTime.now().uptimeNanoseconds - time) / 1000000000.0
print(end)
