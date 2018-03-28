//
//  4. Game of life.swift
//  
//
//  Created by Inna Soboleva on 3/28/18.
//

import Foundation

enum Status {
    case live
    case dead
    case neverlived
}

class Cell {
    var x: Int
    var y: Int
    
    var status: Status
    var neighbours: [(x: Int, y: Int)]
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
        self.status = .neverlived
        self.neighbours = []
    }
    
    init(_ x: Int, _ y: Int, dimension: Int) {
        self.x = x
        self.y = y
        self.status = .neverlived
        self.neighbours = []
        
        updateNeighbours(x, y, dimension: dimension)
    }
    
    func updateNeighbours(_ x: Int, _ y: Int, dimension: Int) {
        // boundaries check
        if x == dimension && y == dimension {
            for i in x-1...x {
                for j in y-1...y {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        }
        else if x == 0 && y == 0 {
            for i in x...x+1 {
                for j in y...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        }
        else if x == dimension && y == 0 {
            for i in x-1...x {
                for j in y...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        }
        else if x == 0 && y == dimension {
            for i in x...x+1 {
                for j in y-1...y {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        }
        else if x == 0 {
            for i in x...x+1 {
                for j in y-1...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        } else if x == dimension {
            for i in x-1...x {
                for j in y-1...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        } else if y == 0 {
            for i in x-1...x+1 {
                for j in y...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        } else if y == dimension {
            for i in x-1...x+1 {
                for j in y-1...y {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        } else {
            for i in x-1...x+1 {
                for j in y-1...y+1 {
                    if i == x && j == y {
                        continue
                    }
                    neighbours.append((x: i, y: j))
                }
            }
        }
    }
}

class World {
    var size: Int
    var cells: [[Cell]]
    var liveCells: [(Int, Int)]
    
    init(_ size: Int) {
        self.size = size
        self.cells = []
        for i in 0..<size {
            cells.append([])
            for j in 0..<size {
                cells[i].append(Cell(i,j, dimension: size-1))
            }
        }
        self.liveCells = []
    }
    
    func addLivingCells(_ list: [(Int, Int)]) {
        for each in list {
            cells[each.0][each.1].status = .live
        }
        self.liveCells = list
    }
    
    func run(_ seconds: Double, _ pause: Double) {
        var alive = true
        var count_second = seconds
        while alive {
            printWorld()
            sleep(UInt32(pause))
            alive = updateWorld()
            count_second -= pause
            if count_second <= 0 {
                break
            }
        }
        printWorld()
    }
    
    func updateWorld() -> Bool {
        var cells_to_die: [(Int, Int)] = []
        var removeIndex: [Int] = []
        var iteration = 0
        // check each live cell if it lives or dies
        for each_cell in self.liveCells {
            let neighbours = cells[each_cell.0][each_cell.1].neighbours
            var count_neighbours = 0
            for i in neighbours {
                if cells[i.0][i.1].status == .live {
                    count_neighbours += 1
                }
            }
            if count_neighbours > 3 || count_neighbours < 2 {
                cells_to_die.append(each_cell)
                removeIndex.append(iteration)
            }
            iteration += 1
        }
        
        // remove dead cells from list of alive cells
        let sorted = removeIndex.sorted(by: { $1 < $0 }) // removed from the end of array
        for index in sorted {
            self.liveCells.remove(at: index)
        }
        // update World dead cells
        for cell in cells_to_die {
            cells[cell.0][cell.1].status = .dead
        }
        // check neighbours now for new alive cells
        var future_alive_cells: [(Int,Int)] = []
        for each_cell in self.liveCells {
            let dead_neighbours = cells[each_cell.0][each_cell.1].neighbours
            for cell in dead_neighbours {
                if cells[cell.0][cell.1].status == .dead {
                    var count_alive = 0
                    let live_neighbours = cells[cell.0][cell.1].neighbours
                    for alive_neighbour in live_neighbours {
                        if cells[alive_neighbour.0][alive_neighbour.1].status == .live {
                            count_alive += 1
                        }
                    }
                    if count_alive == 3 {
                        future_alive_cells.append(cell)
                    }
                }
            }
        }
        // update newborn cells
        for cell in future_alive_cells {
            cells[cell.0][cell.1].status = .live
            self.liveCells.append(cell)
        }
        // check if there are any living cells
        if self.liveCells.count <= 0 {
            return false
        }
        return true
    }
    
    func printWorld() {
        for row in 0..<size {
            var print_row = ""
            for col in 0..<size {
                if cells[row][col].status == .live {
                    print_row += "Q"
                } else if cells[row][col].status == .dead {
                    print_row += "X"
                } else if cells[row][col].status == .neverlived {
                    print_row += "U"
                }
                else {
                    print("Something went wrong")
                }
            }
            print(print_row)
        }
        print(" ")
    }
}

// create World
var myWorld = World(5)

// add starting cells
myWorld.addLivingCells([(1,1),(1,2),(1,3),(3,4), (4,4)])

// run your world with an rguments - ammount of seconds (type Double) ofr how long whould this world exist
// and second argument - for how long does it pauses (type Double)
myWorld.run(30.0, 5.0)
