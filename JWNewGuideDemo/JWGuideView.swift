//
//  JWGuideView.swift
//  JWNewGuideDemo
//
//  Created by JessieWu on 2018/7/31.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

import UIKit

enum JWGuideInfoLocationType {
    case LeftTop
    case RightTop
    case CenterTop
    case LeftBottom
    case RightBottom
    case CenterBottom
}

class JWGuideInfo: NSObject {
    var insetsEdge: UIEdgeInsets = UIEdgeInsetsMake(-8.0, -8.0, -8.0, -8.0)
    var corneRadius: CGFloat = 20.0
    var baseFrame: CGRect = CGRect.zero
    var focusView: UIView?
    var introImage: UIImage?
    var locationType: JWGuideInfoLocationType = .LeftTop
    //focus view在navgation bar，且navigation bar是自定义的
    var customizeNavBar: Bool = false
}

class JWGuideView: UIView {
    
    private let horizontalOffset: CGFloat = 20.0
    private let verticalOffset: CGFloat = 10.0
    
    private var guideInfos: [JWGuideInfo] = []
    private var currentIndex: NSInteger = 0
    private lazy var maskLayer: CAShapeLayer = CAShapeLayer.init()
    private lazy var guideInfoImageView: UIImageView = UIImageView.init()
    
    private var baseFrame: CGRect = CGRect.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.guideInfoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(code:) has not been implemented.")
    }

    // MARK: public method
    public func showGuideView(guideInfos: [JWGuideInfo]) -> Void {
        UIApplication.shared.isStatusBarHidden = true
        let window: UIWindow = UIApplication.shared.keyWindow!
        self.frame = window.frame
        window.addSubview(self)
        
        self.guideInfos = guideInfos;
        self.currentIndex = 0;
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.resetUI()
    }
    
    // MARK: UI
    private func resetUI() {
        let guideInfo: JWGuideInfo = self.guideInfos[self.currentIndex];
        guard guideInfo.focusView != nil else {
            return
        }
        
        self.baseFrame = guideInfo.focusView!.frame
        self.baseFrame.origin.y += guideInfo.customizeNavBar ? UIApplication.shared.statusBarFrame.height : 0.0
        self.findBaseFrame(view: guideInfo.focusView)
        self.drawVisualPath(guideInfo: guideInfo)
        self.updateGuideImageLocation(guideInfo: guideInfo)
    }
    
    // MARK: private methods
    //find focus view frame
    private func findBaseFrame(view: UIView?) {
        let superView: UIView? = view?.superview
        if superView != nil && superView?.superview != nil && !(superView?.superview is UIWindow) {
            let frame = superView!.frame;
            baseFrame.origin.x += frame.minX
            baseFrame.origin.y += frame.minY
            self.findBaseFrame(view: view!.superview)
        } else {
            return
        }
    }
    //visual frame
    private func getVisualFrame(guideInfo: JWGuideInfo) -> CGRect {

        var visualFrame: CGRect = CGRect.zero
        let insetsEdge: UIEdgeInsets = guideInfo.insetsEdge
        visualFrame.origin.x = self.baseFrame.origin.x + insetsEdge.left
        visualFrame.origin.y = self.baseFrame.origin.y + insetsEdge.top
        visualFrame.size.width = self.baseFrame.width - (insetsEdge.left + insetsEdge.right)
        visualFrame.size.height = self.baseFrame.height - (insetsEdge.top + insetsEdge.bottom)
        return visualFrame
    }
    
    //visual path
    private func drawVisualPath(guideInfo: JWGuideInfo) {
        let fromPath: CGPath? = self.maskLayer.path
        self.maskLayer.frame = self.frame
        self.maskLayer.fillColor = UIColor.black.cgColor
        
        let visualFrame: CGRect = self.getVisualFrame(guideInfo: guideInfo)
        let visualPath: UIBezierPath = UIBezierPath.init(roundedRect: visualFrame, cornerRadius: guideInfo.corneRadius)
        let toPath: UIBezierPath = UIBezierPath.init(rect: self.frame)
        toPath.append(visualPath)
        
        self.maskLayer.path = toPath.cgPath
        self.maskLayer.fillRule = "even-odd"
        self.layer.mask = self.maskLayer
        
        //动画
        let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "path")
        animation.fromValue = fromPath
        animation.toValue = toPath.cgPath
        animation.duration = 0.2
    }
    
    //guideinfo image location
    private func updateGuideImageLocation(guideInfo: JWGuideInfo) {
        let guideImage = guideInfo.introImage
        let visualFrame: CGRect = self.getVisualFrame(guideInfo: guideInfo)
        let imageWidth: CGFloat = guideImage!.size.width
        let imageHeight: CGFloat = guideImage!.size.height
        
        var imageViewFrame: CGRect = self.guideInfoImageView.frame
        imageViewFrame.size = guideImage!.size
        self.guideInfoImageView.frame = imageViewFrame
        self.guideInfoImageView.image = guideImage
        let locationType: JWGuideInfoLocationType = guideInfo.locationType
        switch locationType {
        case .LeftTop:
            imageViewFrame.origin.x = self.horizontalOffset
            imageViewFrame.origin.y = visualFrame.maxY + self.verticalOffset
        case .RightTop:
            imageViewFrame.origin.x = self.frame.width - imageWidth - self.horizontalOffset
            imageViewFrame.origin.y = visualFrame.maxY + self.verticalOffset
        case .CenterTop:
            imageViewFrame.origin.x = visualFrame.minX + visualFrame.width / 2 - imageWidth / 2
            imageViewFrame.origin.y = visualFrame.maxY + self.verticalOffset
        case .LeftBottom:
            imageViewFrame.origin.x = self.horizontalOffset
            imageViewFrame.origin.y = visualFrame.minY - self.verticalOffset - imageHeight
        case .RightBottom:
            imageViewFrame.origin.x = self.frame.width - imageWidth - self.horizontalOffset
            imageViewFrame.origin.y = visualFrame.minY - self.verticalOffset - imageHeight
        case .CenterBottom:
            imageViewFrame.origin.x = visualFrame.minX + visualFrame.width / 2 - imageWidth / 2
            imageViewFrame.origin.y = visualFrame.minY - self.verticalOffset - imageHeight
//        default:
//            break
        }
        
        //动画
        UIView.animate(withDuration: 0.3) {
            self.guideInfoImageView.frame = imageViewFrame
        }
        
        self.setNeedsLayout()
    }
    
    // MARK: actions & events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.currentIndex == self.guideInfos.count - 1 {
            self.removeFromSuperview()
            UIApplication.shared.isStatusBarHidden = false
        } else {
            self.currentIndex += 1
            self.resetUI()
        }
    }

}
