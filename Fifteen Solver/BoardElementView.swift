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
            case .blankPuzzle:
                self.label.text = ""
                self.backgroundColor = .lightGray
            case let .numberPuzzle(value):
                self.label.text = "\(value)"
            }
        }
    }
    
    let label: UILabel

    override init(frame: CGRect) {
        label = UILabel()
        label.textColor = .white
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
