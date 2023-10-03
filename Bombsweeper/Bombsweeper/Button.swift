//
//  Button.swift
//  Bombsweeper
//
//  Created by Sneezy on 1/20/23.
//

import UIKit

class Button: UIButton {
    let size: CGFloat
    let margin: CGFloat
    var square: Square
    
    init(size: CGFloat, margin: CGFloat, square: Square) {
        self.size = size
        self.margin = margin
        self.square = square
        let x: CGFloat = CGFloat(square.column) * (size + margin)
        let y: CGFloat = CGFloat(square.row) * (size + margin)
        let buttonFrame = CGRect(x: x, y: y, width: size, height: size)
        super.init(frame: buttonFrame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabel() -> String {
        if square.isBomb {
                return "💥"
        } else {
            if square.adjacentBombs == 0 {
                return ""
            } else {
                return "\(square.adjacentBombs)"
            }
        }
    }
}
