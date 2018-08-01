//
//  ViewController.swift
//  JWNewGuideDemo
//
//  Created by JessieWu on 2018/7/31.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var view8: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showGuideViews()
    }
    
    //MARK: methods
    private func showGuideViews() {
        let guideInfo1: JWGuideInfo = JWGuideInfo()
        guideInfo1.introImage = UIImage.init(named: "study_guide")
        guideInfo1.focusView = self.view1
        guideInfo1.locationType = .LeftTop
        let guideInfo2: JWGuideInfo = JWGuideInfo()
        guideInfo2.introImage = UIImage.init(named: "study_guide")
        guideInfo2.focusView = self.view2
        guideInfo2.locationType = .LeftTop
        let guideInfo3: JWGuideInfo = JWGuideInfo()
        guideInfo3.introImage = UIImage.init(named: "study_guide")
        guideInfo3.focusView = self.view3
        guideInfo3.locationType = .LeftTop
        let guideInfo4: JWGuideInfo = JWGuideInfo()
        guideInfo4.introImage = UIImage.init(named: "study_guide")
        guideInfo4.focusView = self.view4
        guideInfo4.locationType = .RightTop
        let guideInfo5: JWGuideInfo = JWGuideInfo()
        guideInfo5.introImage = UIImage.init(named: "study_guide")
        guideInfo5.focusView = self.view5
        guideInfo5.locationType = .CenterTop
        let guideInfo6: JWGuideInfo = JWGuideInfo()
        guideInfo6.introImage = UIImage.init(named: "study_guide")
        guideInfo6.focusView = self.view6
        guideInfo6.locationType = .LeftBottom
        let guideInfo7: JWGuideInfo = JWGuideInfo()
        guideInfo7.introImage = UIImage.init(named: "study_guide")
        guideInfo7.focusView = self.view7
        guideInfo7.locationType = .CenterBottom
        let guideInfo8: JWGuideInfo = JWGuideInfo()
        guideInfo8.introImage = UIImage.init(named: "study_guide")
        guideInfo8.focusView = self.view8
        guideInfo8.locationType = .RightBottom
        
        let guideView: JWGuideView = JWGuideView.init()
        let guideInfos: [JWGuideInfo] = [guideInfo1, guideInfo2, guideInfo3, guideInfo4, guideInfo5, guideInfo6, guideInfo7, guideInfo8]
        guideView.showGuideView(guideInfos: guideInfos)
    }

}

