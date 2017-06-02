//
//  YXYCustomSliderView.swift
//  自定义sliderView
//
//  Created by 袁向阳 on 17/5/22.
//  Copyright © 2017年 YXY.cn. All rights reserved.
//

import UIKit
import SnapKit

class YXYCustomSliderView: UIControl {
    
    private let kSliderLayerWidth : CGFloat = 20 * kScaleOn375Width
    private let kSliderLayerHeight : CGFloat = 20 * kScaleOn375Height
    private let kTextLayerWidth : CGFloat = 50 * kScaleOn375Width
    private let kTextLayerHeight : CGFloat = 20 * kScaleOn375Height
    private var kBarWidth : CGFloat = 0
    private let kBarHeight : CGFloat = 10 * kScaleOn375Height
    private var maxValue : Int = 0
    private var minValue : Int = 0
    private var leftTextLayer : CATextLayer!
    private var rightTextLayer : CATextLayer!
    private var leftSliderLayer : CALayer!
    private var rightSliderLayer : CALayer!
    private var leftTracking : Bool = false
    private var rightTracking: Bool = false
    private var previousLocation : CGFloat = 0
    private var currentLeftValue : Int = 0
    private var currentRightValue : Int = 0
    
    private lazy var normalBackImageView : UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "quickrent_price_white")?.stretchableImageWithLeftCapWidth(5, topCapHeight: 4))
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    private lazy var highlightedBackImageView : UIImageView = {
        let imageV = UIImageView(image: UIImage(named: "quickrent_price_gray")?.stretchableImageWithLeftCapWidth(5, topCapHeight: 4))
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    
    init(frame: CGRect, MaxValue: Int, MinValue: Int) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        self.maxValue = MaxValue
        self.minValue = MinValue
        self.currentLeftValue = MinValue
        self.currentRightValue = MaxValue
        setUpSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createTextLayer() -> CATextLayer {
        let layer = CATextLayer()
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.fontSize = 12
        layer.foregroundColor = UIColor(red: 19 / 255.0, green: 184 / 255.0, blue: 155 / 255.0, alpha: 1.0).CGColor
        layer.alignmentMode = kCAAlignmentCenter
        return layer
    }
    
    private func createSliderLayer(imageName:String) -> CALayer {
        let layer = CALayer()
        layer.contents = UIImage(named: imageName)?.CGImage
        return layer
    }
    
    private func setUpSubviews() {
        leftTextLayer = createTextLayer()
        leftTextLayer.string = "\(minValue)"
        layer.addSublayer(leftTextLayer)
        leftTextLayer.frame = CGRectMake(0, 5 * kScaleOn375Height, kTextLayerWidth, kTextLayerHeight)
        rightTextLayer = createTextLayer()
        rightTextLayer.string = "\(maxValue)+"
        layer.addSublayer(rightTextLayer)
        rightTextLayer.frame = CGRectMake(frame.width - kTextLayerWidth, leftTextLayer.frame.minY, kTextLayerWidth, kTextLayerHeight)
        
        leftSliderLayer = createSliderLayer("price")
        layer.addSublayer(leftSliderLayer)
        leftSliderLayer.frame = CGRectMake(0.5 * fabs(kSliderLayerWidth - kTextLayerWidth), 0.5 * (frame.height - kSliderLayerHeight) + 5 * kScaleOn375Width, kSliderLayerWidth, kSliderLayerHeight)
        rightSliderLayer = createSliderLayer("price")
        layer.addSublayer(rightSliderLayer)
        rightSliderLayer.frame = CGRectMake(rightTextLayer.frame.minX + 0.5 * fabs(kTextLayerWidth - kSliderLayerWidth), leftSliderLayer.frame.minY, kSliderLayerWidth, kSliderLayerHeight)
        
        addSubview(normalBackImageView)
        addSubview(highlightedBackImageView)
        kBarWidth = frame.width - kTextLayerWidth
        normalBackImageView.frame = CGRectMake(leftSliderLayer.frame.minX + kSliderLayerWidth * 0.5, leftSliderLayer.frame.minY + 0.5 * (kSliderLayerHeight - kBarHeight), kBarWidth, kBarHeight)
        insertSubview(normalBackImageView, atIndex: 0)
        highlightedBackImageView.frame = normalBackImageView.frame
        insertSubview(highlightedBackImageView, atIndex: 1)
    }
}

extension YXYCustomSliderView {
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let locationPoint = touch.locationInView(self)
        previousLocation = locationPoint.x
        leftTracking = leftSliderLayer.frame.contains(locationPoint)
        rightTracking = rightSliderLayer.frame.contains(locationPoint)
        return leftTracking || rightTracking
    }
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let currentLocation = touch.locationInView(self).x
        if leftTracking {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let speed = currentLocation - previousLocation
            previousLocation = currentLocation
            leftSliderLayer.frame.origin.x = max(leftSliderLayer.frame.origin.x + speed, 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth))
            leftSliderLayer.frame.origin.x = min(leftSliderLayer.frame.origin.x, rightSliderLayer.frame.origin.x - kSliderLayerWidth)
            currentLeftValue = Int((leftSliderLayer.frame.origin.x - 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth)) / kBarWidth * CGFloat(maxValue - minValue)) + minValue
            updateSliderBarFunc()
            CATransaction.commit()
            return true
        } else if rightTracking {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let speed = currentLocation - previousLocation
            previousLocation = currentLocation
            rightSliderLayer.frame.origin.x = min(rightSliderLayer.frame.origin.x + speed, rightTextLayer.frame.minX + 0.5 * fabs(kTextLayerWidth - kSliderLayerWidth))
            rightSliderLayer.frame.origin.x = max(rightSliderLayer.frame.origin.x, leftSliderLayer.frame.origin.x + kSliderLayerWidth)
            currentRightValue = Int((rightSliderLayer.frame.origin.x - 0.5 * fabs(kSliderLayerWidth - kTextLayerWidth)) / kBarWidth * CGFloat(maxValue - minValue)) + minValue
            updateSliderBarFunc()
            CATransaction.commit()
            return true
        }
        return false
    }
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        leftTracking = false
        rightTracking = false
    }
    
    private func updateSliderBarFunc() {
        highlightedBackImageView.frame = CGRectMake(leftSliderLayer.frame.origin.x + 0.5 * kSliderLayerWidth, highlightedBackImageView.frame.origin.y, rightSliderLayer.frame.origin.x - leftSliderLayer.frame.origin.x, kBarHeight)
        updateSliderValue()
    }
    private func updateSliderValue() {
        leftTextLayer.string = "\(currentLeftValue)"
        rightTextLayer.string = "\(currentRightValue)"
    }
}
