//
//  Board.swift
//  Bombsweeper
//
//  Created by Sneezy on 1/17/23.
//

import Foundation

class Board {
    
    var difficulty = ""
    var size: Int
    var squares: [[Square]] = []
    
    init(size: Int) {
        self.size = size
        
        if size == 8 {
            difficulty = "Easy"
        } else if size == 10 {
            difficulty = "Medium"
        } else if size == 12 {
            difficulty = "Hard"
        }
        
        for row in 0..<size {
            var squareRow: [Square] = []
            
            for column in 0..<size {
                let square = Square(row: row, column: column)
                squareRow.append(square)
            }
            
            squares.append(squareRow)
        }
    }
    
    func resetBoard() {
//        squares = []
//        for row in 0..<size {
//            var squareRow: [Square] = []
//            
//            for column in 0..<size {
//                let square = Square(row: row, column: column)
//                squareRow.append(square)
//            }
//            
//            squares.append(squareRow)
//        }
//
        print(difficulty)
        for row in 0..<size {
            for column in 0..<size {
                squares[row][column].isBomb = false
                squares[row][column].isShowing = false
                
                placeBomb(square: squares[row][column], difficulty: difficulty)

                // TODO: Count bombs and update square's adjacent bombs
            }
        }
        
        
        for row in 0..<size {
            for column in 0..<size {
                countBombs(square: squares[row][column])
            }
        }
    }
    
    /*func firstClick() {
        for row in 0..<size {
            for column in 0..<size {
                squares[row][column].isBomb = false
                squares[row][column].isShowing = false
                
                placeBomb(square: squares[row][column], difficulty: difficulty)

                // TODO: Count bombs and update square's adjacent bombs
            }
        }
    }*/
    
    func placeBomb(square: Square, difficulty: String) {
        if difficulty == "Hard" {
            print("In hard mode")
            square.isBomb = Int.random(in: 0..<6) < 1
        } else {
            square.isBomb = Int.random(in: 0..<10) < 1
        }
    }
    
    func countBombs(square: Square) {
        let neighbors = getNeighbors(square: square)
        var bombs = 0
        
        for neighbor in neighbors {
            if neighbor.isBomb {
                bombs += 1
            }
        }
        
        square.adjacentBombs = bombs
    }
    
    func getNeighbors(square: Square) -> [Square] {
        var neighbors: [Square] = []
        let offsets = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]
        
        
        
//        /*if let newSquare = squares[square.row, square.column-1] {
//            neighbors.append(newSquare)
//        }*/
        for (rowOffset, columnOffset) in offsets {
            let row = square.row + rowOffset;
            let column = square.column + columnOffset;
            
            if (row >= 0 && row < size) && (column >= 0 && column < size) {
                neighbors.append(squares[row][column])
            }
        }
        
        return neighbors
    }
    
    //Above & Below
    //[row][column - 1]
    //[row][column + 1]
    
    //Left & Right
    //[row - 1][column]
    //[row + 1][column]
    
    //Diagonal up left
    //[row - 1][column - 1]
    
    //Diagonal up right
    //[row - 1][column + 1]
    
    //Diagonal down left
    //[row + 1][column - 1]
    
    //Diagonal down right
    //[row + 1][column + 1
    
}
