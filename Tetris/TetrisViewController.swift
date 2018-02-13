//
//  TetrisViewController.swift
//  Tetris
//
//  Created by Admin on 2/14/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

class TetrisViewController: UIViewController {

    var tetris:Tetris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeGame()
    }
    
    deinit {
        self.tetris.deinitGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeGame() {
        let gameView = GameView(self.view)
        self.tetris = Tetris(gameView: gameView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            self.tetris.touch(touch)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }

}
