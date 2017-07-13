//
//  SolutionSeeker.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 22/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation



class BoardNode: Comparable, Hashable, CustomStringConvertible {
    let state: Board
    let generationAction: BlankSpaceMove?
    let cost: Float
    let heuristic: Float
    var parentNode: BoardNode?
    init(state: Board, action: BlankSpaceMove?, parentNode: BoardNode?, cost: Float, heuristic: Float) {
        self.parentNode = parentNode
        self.state = state
        self.generationAction = action
        self.cost = cost
        self.heuristic = heuristic
    }
    var hashValue: Int {
        return state.hashValue
    }
    var description: String {
        return "PLANSZA: \(state), cost: \(cost + heuristic)"
    }
}
func < (lhs: BoardNode, rhs: BoardNode) -> Bool {
    return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
}

func == (lhs: BoardNode, rhs: BoardNode) -> Bool {
    return lhs === rhs
}

func badHeuristic(brd: Board, secBrd: Board) -> Float {
    return 1.0
}

public class SolutionSearcher {
    let startingBoard: Board
    let goalBoard: Board
    typealias HeuristicFunction = (Board, Board) -> Float
    let heuristic: (Board, Board) -> Float
    
    let rootBoardState: BoardNode
    
    /**
     Initializes SolutionSearcher with data
     :param: startingBoard    Board that solution starts with
     :param: goalBoard        Goal board for the solution
     :param: heuristicFunction Function that tells us "optimistic" evaluation of cost for given board
     :param: generationFunction Function that takes one Board, and based on it's state, generates another boards that are possible to achieve from given, among with moves that generates each new board
     */

    init(startingBoard: Board, goalBoard: Board, heuristicFunction: @escaping (Board, Board) -> Float = badHeuristic) {
        self.startingBoard = startingBoard
        self.goalBoard = goalBoard
        self.heuristic = heuristicFunction
        //Startowy koszt to 0...
        rootBoardState = BoardNode(state: self.startingBoard, action: nil, parentNode: nil, cost: 0.0, heuristic: heuristicFunction(self.startingBoard, self.goalBoard))
    }
    private func backTrack(from node: BoardNode) -> [BlankSpaceMove] {
        var tempNode = node //For better visibility
        var moves = [BlankSpaceMove]()
        while let node = tempNode.parentNode, let action = tempNode.generationAction {
            moves.append(action)
            tempNode = node
        }
        return moves.reversed()
    }
    
    func generateSolution() -> Solution? {
        var nodesGenerated: Int = 0
        var frontierQueue = PriorityQueue(ascending: true, startingValues: [rootBoardState])
        var discoveredBoards: [Board : Bool] = [:]
        discoveredBoards[rootBoardState.state] = true
        while !frontierQueue.isEmpty {
            nodesGenerated += 1
            let currentNode = frontierQueue.pop()!
            let state = currentNode.state
            if state == goalBoard {
                print("Searched \(nodesGenerated) nodes")
                return Solution(startBoard: self.startingBoard, actions: backTrack(from: currentNode))
            }
            //Generujemy stany... Sprobowac napisac bardziej generycznie :)
            for (child, move) in state.standardGeneratorFunction(parentBoard: currentNode.parentNode?.state) where discoveredBoards[child] == nil
                 {
                    discoveredBoards[child] = true
                let newCost = currentNode.cost + 1.0
                    frontierQueue.push(BoardNode(state: child, action: move, parentNode: currentNode ,cost: newCost, heuristic: heuristic(child, self.goalBoard)))
            }
        }
        return nil
    }
}

public struct Solution {
    let startBoard: Board
    let actionsArray: [BlankSpaceMove]

    init(startBoard: Board, actions: [BlankSpaceMove]) {
        self.startBoard = startBoard
        self.actionsArray = actions
    }
    
}

