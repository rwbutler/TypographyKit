//
//  UIButtonTests.swift
//  TypographyKit_Tests
//
//  Created by Ross Butler on 23/05/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation
import XCTest
@testable import TypographyKit

class UIButtonTitleColorTests: XCTestCase {

    private func makeSUT() -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        button.setTitleColor(UIColor.green, for: .disabled)
        button.setTitleColor(UIColor.yellow, for: .selected)
        if #available(iOS 9.0, *) {
            button.setTitleColor(UIColor.orange, for: .focused)
        }
        button.setTitleColor(UIColor.purple, for: .application)
        return button
    }

    func testWhenModeIsAllTitleColorAppliedToAllControlStates() {
        let button = makeSUT()
        button.applyTitleColor(UIColor.cyan, mode: .all)
        UIControl.State.allCases.forEach { controlState in
            let titleColorForState = button.titleColor(for: controlState)
            XCTAssertEqual(titleColorForState, UIColor.cyan)
        }
    }

    func testWhenModeIsNoneTitleColorAppliedToNoControlStates() {
        let button = makeSUT()
        button.applyTitleColor(UIColor.cyan, mode: .none)
        UIControl.State.allCases.forEach { controlState in
            let titleColorForState = button.titleColor(for: controlState)
            XCTAssertNotEqual(titleColorForState, UIColor.cyan)
        }
    }

    func testWhenModeIsNormalTitleColorAppliedToNormalControlState() {
        let button = makeSUT()
        button.applyTitleColor(UIColor.cyan, mode: .normal)
        let titleColorForNormalState = button.titleColor(for: .normal)
        XCTAssertEqual(titleColorForNormalState, .cyan)
    }

    func testWhenModeIsNormalTitleColorNotAppliedToRemainingControlStates() {
         let button = makeSUT()
        button.applyTitleColor(UIColor.cyan, mode: .normal)
        UIControl.State.allCases.filter {
            $0 != .normal
        } .forEach { controlState in
            let titleColorForState = button.titleColor(for: controlState)
            XCTAssertNotEqual(titleColorForState, UIColor.cyan)
        }
    }

    func testWhenModeIsWhereUnspecifiedTitleColorAppliedToUnspecifiedControlStates() {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        button.applyTitleColor(UIColor.cyan, mode: .whereUnspecified)
        UIControl.State.allCases.filter {
            $0 != .normal && $0 != .highlighted
        } .forEach { controlState in
            let titleColorForState = button.titleColor(for: controlState)
            print(controlState == .disabled)
            XCTAssertEqual(titleColorForState, UIColor.cyan)
        }
    }

    func testWhenModeIsWhereUnspecifiedTitleColorNotAppliedToSpecifiedControlStates() {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        button.applyTitleColor(UIColor.cyan, mode: .whereUnspecified)
        XCTAssertNotEqual(button.titleColor(for: .normal), .cyan)
        XCTAssertNotEqual(button.titleColor(for: .highlighted), .cyan)
    }

    func testWhenModeIsWhereUnspecifiedTitleColorAppliedToDefaultButton() {
        let button = UIButton(type: .custom)
        button.applyTitleColor(UIColor.cyan, mode: .whereUnspecified)
        XCTAssertEqual(button.titleColor(for: .normal), .cyan)
    }

}
