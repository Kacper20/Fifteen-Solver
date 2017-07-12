//
//  SolutionSearcherTests.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 13.11.2015.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import XCTest
@testable import Fifteen_Solver
class SolutionSearcherTests: XCTestCase {

    var badHeuristic: Board -> Float = {
        (_) -> Float in
        return 1.0
    }

    func helperFunction(starting: Board, ending: Board) -> [BlankSpaceMove] {
        let searcher = SolutionSearcher(startingBoard: starting, goalBoard: ending)
        return searcher.generateSolution()!.actionsArray
    }

    func testEqualBoardsSolutionCountZeroElements() {
        let board1: Board = [
            "_", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "1"
        ]
        let board2: Board = [
            "_", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "1"
        ]
        let actions = helperFunction(board1, ending: board2)
        XCTAssertEqual(actions.count, 0)
    }

    func testDifferenceOneElementOneMove() {
        let board1: Board = [
            "1", "_", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        let board2: Board = [
            "_", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        XCTAssertEqual(helperFunction(board1, ending: board2).count, 1)
    }

    func testDifferenceThreeMovesMove() {
        let board1: Board = [
            "4", "1", "3", "_", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        let board2: Board = [
            "_", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        XCTAssertEqual(helperFunction(board1, ending: board2).count, 1)
    }
}
