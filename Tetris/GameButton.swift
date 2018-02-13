//
//  GameButton.swift
//  Tetris
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

class GameButton: UIView {
    convenience init(title:String, frame: CGRect) {
        self.init(frame: frame)
//        self.setTitle(title, for: UIControlState())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeView()
    }
    
    fileprivate func initializeView() {
        self.backgroundColor = UIColor.clear
//        self.setTitleColor(UIColor.white, for: UIControlState())
//        self.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
    }


}
