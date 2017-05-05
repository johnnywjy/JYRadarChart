//
//  JYRadarChart.swift
//  JYRadarChartSwiftDemo
//
//  Created by Erick Santos on 30/04/17.
//
//

import UIKit

class JYRadarChart: UIView {

    private let padding: CGFloat = 13.0
    private let legendPadding: CGFloat = 3.0
    private let atributeTextSize: CGFloat = 10.0
    private let colorHueStep: CGFloat = 5.0
    private let maxNumOfColor: CGFloat = 17.0
    
    lazy var r: CGFloat = {
        [unowned self] in
        min(self.frame.size.width / 2 - self.padding, self.frame.size.height / 2 - self.padding)
        }()
    var maxValue: CGFloat = 100.0
    var minValue: CGFloat = 0.0
    var isDrawPoints: Bool = false
    var isFillArea: Bool = false
    private var isShowTextLegend: Bool = false
    var isShowLegend: Bool {
        get {
            return self.isShowTextLegend
        }
        set {
            self.isShowTextLegend = newValue
            if self.isShowTextLegend {
                addSubview(legendView)
            }
            else {
                for subview in subviews {
                    if subview.isKind(of: JYLegendView.self) {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    var isShowStepText: Bool = false
    var colorOpacity: CGFloat = 1.0
    var backgroundLineColorRadial: UIColor = UIColor.black
    
    private var dataSeries: Array<Array<Double>> = []
    var data: Array<Array<Double>> {
        get {
            return self.dataSeries
        }
        
        set {
            self.dataSeries = newValue
            self.numOfV = self.dataSeries[0].count
            self.legendView.colors = []
            
            if self.legendView.colors.count < self.dataSeries.count {
                for index in 0..<dataSeries.count {
                    let color: UIColor = UIColor(hue: 1.0 * (CGFloat(index) * self.colorHueStep.truncatingRemainder(dividingBy: self.maxNumOfColor)) / self.maxNumOfColor, saturation: 1.0, brightness: 1.0, alpha: self.colorOpacity)
                    
                    self.legendView.colors.append(color)
                }
            }
        }
    }
    var attributes: Array<String> = []
    var steps: Int = 1
    lazy var centerPoint: CGPoint = {
        [unowned self] in
        return CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        }()
    var backgroundFillColor: UIColor = UIColor.white
    
    var isClockWise: Bool = true
    
    var isShowTotal: Bool = true
    private var totalTitleString: String? = nil
    var totalTitle: String {
        get {
            if let totalTitleString = self.totalTitleString {
                return totalTitleString
            } else {
                return String(describing: Int(self.maxValue))
            }
        }
        set {
            self.totalTitleString = newValue
        }
    }
    var titles: Array<String> {
        get {
            return self.legendView.titles
        }
        
        set {
            self.legendView.titles = newValue
        }
    }
    
    var colors: Array<UIColor> {
        get {
            return self.legendView.colors
        }
        
        set {
            self.legendView.colors.removeAll()
            for color in newValue {
                self.legendView.colors.append(color.withAlphaComponent(self.colorOpacity));
            }
        }
    }
    
    var stepLinesColor = UIColor.lightGray
    
    private var numOfV: Int = 0
    private let legendView: JYLegendView = {
        let legendView = JYLegendView()
        legendView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        legendView.backgroundColor = UIColor.clear
        legendView.colors = []
        return legendView
    }()
    
    var scaleFont: UIFont = UIFont.systemFont(ofSize: 10)
    var fontColors: Array<UIColor> = []
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        legendView.sizeToFit()
        legendView.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        legendView.sizeToFit()
        var r: CGRect = legendView.frame
        r.origin.x = frame.size.width - legendView.frame.size.width - legendPadding
        r.origin.y = legendPadding
        legendView.frame = r
        bringSubview(toFront: self.legendView)
    }
    
    override func draw(_ rect: CGRect) {
        let colors: Array<UIColor> = legendView.colors
        var radPerV: CGFloat = CGFloat(Double.pi * 2.0) / CGFloat(numOfV)
        
        if isClockWise {
            radPerV = -(CGFloat(Double.pi * 2.0) / CGFloat(numOfV))
        }
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        
        let height: CGFloat = scaleFont.lineHeight
        let padding: CGFloat = 2.0
        
        
        for index in 0..<numOfV {
            let attributeName: String = self.attributes[index]
            let pointOnEdge: CGPoint = CGPoint(x: centerPoint.x - r * sin(CGFloat(index) * radPerV),
                                               y: centerPoint.y - r * cos(CGFloat(index) * radPerV))
            
            let attributeTextSize: CGSize = attributeName.size(attributes: [NSFontAttributeName: scaleFont])
            let width: CGFloat = attributeTextSize.width
            
            var xOffset: CGFloat = width / 2.0 + padding
            
            if pointOnEdge.x <= centerPoint.x {
                xOffset = -width / 2.0 - padding
            }
            
            var yOffset: CGFloat = height / 2.0 + padding
            
            if pointOnEdge.y <= centerPoint.y {
                yOffset = -height / 2.0 - padding
            }
            
            let legendCenter: CGPoint = CGPoint(x: pointOnEdge.x + xOffset, y: pointOnEdge.y + yOffset)
            
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            
            paragraphStyle.lineBreakMode = .byClipping
            paragraphStyle.alignment = .center
            
            var fontColor: UIColor = UIColor.black
            
            if fontColors.count == numOfV {
                fontColor = fontColors[index]
            }
            
            var attributes: [String: Any] = [ NSFontAttributeName: scaleFont,
                                              NSParagraphStyleAttributeName: paragraphStyle,
                                              NSForegroundColorAttributeName: fontColor ]
            
            attributeName.draw(in: CGRect(x: legendCenter.x - width / 2.0,
                                          y: legendCenter.y - height / 2.0,
                                          width: width,
                                          height: height),
                               withAttributes: attributes)
            
            if isShowTotal {
                attributes = [ NSFontAttributeName: scaleFont,
                               NSParagraphStyleAttributeName: paragraphStyle,
                               NSForegroundColorAttributeName: UIColor.black ]
                
                totalTitle.draw(in: CGRect(x: legendCenter.x - width / 2.0,
                                           y: (legendCenter.y - height / 2.0) + height,
                                           width: width,
                                           height: height),
                                withAttributes: attributes)
            }
            
        }
        
        backgroundFillColor.setFill()
        context?.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y - r))
        
        for index in 1...numOfV {
            context?.addLine(to: CGPoint(x: centerPoint.x - r * sin(CGFloat(index) * radPerV),
                                         y: centerPoint.y - r * cos(CGFloat(index) * radPerV)))
        }
        
        context?.fillPath()
        
        stepLinesColor.setStroke()
        context?.saveGState()
        
        for step in 1...steps {
            for index in 0...numOfV {
                
                if index == 0 {
                    context?.move(to: CGPoint(x: centerPoint.x,
                                              y: centerPoint.y - r * CGFloat(step) / CGFloat(steps)))
                } else {
                    context?.addLine(to: CGPoint(x: centerPoint.x - r * sin(CGFloat(index) * radPerV) * CGFloat(step) / CGFloat(steps),
                                                 y: centerPoint.y - r * cos(CGFloat(index) * radPerV) * CGFloat(step) / CGFloat(steps)))
                }
                
            }
            
            context?.strokePath()
        }
        
        context?.restoreGState()
        
        backgroundLineColorRadial.setStroke()
        
        for index in 0..<numOfV {
            context?.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y))
            context?.addLine(to: CGPoint(x: centerPoint.x - r * sin(CGFloat(index) * radPerV),
                                         y: centerPoint.y - r * cos(CGFloat(index) * radPerV)))
            context?.strokePath()
        }
        
        context?.setLineWidth(2.0)
        
        if numOfV > 0 {
            for serie in 0..<dataSeries.count {
                
                if isFillArea {
                    colors[serie].setFill()
                } else {
                    colors[serie].setStroke()
                }
                
                for index in 0..<numOfV {
                    let value: CGFloat = CGFloat(dataSeries[serie][index])
                    
                    if index == 0 {
                        context?.move(to: CGPoint(x: centerPoint.x,
                                                  y: centerPoint.y - (value - minValue) / (maxValue - minValue) * r))
                    } else {
                        context?.addLine(to: CGPoint(x: centerPoint.x - (value - minValue) / (maxValue - minValue) * r * sin(CGFloat(index) * radPerV),
                                                     y: centerPoint.y - (value - minValue) / (maxValue - minValue) * r * cos(CGFloat(index) * radPerV)))
                    }
                }
                
                let value: CGFloat = CGFloat(dataSeries[serie][0])
                context?.addLine(to: CGPoint(x: centerPoint.x,
                                             y: centerPoint.y - (value - minValue) / (maxValue - minValue) * r))
                
                if isFillArea {
                    context?.fillPath()
                } else {
                    context?.strokePath()
                }
                
                if isDrawPoints {
                    for index in 0..<numOfV {
                        let value: CGFloat = CGFloat(dataSeries[serie][index])
                        let xVal: CGFloat = centerPoint.x - (value - minValue) / (maxValue - minValue) * r * sin(CGFloat(index) * radPerV)
                        let yVal: CGFloat = centerPoint.y - (value - minValue) / (maxValue - minValue) * r * cos(CGFloat(index) * radPerV)
                        
                        colors[serie].setFill()
                        context?.fillEllipse(in: CGRect(x: xVal - 4, y: yVal - 4, width: 8, height: 8))
                        backgroundColor?.setFill()
                        context?.fillEllipse(in: CGRect(x: xVal - 2, y: yVal - 2, width: 4, height: 4))
                    }
                }
                
            }
        }
        
        if isShowStepText {
            
            UIColor.black.setFill()
            for step in 0...steps {
                let value: CGFloat = minValue + (maxValue - minValue) * CGFloat(step) / CGFloat(steps)
                let currentLabel: String = String(describing: Int(value))
                
                currentLabel.draw(in: CGRect(x: centerPoint.x + 3,
                                             y: centerPoint.y - r * CGFloat(step) / CGFloat(steps),
                                             width: 20,
                                             height: 10),
                                  withAttributes: [ NSFontAttributeName: scaleFont ])
            }
            
        }
        
    }

}
