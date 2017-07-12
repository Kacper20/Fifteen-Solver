//
//  BoardView.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 08/11/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import UIKit


class BoardView: UIView {
    
    let numberOfColumns: Int = 4
    let numberOfRows: Int = 4
    var views: [BoardElementView] = []
    var boardElements: [BoardElement] = [] {
        didSet {
            for (ind, view) in views.enumerated() {
                view.boardElement = boardElements[ind]
                view.layoutIfNeeded()
            }
        }
    }
    override func awakeFromNib() {
        

        for _ in 0..<numberOfColumns * numberOfRows {
            let view = BoardElementView()
            self.addSubview(view)
            views.append(view)
        }
    }
    override func layoutSubviews() {
        let offset: CGFloat = 16.0
        let startingX = offset
        var startingPoint = CGPoint(x: startingX, y: 0.0)
        let size = self.bounds.size.width - offset * 2.0
        let sizeOfOneElement = size / 4
        
        for i in 0..<numberOfRows {
            for j in 0..<numberOfColumns {
                let view = views[i * numberOfRows + j ]
                view.layer.borderColor = UIColor.lightGray.cgColor
                view.layer.borderWidth = 1.0
                view.frame = CGRect(
                    x: startingPoint.x,
                    y: startingPoint.y,
                    width: sizeOfOneElement,
                    height: sizeOfOneElement
                )
                view.backgroundColor = UIColor(red:0.25, green:0.56, blue:0.36, alpha:1)
                startingPoint = CGPoint(
                    x: startingPoint.x + sizeOfOneElement,
                    y: startingPoint.y
                )
            }
            startingPoint = CGPoint(x: startingX, y: startingPoint.y + sizeOfOneElement)
        }
    }
}
