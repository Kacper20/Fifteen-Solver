//
//  BoardSimulationViewController.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 03/11/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import UIKit


class BoardSimulationViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    ///No usage of Autolayout -> visualisation is only a small feature, not something to bother :)
    let viewOffsets: CGFloat = 16.0
    override func viewDidLoad() {
        boardView.frame = self.view.bounds
        boardView.layoutIfNeeded()
        let board1: Board = [
            "2", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]
        boardView.boardElements = board1.boardElements
    }
    
}




