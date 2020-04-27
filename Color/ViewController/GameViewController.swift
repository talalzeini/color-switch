//
//  GameViewController.swift
//  Color
//
//  Created by Talal Zeini on 4/27/20.
//  Copyright © 2020 Talal Zeini. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
    
         let scene = MenuScene(size: view.bounds.size)
            
            
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
