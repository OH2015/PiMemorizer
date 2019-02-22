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
    @IBOutlet weak var life1: UIImageView!
    @IBOutlet weak var life2: UIImageView!
    @IBOutlet weak var life3: UIImageView!

    var timer:Timer?

    var timeCount = 600 * 10
    let maxTCount = 600 * 10 //秒　* 1秒/インターバル

    override func viewDidLoad() {
        super.viewDidLoad()

        colorUse = false
        skipcount = 0
        setNumber()
        GameStatus = true
        life = 3
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
        drawLife()

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

    func drawLife(){
        switch life {
        case 1:life2.isHidden = true
        case 2:life3.isHidden = true
        case 3:life1.isHidden = false
        life2.isHidden = false
        life3.isHidden = false
        default:
            life1.isHidden = true
            life2.isHidden = true
            life3.isHidden = true
        }
    }



}
