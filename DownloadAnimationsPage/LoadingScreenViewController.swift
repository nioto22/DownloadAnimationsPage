//
//  ViewController.swift
//  DownloadAnimationsPage
//
//  Created by Antoine Proux on 18/11/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingPourcentLabel: UILabel!
    @IBOutlet weak var wheelImageView: UIImageView!
    @IBOutlet weak var wheelGrayImageView: UIImageView!
    @IBOutlet weak var wheelContainerView: UIView!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var downloadInformationLabel: UILabel!
    
    
    // progress circle var
    let shapeLayer = CAShapeLayer()
    let shadowLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    let trackColor: UIColor = UIColor(displayP3Red: 140/255, green: 185/255, blue: 224/255, alpha: 0.8)
    let blueColor: UIColor = UIColor(displayP3Red: 20/255, green: 137/255, blue: 191/255, alpha: 1)
    let shadowColor: UIColor = UIColor(displayP3Red: 119/255, green: 173/255, blue: 243/255, alpha: 1)
    
    // timer var
    var dotTimer: Timer?
    var timer:Timer?
    var timeIndex: Double = 0.0
    var timeInterval: Double!
    let timerEndValue: Double = 30.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingPourcentLabel.text = "0%"
        setupDownloadCircle()
        
        startTimer()
        startBackgroundAnimations()
    }
    
    //MARK: - Timer Method
    func startTimer(){
        timeInterval = getRandomTimeInterval()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerUpdated), userInfo: nil, repeats: false)
    }
    
    @objc func timerUpdated(){
        timeIndex += timeInterval
        self.loadingAnimations(Int(timerEndValue * 10), Int(timeIndex * 10))
        
        if timeIndex >= timerEndValue {
            timer?.invalidate()
            timer = nil
            stopBackgroundAnimations()
            loadingPourcentLabel.text = "100%"
            downloadInformationLabel.text = "Téléchargement fini !!"
        } else {
            startTimer()
        }
    }
    
    func getRandomTimeInterval() -> Double {
        return Double.random(in: 0.1 ..< 1.0)
    }
    //MARK: - Layout methods
    func setupDownloadCircle() {
        let center = view.center
        let radius = 100
        
        // create shadow layer
        let shadowCircularPath = UIBezierPath(arcCenter: center, radius: (CGFloat(radius + 5)), startAngle: -.pi / 2, endAngle: 2 * .pi, clockwise: true)
        shadowLayer.path = shadowCircularPath.cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.strokeColor = shadowColor.cgColor
        shadowLayer.lineWidth = 0
        view.layer.addSublayer(shadowLayer)
        
        // create track layer
        let circularPath = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: -.pi / 2, endAngle: 2 * .pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 10
        view.layer.addSublayer(trackLayer)
        
        // layer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = blueColor.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = CAShapeLayerLineCap.round   // Rounded stroke
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        
        view.bringSubviewToFront(downloadLabel)
    }
    
    //MARK: - Animations methods
    func startBackgroundAnimations(){
        shadowProgressCircleAnimation()
        loadingDotsAnimation(index: 0)
    }
    
    func stopBackgroundAnimations(){
        shadowLayer.removeAllAnimations()
        dotTimer?.invalidate()
        dotTimer = nil
    }
    
    func getPourcentOfWork(_ arrayCount: Int, _ index: Int) -> String{
        let pourcent = index * 100 / arrayCount
        return "\(Int(pourcent))%"
    }
    
    
    func loadingAnimations(_ total: Int, _ index: Int){
        self.pourcentLabelAnimation(total, index)
        self.pourcentViewAnimation(total, index)
    }
    
    func pourcentLabelAnimation(_ total: Int, _ index: Int){
        let message = self.getPourcentOfWork(total, index)
        self.loadingLabelAnimation()
        self.loadingPourcentLabel.text = message
    }
    
    func pourcentViewAnimation(_ total: Int, _ index: Int){
        let currentValue = Double(index * 100 / total)
        let progress = Float(currentValue / 100)
        print(progress)
        self.shapeLayer.strokeEnd = CGFloat(progress * 0.8)
        self.wheelImageView.alpha = CGFloat(progress)
    }

    func loadingLabelAnimation(){
        self.loadingPourcentLabel.scaleWithFactorOfSize(duration: 0.3, delay: 0.0, factor: 1.3)
        self.loadingPourcentLabel.scaleWithFactorOfSize(duration: 0.2, delay: 0.3, factor: 1.0)
    }
    
    func shadowProgressCircleAnimation(){
        let shadowWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        shadowWidthAnimation.toValue = 20
        shadowWidthAnimation.duration = 0.8
        shadowWidthAnimation.repeatCount = 1000
        shadowWidthAnimation.autoreverses = true
        shadowWidthAnimation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        shadowLayer.add(shadowWidthAnimation, forKey: "shadowWidthAnimation")
    }
    
    func loadingDotsAnimation(index: Int){
        downloadLabel.text = "Chargement "
        dotTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            var string: String {
                switch self.downloadLabel.text {
                case "Chargement ":     return "Chargement ."
                case "Chargement .":       return "Chargement .."
                case "Chargement ..":      return "Chargement ..."
                case "Chargement ...":     return "Chargement ."
                default:                return "Chargement "
                }
            }
            self.downloadLabel.text = string
        }
    }
}

