//
//  NibViews.swift
//  Fifteen Solver
//
//  Created by Kacper Harasim on 03/11/15.
//  Copyright © 2015 Kacper Harasim. All rights reserved.
//

import UIKit

enum Views: String {
    case BoardElementView = "BoardElementView" //Change View1 to be the name of your nib
    func getView() -> UIView {
        return Bundle.main.loadNibNamed(self.rawValue, owner: nil, options: nil)![0] as! UIView
    }
}
