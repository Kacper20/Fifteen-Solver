//
//  SolutionSeeker.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 22/10/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import Foundation



class BoardNode: Comparable, Hashable {
    let state: Board
    let generationAction: BlankSpaceMove?
    let cost: Float
    let heuristic: Float
    init(state: Board, action: BlankSpaceMove?, cost: Float, heuristic: Float) {
        self.state = state
        self.generationAction = action
        self.cost = cost
        self.heuristic = heuristic
    }
    var hashValue: Int {
        return state.hashValue
    }
}
func < (lhs: BoardNode, rhs: BoardNode) -> Bool {
    return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
}

func == (lhs: BoardNode, rhs: BoardNode) -> Bool {
    return lhs === rhs
}

class SolutionSearcher {
    let startingBoard: Board
    let goalBoard: Board
    let heuristic: Board -> Float
    let generationFunction: Board -> [(Board, BlankSpaceMove)]
    
    let rootBoardState: BoardNode
    init(startingBoard: Board, goalBoard: Board, heuristicFunction: Board -> Float, generationFunction: Board -> [(Board, BlankSpaceMove)]) {
        self.startingBoard = startingBoard
        self.goalBoard = goalBoard
        self.heuristic = heuristicFunction
        //Startowy koszt to 0...
        self.generationFunction = generationFunction
        rootBoardState = BoardNode(state: self.startingBoard, action: nil, cost: 0.0, heuristic: heuristicFunction(self.startingBoard))
    }
    
    func backTrack(node: BoardNode) -> [BlankSpaceMove] {
        var moves = [BlankSpaceMove]()
        while let moveThatGeneratedNode = node.generationAction {
            moves.append(moveThatGeneratedNode)
        }
        return moves.reverse()
    }
    
    func generateSolution() -> Solution? {
        //Dążymy do najmniejszego celu
        var nodesGenerated: Int = 0
        var frontierQueue = PriorityQueue(ascending: false, startingValues: [rootBoardState])
        //Slownik - stan & koszt w tym stanie
        var exploredStatesSet = [Board:Float]()
        exploredStatesSet[self.rootBoardState.state] = 0
        while !frontierQueue.isEmpty {
            nodesGenerated++
            let currentNode = frontierQueue.pop()!
            let state = currentNode.state
            if state == goalBoard {
                print("Searched \(nodesGenerated) nodes")
                return Solution(startBoard: self.startingBoard, actions: backTrack(currentNode))
            }
            //TODO : Finish up method...
            //Generujemy stany... Sprobowac napisac bardziej generycznie :)
            for (child, move) in generationFunction(state) {
                let newCost = currentNode.cost + 1.0
                if exploredStatesSet[child] == nil || exploredStatesSet[child] > newCost  {
                    exploredStatesSet[child] = newCost
                    frontierQueue.push(BoardNode(state: child, action: move, cost: newCost, heuristic: heuristic(child)))
                }
                
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

