//
//  BoardView.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 29/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import UIKit



class BoardElementView: UIView {
    
    
    var boardElement: BoardElement? {
        didSet {
            guard let elem = boardElement else { return }
            switch elem {
            case .BlankPuzzle:
                self.label.text = ""
                self.backgroundColor = UIColor.lightGrayColor()
            case let .NumberPuzzle(value):
                self.label.text = "\(value)"
            }
        }
    }
    
    var label: UILabel
    override init(frame: CGRect) {
        label = UILabel()
        label.textColor = .whiteColor()
        super.init(frame: frame)
        self.addSubview(label)

        label.frame = self.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label.frame = self.bounds
    }
    
}
