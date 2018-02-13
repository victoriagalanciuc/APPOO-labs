//
//  Shape.swift
//  Tetris
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 Victoria Galanciuc. All rights reserved.
//

import UIKit

enum ShapeType {
    case i(UIColor)
    case j(UIColor)
    case l(UIColor)
    case t(UIColor)
    case z(UIColor)
    case s(UIColor)
    case o(UIColor)
}

class Shape: NSObject {
    var points = [CGPoint]()
    var tx:Int = 5
    var ty:Int = 0
    var color = UIColor.clear
    var shapeType = Shape.shapes[0]
    
    static var nextShapes = [Shape]()
    static var nextShapeCount = 3
    
    static var shapes = [
        ShapeType.i(UIColor(red:0.40, green:0.64, blue:0.93, alpha:1.0)),
        ShapeType.j(UIColor(red:0.31, green:0.42, blue:0.80, alpha:1.0)),
        ShapeType.l(UIColor(red:0.81, green:0.47, blue:0.19, alpha:1.0)),
        ShapeType.t(UIColor(red:0.67, green:0.45, blue:0.78, alpha:1.0)),
        ShapeType.z(UIColor(red:0.80, green:0.31, blue:0.38, alpha:1.0)),
        ShapeType.s(UIColor(red:0.61, green:0.75, blue:0.31, alpha:1.0)),
        ShapeType.o(UIColor(red:0.88, green:0.69, blue:0.25, alpha:1.0))
    ]
    
    static func newShape() -> Shape {
        let index = Int(arc4random_uniform(UInt32(self.shapes.count)))
        let shapeType = shapes[index]
        let shape = Shape(shapeType)
        shape.ty = -shape.vertical()
        return shape
    }
    
    static func generate() -> Shape {
        while self.nextShapes.count < self.nextShapeCount {
            self.nextShapes.append(self.newShape())
        }
        let shape = self.nextShapes.remove(at: 0)
        self.nextShapes.append(self.newShape())
        return shape
    }
    
    init(_ shapeType:ShapeType) {
        self.shapeType = shapeType
        switch shapeType {
        case ShapeType.i(let color):
            self.color = color
            self.points.append(CGPoint(x: 0, y: 0))
            self.points.append(CGPoint(x: 0, y: 1))
            self.points.append(CGPoint(x: 0, y: 2))
            self.points.append(CGPoint(x: 0, y: 3))
        case ShapeType.j(let color):
            self.color = color
            self.points.append(CGPoint(x: 1, y: 0))
            self.points.append(CGPoint(x: 1, y: 1))
            self.points.append(CGPoint(x: 1, y: 2))
            self.points.append(CGPoint(x: 0, y: 2))
        case ShapeType.l(let color):
            self.color = color
            self.points.append(CGPoint(x: 0, y: 0))
            self.points.append(CGPoint(x: 0, y: 1))
            self.points.append(CGPoint(x: 0, y: 2))
            self.points.append(CGPoint(x: 1, y: 2))
        case ShapeType.t(let color):
            self.color = color
            self.points.append(CGPoint(x: 0, y: 0))
            self.points.append(CGPoint(x: 1, y: 0))
            self.points.append(CGPoint(x: 2, y: 0))
            self.points.append(CGPoint(x: 1, y: 1))
        case ShapeType.z(let color):
            self.color = color
            self.points.append(CGPoint(x: 1, y: 0))
            self.points.append(CGPoint(x: 0, y: 1))
            self.points.append(CGPoint(x: 1, y: 1))
            self.points.append(CGPoint(x: 0, y: 2))
        case ShapeType.s(let color):
            self.color = color
            self.points.append(CGPoint(x: 0, y: 0))
            self.points.append(CGPoint(x: 0, y: 1))
            self.points.append(CGPoint(x: 1, y: 1))
            self.points.append(CGPoint(x: 1, y: 2))
        case ShapeType.o(let color):
            self.color = color
            self.points.append(CGPoint(x: 0, y: 0))
            self.points.append(CGPoint(x: 0, y: 1))
            self.points.append(CGPoint(x: 1, y: 0))
            self.points.append(CGPoint(x: 1, y: 1))
        }
    }
    
    func moveDown() {
        ty += 1
    }
    func moveLeft() {
        tx -= 1
    }
    func moveRight() {
        tx += 1
    }
    
    func rotatedPoints() -> [CGPoint] {
        
        switch self.shapeType {
        case ShapeType.o:
            return self.points
        default:
            var mx = self.points.reduce(CGFloat(0), { (initValue:CGFloat, p:CGPoint) -> CGFloat in
                return initValue + p.x
            })
            var my = self.points.reduce(CGFloat(0), { (initValue:CGFloat, p:CGPoint) -> CGFloat in
                return initValue + p.y
            })
            mx = CGFloat(Int(mx)/self.points.count)
            my = CGFloat(Int(my)/self.points.count)
            
            let sinX:CGFloat = 1
            let cosX:CGFloat = 0
            
            var rotatedShape = [CGPoint]()
            
            for p in self.points {
                let r = p.y
                let c = p.x
                let x = (c-mx) * cosX - (r-my) * sinX
                let y = (c-mx) * sinX + (r-my) * cosX
                rotatedShape.append(CGPoint(x: x, y: y))
            }
            return rotatedShape
        }
    }
    
    func left() -> CGPoint {
        var left = self.points[0]
        for p in self.points {
            if left.x > p.x {
                left = p
            }
        }
        return left
    }
    
    func right() -> CGPoint {
        var right = self.points[0]
        for p in self.points {
            if right.x < p.x {
                right = p
            }
        }
        return right
    }
    
    func bottom() -> CGPoint {
        var bottom = self.points[0]
        for p in self.points {
            if bottom.y < p.y {
                bottom = p
            }
        }
        return bottom
    }
    
    func top() -> CGPoint {
        var top = self.points[0]
        for p in self.points {
            if top.y > p.y {
                top = p
            }
        }
        return top
    }
    
    func vertical() -> Int {
        return Int(self.bottom().y) + 1
    }

}
