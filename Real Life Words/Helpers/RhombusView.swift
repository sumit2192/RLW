//
//  RhombusView.swift
//  Real Life Words
//
//  Created by Mac on 10/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class RhombusView: UIView {

    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    override func draw(_ rect: CGRect) {
       // self.createRectangle()
        self.createRhombus()
        // Specify the fill color and apply it to the path.
        #colorLiteral(red: 0.9179999828, green: 0.8820000291, blue: 0.04699999839, alpha: 1).setFill()
        path.fill()
        
//        // Specify a border (stroke) color.
//        UIColor.purple.setStroke()
//        path.stroke()
    }
    
    func createRhombus() {
        // Initialize the path.
        path = UIBezierPath()
        
        // Define the starting point from where the lines will be drawn
        path.move(to: CGPoint(x: self.frame.width/2, y: 0.0)) // width is divided to get the horizontal mid point of refview as X
        
        // Add line from start point defined above to the extreme left side(exactly in the middle of hieght)
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height/2))// height is divided to get the vertical mid point of refview as Y
        
        // Similarly Add line from start point to the extreme right side(exactly in the middle of hieght)
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height/2))
        // at this point if we close path, an equilateral triangle is formed with its upper tip pointing upside in the middle of width of refview
        //below is the code to replicate similar trinagle in opposite direction
        
        // change the start point to the bottom of refview
        path.move(to: CGPoint(x: self.frame.width/2, y: self.frame.size.height))
        
        // Add line from start point defined above to the extreme left side(exactly in the middle of hieght)
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height/2))// height is divided to get the vertical mid point of refview as Y
        
        // Similarly Add line from start point to the extreme right side(exactly in the middle of hieght)
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height/2))
       
        path.close()
    }
    func createRectangle() {
        // Initialize the path.
        path = UIBezierPath()
        
        // Specify the point that the path should start get drawn.
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        
        // Create a line between the starting point and the bottom-left side of the view.
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        
        // Create the bottom line (bottom-left to bottom-right).
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        // Create the vertical line from the bottom-right to the top-right side.
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
        
        // Close the path. This will create the last line automatically.
        path.close()
    }

}
/**    func createRhombus() {
    path = UIBezierPath()
    path.move(to: CGPoint(x: self.frame.width/2, y: 0.0))
    path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height/2))
    path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height/2))
    path.move(to: CGPoint(x: self.frame.width/2, y: self.frame.size.height))
    path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height/2))
    path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height/2))
    path.close()
}*/
