//
//  GameBoard.swift
//  Tetris
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

class GameBoard: UIView {
    static let rows = 22
    static let cols = 10
    static let gap = 1
    static let shapeSize = Int(UIScreen.main.bounds.size.width*(24/375.0))
    static let width  = GameBoard.shapeSize * GameBoard.cols + GameBoard.gap * (GameBoard.cols+1)
    static let height = GameBoard.shapeSize * GameBoard.rows + GameBoard.gap * (GameBoard.rows+1)
    static let EmptyColor = UIColor.black
    static let strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    var board = [[UIColor]]()
    var currentShape:Shape?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        self.clear()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func generateRow() -> [UIColor]! {
        var row = [UIColor]()
        for _ in 0..<GameBoard.cols {
            row.append(GameBoard.EmptyColor)
        }
        return row
    }
    
    func generateShape() {
        self.currentShape = Shape.generate()
    }
    
    
    func dropShape() {
        guard let currentShape = self.currentShape else { return }
        
        while self.canMoveDown(currentShape) {
            currentShape.moveDown()
            self.setNeedsDisplay()
        }
    }
    
    func rotateShape() {
        guard let currentShape = self.currentShape else { return }
        
        let rotatedPoints = currentShape.rotatedPoints()
        if self.canRotate(currentShape, rotatedPoints: rotatedPoints) {
            currentShape.points = rotatedPoints
            self.setNeedsDisplay()
        }
    }
    
    func canRotate(_ shape:Shape, rotatedPoints:[CGPoint]) -> Bool {
        
        for p in rotatedPoints {
            let r = Int(p.y) + shape.ty
            let c = Int(p.x) + shape.tx
            if r < 0 || r >= GameBoard.rows {
                return false
            }
            if c < 0 || c >= GameBoard.cols {
                return false
            }
            if self.board[r][c] != GameBoard.EmptyColor {
                return false
            }
        }
        return true
    }
    
    
    func canMoveDown(_ shape:Shape) -> Bool {
        for p in shape.points {
            let r = Int(p.y) + shape.ty + 1
            
            if r < 0 {
                continue
            }
            
            // reach to bottom
            if r >= GameBoard.rows {
                return false
            }
            let c = Int(p.x) + shape.tx
            if self.board[r][c] !=  GameBoard.EmptyColor {
                return false
            }
        }
        return true
    }
    
    func update() -> (isGameOver:Bool, droppedShape:Bool) {
        
        guard let currentShape = self.currentShape else { return (false, false)  }
        
        var droppedShape = false
        
        if self.canMoveDown(currentShape) {
            currentShape.moveDown()
        } else {
            
            droppedShape = true
            
            for p in currentShape.points {
                let r = Int(p.y) + currentShape.ty
                let c = Int(p.x) + currentShape.tx
                
                // check game over
                // can't move down and shape is out of top bound.
                if r < 0 {
                    self.setNeedsDisplay()
                    return (true, false)
                }
                self.board[r][c] = currentShape.color
            }
            
            // clear lines
            self.lineClear()
            self.generateShape()
        }
        self.setNeedsDisplay()
        
        return (false, droppedShape)
    }
    
    
    func lineClear() {
        var lineCount = 0
        var linesToRemove = [Int]()
        
        for i in 0..<self.board.count {
            let row = self.board[i]
            let rows = row.filter { c -> Bool in
                return c != GameBoard.EmptyColor
            }
            if rows.count == GameBoard.cols {
                linesToRemove.append(i)
                lineCount += 1
            }
        }
        for line in linesToRemove {
            self.board.remove(at: line)
            self.board.insert(self.generateRow(), at: 0)
        }
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Tetris.LineClearNotification),
            object: nil,
            userInfo: ["lineCount":NSNumber(value: lineCount as Int)]
        )
    }
    
    func updateX(_ x:Int) {
        
        guard let currentShape = self.currentShape else { return }
        
        if x > 0 {
            var canMoveRight = Int(currentShape.right().x) + currentShape.tx + 1 <= GameBoard.cols-1
            if canMoveRight {
                for p in currentShape.points {
                    let r = Int(p.y) + currentShape.ty
                    let c = Int(p.x) + currentShape.tx + 1
                    
                    if r < 0 {
                        continue
                    }
                    if self.board[r][c] !=  GameBoard.EmptyColor {
                        canMoveRight = false
                        break
                    }
                }
            }
            if canMoveRight {
                currentShape.moveRight()
                self.setNeedsDisplay()
            }
        } else if x < 0 {
            var canMoveLeft = Int(currentShape.left().x) + currentShape.tx - 1 >= 0
            if canMoveLeft {
                for p in currentShape.points {
                    let r = Int(p.y) + currentShape.ty
                    let c = Int(p.x) + currentShape.tx - 1
                    
                    if r < 0 {
                        continue
                    }
                    if self.board[r][c] !=  GameBoard.EmptyColor {
                        canMoveLeft = false
                        break
                    }
                }
            }
            if canMoveLeft {
                currentShape.moveLeft()
                self.setNeedsDisplay()
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        // draw game board
        for r in  0..<GameBoard.rows {
            for c in 0..<GameBoard.cols {
                let color = self.board[r][c]
                self.drawAtRow(r, col: c, color:color)
            }
        }
        // draw current shape
        guard let currentShape = self.currentShape else { return }
        for p in currentShape.points {
            let r = Int(p.y) + currentShape.ty
            let c = Int(p.x) + currentShape.tx
            if r >= 0 {
                self.drawAtRow(r, col: c, color: currentShape.color)
            }
        }
        
    }
    
    
    func drawAtRow(_ r:Int, col c:Int, color:UIColor!) {
        let context = UIGraphicsGetCurrentContext()
        let block = CGRect(x: CGFloat((c+1)*GameBoard.gap + c*GameBoard.shapeSize),
                           y: CGFloat((r+1)*GameBoard.gap + r*GameBoard.shapeSize),
                           width: CGFloat(GameBoard.shapeSize),
                           height: CGFloat(GameBoard.shapeSize))
        
        if color == GameBoard.EmptyColor {
            GameBoard.strokeColor.set()
            context?.fill(block)
        } else {
            color.set()
            UIBezierPath(roundedRect: block, cornerRadius: 1).fill()
        }
    }
    
    func clear() {
        self.currentShape = nil
        
        self.board = [[UIColor]]()
        for _ in 0..<GameBoard.rows {
            self.board.append(self.generateRow())
        }
        self.setNeedsDisplay()
    }
    
    var topY:CGFloat {
        return CGFloat(3 * GameBoard.shapeSize)
    }
    var bottomY:CGFloat {
        return CGFloat((GameBoard.rows-1) * GameBoard.shapeSize)
    }
    var centerX:CGFloat {
        return CGFloat(self.currentShape!.tx * GameBoard.shapeSize)
    }


 

}
