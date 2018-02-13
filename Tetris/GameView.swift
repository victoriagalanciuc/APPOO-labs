//
//  GameView.swift
//  Tetris
//
//  Created by Admin on 2/14/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    var gameScore = GameScore(frame:CGRect.zero)
    var gameBoard = GameBoard(frame:CGRect.zero)
    fileprivate var gameButton = GameButton(title: "Play", frame: CGRect.zero)
    fileprivate var stopButton = GameButton(title: "Stop", frame: CGRect.zero)
    var rotateButton = GameButton(title: "R", frame: CGRect.zero)
    
    init(_ superView:UIView) {
        super.init(frame: superView.frame)
        
        superView.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        superView.addSubview(self)
        
        // background color
        self.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        self.rotateButton.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.gameBoard.translatesAutoresizingMaskIntoConstraints = false
        self.gameScore.translatesAutoresizingMaskIntoConstraints = false
        self.rotateButton.translatesAutoresizingMaskIntoConstraints = false
        self.stopButton.translatesAutoresizingMaskIntoConstraints = false
        self.gameButton.translatesAutoresizingMaskIntoConstraints = false
        self.gameButton.addTarget(self, action: #selector(GameView.changeGameState(_:)), for: UIControlEvents.touchUpInside)

        self.stopButton.addTarget(self, action: #selector(GameView.gameStop(_:)), for: UIControlEvents.touchUpInside)
        
        
        self.addSubview(self.gameBoard)
        self.addSubview(self.gameScore)
        self.addSubview(self.rotateButton)
        self.addSubview(self.gameButton)
        self.addSubview(self.stopButton)
        
        // layout gameboard
        let metrics = [
            "width":GameBoard.width,
            "height":GameBoard.height
        ]
        
        let views   = [
            "gameBoard":self.gameBoard,
            "gameScore":self.gameScore,
            "rotateButton":self.rotateButton,
            "gameButton":self.gameButton,
            "stopButton":self.stopButton
            ] as [String : Any]
        
        // layout board
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[gameBoard(width)]",
                options: [],
                metrics:metrics ,
                views:views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[gameBoard(height)]-|",
                options: [],
                metrics:metrics ,
                views:views)
        )
        
        // layout score
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[gameScore]-|",
                options: [],
                metrics:nil ,
                views:views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-20-[gameScore]-[gameBoard]",
                options: [],
                metrics:nil ,
                views:views)
        )
        
        
        
        // layout rotate button.
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[gameBoard]-[rotateButton(50)]-30-|",
                options: [],
                metrics:nil ,
                views:views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[rotateButton(50)]-170-|",
                options: [],
                metrics:nil ,
                views:views)
        )
        
        //layout play and stop button.
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[gameBoard]-[gameButton(50)]-30-|",
                options: [],
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[gameButton(50)]-10-|",
                options: [],
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[stopButton(50)]",
            options: [],
            metrics: nil,
            views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[gameBoard]-(<=0)-[gameButton]",
            options: NSLayoutFormatOptions.alignAllCenterX,
            metrics: nil ,
            views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[stopButton(50)]-30-[gameButton]",
            options: NSLayoutFormatOptions.alignAllLeft,
            metrics: nil, views: views)
        )
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint("deinit GameView")
    }
    
    
    func gameStop(_ sender:UIButton) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Tetris.GameStateChangeNotification),
            object: nil,
            userInfo: ["gameState":NSNumber(value: GameState.stop.rawValue as Int)]
        )
    }
    
    func changeGameState(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        let gameState = self.update(sender.isSelected)
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Tetris.GameStateChangeNotification),
            object: nil,
            userInfo: ["gameState":NSNumber(value: gameState.rawValue as Int)]
        )
    }
    
    @discardableResult
    func update(_ selected:Bool) -> GameState {
        var gameState = GameState.play
        if selected {
            gameState = GameState.play
            self.gameButton.setTitle("Pause", for: UIControlState())
        } else {
            gameState = GameState.pause
            self.gameButton.setTitle("Play", for: UIControlState())
        }
        return gameState
    }
    
    func clear() {
        self.gameScore.clear()
        self.gameBoard.clear()
    }
    
    func prepare() {
        self.gameScore.clear()
        self.gameBoard.clear()
        self.clearButtons()
    }
    
    func clearButtons() {
//        self.gameButton.isSelected = false
//        self.update(self.gameButton.isSelected)
    }
}
