//
//  BoardTests.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 13.11.2015.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import XCTest
@testable import Fifteen_Solver
//Testy dla Board
class BoardTests: XCTestCase {

 
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSameBoardsAreEqual() {
        let board1: Board = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]
        let board2: Board = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]

        XCTAssertEqual(board1, board2)
    }
    func testDifferentBoardsAreNotEqual() {
        let board1: Board = [
            "2", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]
        let board2: Board = [
            "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]
        XCTAssertNotEqual(board2, board1)
    }
    func testMovesUpLeftPossible() {
        let board1: Board = [
            "2", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "_"
        ]
        XCTAssertEqual(board1.possibleMoves, [.Up, .Left])
    }
    func testMovesDownRightPossible() {
        let board1: Board = [
            "_", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "1"
        ]
        XCTAssertEqual(board1.possibleMoves, [.Down, .Right])
    }
    func testMovesDownLeftPossible() {
        let board1: Board = [
            "1", "2", "3", "_", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "4"
        ]
        XCTAssertEqual(board1.possibleMoves, [.Down, .Left])
    }
    func testMovesUpRightPossible() {
        let board1: Board = [
            "4", "1", "3", "2", "5", "6", "7", "8", "9", "10", "11", "12", "_", "14", "15", "13"
        ]
        XCTAssertEqual(board1.possibleMoves, [.Up, .Right])
    }
    func testBoardChangesAfterMove() {
        let board1: Board = [
            "1", "_", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        
        let board2: Board = [
            "_", "1", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        let board3: Board = [
            "1", "6", "3", "4", "5", "_", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        let board4: Board = [
            "1", "3", "_", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "2"
        ]
        
        XCTAssertEqual(board1.makeMove(.Left), board2)
        XCTAssertEqual(board1.makeMove(.Down), board3)
        XCTAssertEqual(board1.makeMove(.Right), board4)
    }


}
