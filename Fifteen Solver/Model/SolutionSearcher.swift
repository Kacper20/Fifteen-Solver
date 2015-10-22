//
//  SolutionSeeker.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 22/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation


class SolutionSearcher {
    let startingBoard: Board
    let goalBoard: Board
    
    
    var frontierQueue: 
    
    let rootBoardState: BoardState
    init(startingBoard: Board, goalBoard: Board) {
        self.startingBoard = startingBoard
        self.goalBoard = goalBoard
        rootBoardState = BoardState(board: startingBoard, cost: 0, move: nil)
        
    }
    func generateSolution() -> Solution? {
        return nil
    }
}

struct Solution {
    let actionsArray: [BlankSpaceMove]
    
}


class BoardState {
    let currentBoard: Board
    let currentCost: Int
    let moveThatGeneratedState: BlankSpaceMove?
    var generatedStates: [BoardState] = []
    
    init(board: Board, cost: Int, move: BlankSpaceMove?) {
        self.currentBoard = board
        self.currentCost = cost
        self.moveThatGeneratedState = move
    }
    func generateChildStates() {
        let possibleMoves = currentBoard.possibleMoves
        let childBoards = possibleMoves.map {move -> (Board, BlankSpaceMove) in (currentBoard.makeMove(move)!, move)}
        let states = childBoards.map { (board, move)  in BoardState(board: board, cost: self.currentCost + 1, move: move) }
        self.generatedStates = states
    }
}