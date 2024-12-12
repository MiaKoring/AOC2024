//
//  main.swift
//  Day10
//
//  Created by Mia Koring on 11.12.24.
//

import Foundation

let sample = """
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
"""

struct Coords: Hashable {
    let x: Int
    let y: Int
}

func parse(input: String) -> ([[Int]], [Coords]) {
    let parsed = input.split(separator: "\n").map { line in
        line.compactMap { Int(String($0)) }
    }
    var startPositions = [Coords]()
    for (y, row) in parsed.enumerated() {
        for (x, value) in row.enumerated() {
            if value == 0 {
                startPositions.append(Coords(x: x, y: y))
            }
        }
    }
    return (parsed, startPositions)
}

func main(input: String, isFirst: Bool = true) {
    let (parsed, startPositions) = parse(input: input)
       
    var count = 0
    if isFirst {
        for start in startPositions {
            let peaks = findPeaks(start: start, parsed: parsed)
            count += peaks.count
        }
        print("\(count)")
        return
    }
    
    for start in startPositions {
        let distinctTrails = findTrails(start: start, parsed: parsed)
        count += distinctTrails
    }
    print(count)
}

func findTrails(start: Coords, parsed: [[Int]]) -> Int {
    var visited = Set<Coords>()
    var routes = 0
    
    func dfs(pos: Coords, prevHeight: Int) {
        guard pos.x >= 0 && pos.x < parsed[0].count &&
                pos.y >= 0 && pos.y < parsed.count else { return }
        let currentHeight = parsed[pos.y][pos.x]
        
        guard currentHeight == prevHeight + 1 else { return }
        
        if !visited.contains(pos) {
            if currentHeight == 9 {
                routes += 1
            }
            
            guard !visited.contains(pos) else { return }
            visited.insert(pos)
            
            dfs(pos: Coords(x: pos.x + 1, y: pos.y), prevHeight: currentHeight)
            dfs(pos: Coords(x: pos.x - 1, y: pos.y), prevHeight: currentHeight)
            dfs(pos: Coords(x: pos.x, y: pos.y + 1), prevHeight: currentHeight)
            dfs(pos: Coords(x: pos.x, y: pos.y - 1), prevHeight: currentHeight)
            
            visited.remove(pos)
        }
    }
    
    dfs(pos: start, prevHeight: -1)
    return routes
}

func findPeaks(start: Coords, parsed: [[Int]]) -> Set<Coords> {
    var visited = Set<Coords>()
    var peak = Set<Coords>()
    
    func dfs(pos: Coords, prevHeight: Int) {
        guard pos.x >= 0 && pos.x < parsed[0].count &&
                pos.y >= 0 && pos.y < parsed.count else { return }
        let currentHeight = parsed[pos.y][pos.x]
        
        guard currentHeight == prevHeight + 1 else { return }
        
        if !visited.contains(pos) {
            visited.insert(pos)
            
            if currentHeight == 9 {
                peak.insert(pos)
            }
            
            dfs(pos: Coords(x: pos.x + 1, y: pos.y), prevHeight: currentHeight)
            dfs(pos: Coords(x: pos.x - 1, y: pos.y), prevHeight: currentHeight)
            dfs(pos: Coords(x: pos.x, y: pos.y + 1), prevHeight: currentHeight)
            dfs(pos: Coords(x: pos.x, y: pos.y - 1), prevHeight: currentHeight)
        }
    }
    
    dfs(pos: start, prevHeight: -1)
    return peak
}

let time = DispatchTime.now().uptimeNanoseconds
main(input: input, isFirst: true)
let end = Double(DispatchTime.now().uptimeNanoseconds - time) / 1000000000.0
print(end)
