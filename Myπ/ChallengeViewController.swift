//
//  ChallengeViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/22.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class ChallengeViewController: ViewController {

    @IBOutlet weak var timeLabel: UILabel!

    var timer:Timer?

    var timeCount = 600 * 10
    let maxTCount = 600 * 10 //秒　* 1秒/インターバル

    override func viewDidLoad() {
        super.viewDidLoad()

        colorUse = false
        skipcount = 0
        setNumber()
        GameStatus = true
        sideLabel.text = "\(passNumbers.count)桁目です"


        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }


    @objc func countDown(){
        timeCount -= 1
        let sec = (timeCount/10)%60
        let min = (timeCount/10)/60
        let formatSec = String(format: "%02d", sec)
        let formatMin = String(format: "%02d", min)
        timeLabel.text = "\(formatMin):\(formatSec)"

        if timeCount == 0{
            timer!.invalidate()
            sideLabel.text = "時間切れです"
            GameStatus = false
        }

        if count == 1000{
            timer?.invalidate()
            sideLabel.text = "コンプリート！"
            GameStatus = false
        }

        if GameStatus{}else{
            timer?.invalidate()
            sideLabel.text = "失敗です"
        }
    }



}
