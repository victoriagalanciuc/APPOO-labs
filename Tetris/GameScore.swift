//
//  GameScore.swift
//  Tetris
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

class GameScore: UIView {

    var lineClearCount = 0
    var gameScore = 0
    
    fileprivate var lineClearLabel = UILabel()
    fileprivate var scoreLabel = UILabel()
    fileprivate var scores = [0, 10, 30, 60, 100]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        self.lineClearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.lineClearLabel.textColor = UIColor.white
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.lineClearLabel.font = UIFont(name: "Helvetica", size: 20)
        self.lineClearLabel.adjustsFontSizeToFitWidth = true
        self.lineClearLabel.minimumScaleFactor = 0.9
        self.addSubview(self.lineClearLabel)
        
        self.scoreLabel = UILabel(frame: CGRect.zero)
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLabel.textColor = UIColor.white
        self.scoreLabel.text = "Score: \(self.gameScore)"
        self.scoreLabel.font = UIFont(name: "Helvetica", size: 20)
        self.scoreLabel.adjustsFontSizeToFitWidth = true
        self.scoreLabel.minimumScaleFactor = 0.9
        self.addSubview(self.scoreLabel)
        
        let views = [
            "lineClear": self.lineClearLabel,
            "score": self.scoreLabel,
            "selfView": self
            ] as [String : Any]
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-10-[lineClear(>=90)]-10-[score(lineClear)]-|",
                options: NSLayoutFormatOptions.alignAllCenterY,
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "[selfView]-(<=0)-[score]",
                options: NSLayoutFormatOptions.alignAllCenterY,
                metrics: nil,
                views: views)
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameScore.lineClear(_:)),
                                               name: NSNotification.Name(rawValue: Tetris.LineClearNotification),
                                               object: nil)
    }
    
    func lineClear(_ noti:Notification) {
        if let userInfo = noti.userInfo as? [String:NSNumber] {
            if let lineCount = userInfo["lineCount"] {
                self.lineClearCount += lineCount.intValue
                self.gameScore += self.scores[lineCount.intValue]
                self.update()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func clear() {
        self.lineClearCount = 0
        self.gameScore = 0
        self.update()
    }
    
    func update() {
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.scoreLabel.text = "Score: \(self.gameScore)"
    }


}
