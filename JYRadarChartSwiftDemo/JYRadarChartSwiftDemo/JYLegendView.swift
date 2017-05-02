//
//  JYLegendView.swift
//  JYRadarChartSwiftDemo
//
//  Created by Erick Santos on 30/04/17.
//
//

import UIKit

class JYLegendView: UIView {

    private let colorPadding: CGFloat = 15.0
    private let padding: CGFloat = 3.0
    private let fontSize: CGFloat = 10.0
    private let roundRadius: CGFloat = 7.0
    private let circleDiameter: CGFloat = 6.0
    
    var legendFont: UIFont = UIFont.systemFont(ofSize: 12.0)
    
    var titles: [String] = []
    var colors: [UIColor] = []
    
    func CGContextAddRoundedRect(c: CGContext, rect: CGRect, radius: CGFloat) {
        var radiusAux = radius
        
        if (2 * radiusAux > rect.size.height) {
            radiusAux = rect.size.height / 2.0
        }
        
        if (2 * radiusAux > rect.size.width) {
            radiusAux = rect.size.width / 2.0
        }
        
        c.addArc(center: CGPoint(x: rect.origin.x + radiusAux,
                                 y: rect.origin.y + radiusAux),
                 radius: radiusAux,
                 startAngle: CGFloat(M_PI),
                 endAngle: CGFloat(M_PI) * 1.5,
                 clockwise: false)
        
        c.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radiusAux,
                                 y: rect.origin.y + radiusAux),
                 radius: radiusAux,
                 startAngle: CGFloat(M_PI) * 1.5,
                 endAngle: CGFloat(M_PI) * 2.0,
                 clockwise: false)
        
        c.addArc(center: CGPoint(x: rect.origin.x + rect.size.width - radiusAux,
                                 y: rect.origin.y + rect.size.height - radiusAux),
                 radius: radiusAux,
                 startAngle: CGFloat(M_PI) * 2.0,
                 endAngle: CGFloat(M_PI) * 0.5,
                 clockwise: false)
        
        c.addArc(center: CGPoint(x: rect.origin.x + radiusAux,
                                 y: rect.origin.y + rect.size.height - radiusAux),
                 radius: radiusAux,
                 startAngle: CGFloat(M_PI) * 0.5,
                 endAngle: CGFloat(M_PI),
                 clockwise: false)
        
        c.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + radiusAux))
        
    }
    
    func GContextFillRoundedRect(c: CGContext, rect: CGRect, radius: CGFloat) {
        c.beginPath()
        
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        
        c.addPath(clipPath)
        c.fillPath()
    }
    
    override func draw(_ rect: CGRect) {
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.init(white: 0.0, alpha: 0.1).cgColor)
        
        let clipPath: CGPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: CGFloat(roundRadius)).cgPath
        
        context?.addPath(clipPath)
        
        var y: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            
            var color = UIColor.black
            
            if colors.count == titles.count {
                color = colors[index]
            }
            
            color.setFill()
            context?.fillEllipse(in: CGRect(x: padding + 2.0,
                                            y: padding + round(y) + legendFont.xHeight / 2 + 1,
                                            width: circleDiameter,
                                            height: circleDiameter))
            
            
            UIColor.black.set()
            
            title.draw(at: CGPoint(x: colorPadding + padding, y: y + padding), withAttributes: [NSFontAttributeName: legendFont])
            
            y = y + legendFont.lineHeight
        }
        
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height: CGFloat = legendFont.lineHeight * CGFloat(titles.count)
        var width: CGFloat = 0
        
        titles.forEach {
            let size: CGSize = $0.size(attributes: [NSFontAttributeName: legendFont])
            width = max(width, size.width)
        }
        
        return CGSize(width: colorPadding + width + 2 * padding, height: height + 2 * padding)
    }

}
