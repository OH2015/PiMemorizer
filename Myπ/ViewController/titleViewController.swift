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
    
    @IBOutlet weak var highScoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...9{
            colorSet[String(i)] = i
        }
        uds.register(defaults: ["KEY_colorSet":colorSet,"KEY_colorUse":colorUse,"KEY_highScore":0])
        renewHighScore()
    }

    override func viewDidLayoutSubviews(){
        var admobView = GADBannerView()
        admobView = GADBannerView(adSize:kGADAdSizeBanner)

        let safeArea = self.view.safeAreaInsets.bottom
        admobView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - safeArea - admobView.frame.height)
        admobView.frame.size = CGSize(width:self.view.frame.width, height:admobView.frame.height)

        admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"

        admobView.rootViewController = self
        admobView.load(GADRequest())
        self.view.addSubview(admobView)
    }

    func renewHighScore(){
        let highScore = uds.integer(forKey: KEY.highScore.rawValue)
        highScoreLabel.text = String(highScore)
    }

}
