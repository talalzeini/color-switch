//
//  Settings.swift
//  Color
//
//  Created by Talal Zeini on 4/27/20.
//  Copyright © 2020 Talal Zeini. All rights reserved.
//

import SpriteKit

enum PhysicsCategories{
    static let none: UInt32 = 0
    static var ballCategory: UInt32 = 0x1       // 01
    static var switchCategory: UInt32 = 0x1 << 1  // 10
}

enum ZPositions{
    static let label: CGFloat = 0
    static let ball: CGFloat = 1
    static let colorSwitch : CGFloat = 2
}
