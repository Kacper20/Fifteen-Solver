//
//  BoardView.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 29/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import UIKit



class BoardView: UIView {
    
    @IBOutlet weak var boardLabel: UILabel!
    
    var boardElement: BoardElement? {
        didSet {
            guard let elem = boardElement else { return }
            switch elem {
            case .BlankPuzzle:
                self.boardLabel.text = "B"
            case let .NumberPuzzle(value):
                self.boardLabel.text = "\(value)"
            }
        }
    }
    
}
