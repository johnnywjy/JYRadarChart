//
//  ViewController.swift
//  JYRadarChartSwiftDemo
//
//  Created by Erick Santos on 30/04/17.
//
//

import UIKit

class ViewController: UIViewController {

    let p = JYRadarChart(frame: CGRect(x: 30.0, y: 20.0, width: 200.0, height: 200.0))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a1: Array<Double> = [81.0, 97.0, 87.0, 60.0, 65.0, 77.0]
        let a2: Array<Double> = [91.0, 87.0, 33.0, 77.0, 78.0, 96.0]
        p.data = [a1, a2]
        p.steps = 1
        p.isShowStepText = true
        p.backgroundColor = UIColor.white
        p.r = 60
        p.minValue = 20
        p.maxValue = 120
        p.isFillArea = true
        p.colorOpacity = 0.7
        p.backgroundFillColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        p.attributes = ["Attack", "Defense", "Speed", "HP", "MP", "IQ"]
        p.isShowLegend = true
        p.titles = ["archer", "footman"]
        p.colors = [UIColor.yellow, UIColor.purple];
        p.isShowTotal = false
        self.view.addSubview(p)
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        
        
        let p2 = JYRadarChart(frame: CGRect(x: 10.0, y: 220.0, width: 280.0, height: 200.0))
        p2.centerPoint = CGPoint(x: 130, y: 100)
        p2.isShowLegend = true
        p2.backgroundFillColor = UIColor.white
        p2.titles = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
        p2.isDrawPoints = true
        p2.attributes = ["Price", "Value", "Pressure", "Height", "Weight", "Grade", "Volume", "Length", "Size", "Padding", "Pages", "HAHAHA"]
        let b1: Array<Double> = [61.0, 97.0, 87.0, 60.0, 85.0, 77.0, 73.0, 74.0, 53.0, 82.0, 65.0, 61.0]
        let b2: Array<Double> = [91.0, 87.0, 43.0, 77.0, 78.0, 96.0, 51.0, 65.0, 77.0, 55.0, 84.0, 91.0]
        let b3: Array<Double> = [51.0, 97.0, 87.0, 60.0, 25.0, 77.0, 93.0, 14.0, 53.0, 34.0, 65.0, 51.0]
        let b4: Array<Double> = [11.0, 87.0, 65.0, 77.0, 55.0, 84.0, 43.0, 77.0, 78.0, 96.0, 51.0, 11.0]
        let b5: Array<Double> = [41.0, 97.0, 87.0, 60.0, 95.0, 77.0, 73.0, 74.0, 59.0, 82.0, 95.0, 41.0]
        let b6: Array<Double> = [61.0, 96.0, 51.0, 65.0, 77.0, 87.0, 43.0, 70.0, 78.0, 55.0, 44.0, 61.0]
        let b7: Array<Double> = [81.0, 97.0, 74.0, 53.0, 82.0, 65.0, 87.0, 60.0, 85.0, 77.0, 73.0, 81.0]
        let b8: Array<Double> = [91.0, 84.0, 43.0, 67.0, 78.0, 96.0, 47.0, 55.0, 67.0, 55.0, 51.0, 91.0]
        let b9: Array<Double> = [38.0, 85.0, 77.0, 93.0, 74.0, 53.0, 82.0, 97.0, 87.0, 60.0, 65.0, 38.0]
        let b10: Array<Double> = [31.0, 87.0, 43.0, 37.0, 78.0, 96.0, 51.0, 65.0, 17.0, 55.0, 54.0, 31.0]
        p2.data = [b1, b2, b3, b4, b5, b6, b7, b8, b9, b10]
        p2.steps = 2;
        p2.isShowTotal = false
        p2.backgroundColor = UIColor.gray
        self.view.addSubview(p2)
    }
    
    func updateData() {
        let n = 6
        var a = Array<Double>()
        var b = Array<Double>()
        var c = Array<Double>()
        
        
        for _ in 0..<n {
            a.append(Double(arc4random() % 40 + 80))
            b.append(Double(arc4random() % 50 + 70))
            c.append(Double(arc4random() % 60 + 60))
        }
        
        p.data = [a, b, c]
        p.steps = Int(arc4random() % 6) + 1
        p.isFillArea = arc4random() % 2 == 0 ? true : false
        p.isDrawPoints = arc4random() % 2 == 0 ? true : false
        p.isShowStepText = arc4random() % 2 == 0 ? true : false
        p.titles = ["iPhone", "pizza", "hard drive"]
        p.setNeedsDisplay()
    }

}

