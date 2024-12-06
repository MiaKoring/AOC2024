//
//  main.swift
//  Day6
//
//  Created by Mia Koring on 06.12.24.
//

import Foundation

let sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

struct Position: Hashable {
    let x: Int
    let y: Int
}

struct PositionAdvanced: Hashable {
    let x: Int
    let y: Int
    let xDirection: Int
    let yDirection: Int
}

func parse(input: String) -> [[String]] {
    return input.split(separator: "\n").map{ String($0).enumerated().map { x, y in
        "\(y)"
    }}
}

func main(input: String, isFirst: Bool = true) {
    let parsed = parse(input: input)
    if isFirst {
        print(count(parsed).0.count)
        return
    }
    let y = parsed.firstIndex(where: {$0.contains("^")}) ?? 0
    let x = parsed[y].firstIndex(of: "^") ?? 0
    var visited = count(parsed).0
    visited.remove(Position(x: x, y: y))
    var res = 0
    for vis in visited {
        var mutable = parsed
        mutable[vis.y][vis.x] = "#"
        if count(mutable).1 {
            res += 1
        }
    }
    print(res)
    
}

func count(_ parsed: [[String]]) -> (Set<Position>, Bool) {
    var visited = Set<Position>()
    var visitedWithDirection = Set<PositionAdvanced>()
    var wouldLeave = false
    
    let y = parsed.firstIndex(where: {$0.contains("^")}) ?? 0
    let x = parsed[y].firstIndex(of: "^") ?? 0
    
    var xDirection = 0
    var yDirection = -1
    
    var currentPosition = Position(x: x, y: y)
    
    visited.insert(currentPosition)
    visitedWithDirection.insert(PositionAdvanced(x: x, y: y, xDirection: 0, yDirection: -1))
    
    repeat {
        let nextX = currentPosition.x + xDirection
        let nextY = currentPosition.y + yDirection
        if nextX >= parsed[0].count || nextY >= parsed.count || nextX < 0 || nextY < 0 {
            wouldLeave = true
            continue
        }
        if parsed[nextY][nextX] == "#" {
            if abs(yDirection) == 1 {
                xDirection = -1 * yDirection
                yDirection = 0
            } else {
                yDirection = xDirection
                xDirection = 0
            }
            continue
        }
        let pos = Position(x: nextX, y: nextY)
        let posWithDirection = PositionAdvanced(x: nextX, y: nextY, xDirection: xDirection, yDirection: yDirection)
        
        if visitedWithDirection.contains(posWithDirection) {
            return (Set<Position>(), true)
        }
        
        visitedWithDirection.insert(posWithDirection)
        
        visited.insert(pos)
        currentPosition = pos
    } while !wouldLeave
    return (visited, false)
}

main(input: input, isFirst: false)
