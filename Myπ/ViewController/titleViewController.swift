//
//  titleViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/17.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import GoogleMobileAds

class titleViewController: UIViewController{
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var freeModeButton: UIButtonAnimated!
    @IBOutlet weak var challengeModeButton: UIButtonAnimated!
    @IBOutlet weak var highScoreTitleLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var tableButton: UIButton!

    let unitID = "ca-app-pub-5237111055443143/6223885316"

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...9{
            colorSet[String(i)] = i
        }
        uds.register(defaults: [KEY.colorSet:colorSet,KEY.isDifferentColor:isDifferentColor,KEY.highScore:0,KEY.sameColorIndex:0])

        freeModeButton.setTitle(NSLocalizedString("freeMode", comment: ""), for: .normal)
        challengeModeButton.setTitle(NSLocalizedString("challengeMode", comment: ""), for: .normal)
        highScoreTitleLabel.text = NSLocalizedString("highScore", comment: "")
        tableButton.setTitle(NSLocalizedString("table", comment: ""), for: .normal)
        settingButton.setTitle(NSLocalizedString("setting", comment: ""), for: .normal)
        let highScore = uds.integer(forKey: KEY.highScore)
        if highScore == 1000{
            highScoreLabel.textColor = .red
            highScoreLabel.text = "999 Completed"
        }else{
            highScoreLabel.text = "\(highScore)\(NSLocalizedString("digit", comment: ""))"
        }
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)
//        admobView.delegate = nil

        let safeArea = self.view.safeAreaInsets.bottom
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - safeArea - admobView.frame.height)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)

//        admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        admobView.adUnitID = unitID

        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
    }





}
