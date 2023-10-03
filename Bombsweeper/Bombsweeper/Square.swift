//
//  Square.swift
//  Bombsweeper
//
//  Created by Sneezy on 1/17/23.
//

import Foundation

class Square {
    let row: Int
    let column: Int
    
    var isBomb = false
    var isShowing = false
    var adjacentBombs = 0
    var isFlagged = false
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
}
