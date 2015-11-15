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
    func helperFunction(starting: Board, ending: Board) -> [BlankSpaceMove] {
        let searcher = SolutionSearcher(startingBoard: starting, goalBoard: ending, heuristicFunction: Heuristics.manhattanDistanceHeuristic)
        return searcher.generateSolution()!.actionsArray
    }
    
    override func viewDidLoad() {
        boardView.frame = self.view.bounds
        boardView.layoutIfNeeded()
        let board5: Board = [
            "2", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]
        boardView.boardElements = board5.boardElements
        
        let timer = ParkBenchTimer()
        let board1: Board = [
            "4", "1", "3", "_", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        let board2: Board = [
            "_", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        let result = helperFunction(board1, ending: board2)
        print("GOT IT...")
        print("Result:  \(result) after: \(timer.stop()) seconds")
        print("")
        
    }
    
    @IBAction func moveStep(sender: AnyObject) {
    }
}




