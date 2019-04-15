//
//  ChallengeViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/22.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation
import StoreKit

class ChallengeViewController:UIViewController,UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GADRewardBasedVideoAdDelegate,AVAudioPlayerDelegate{

    var GameStatus = false
    var count = 0
    var life = 3
    var nomiss = 0
    var passNumbers = [String]()
    var offset:CGPoint!
    var ismute = false

    var timer:Timer?
    var timeCount = 600 * 10
    let maxTCount = 600 * 10 //秒　* 1秒/インターバル

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sideLabel: UILabel!

    let TEST_ID = "ca-app-pub-3940256099942544/1712485313"
    let AdUnitID = "ca-app-pub-5237111055443143/7355281385"
    let AppID = "1458275259"

    var rewardBasedVideo: GADRewardBasedVideoAd?

    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    var musicPlayer = AVAudioPlayer()

    let volume1:Float = 1.0
    let volume2:Float = 0.3
    let musicvol:Float = 0.6

    let onimg = UIImage(named: "musicOn")
    let offimg = UIImage(named: "musicOff")

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var life1: UIImageView!
    @IBOutlet weak var life2: UIImageView!
    @IBOutlet weak var life3: UIImageView!
    @IBOutlet weak var soundButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubleTapGesture)
        isSoundMute = uds.bool(forKey: KEY.isSoundMute)
        isreviewd = uds.bool(forKey: KEY.isreviewd)

        if isSoundMute{
            soundButton.setImage(offimg, for: .normal)
        }

        PieArray.removeAll()
        for i in pie{
            PieArray.append(String(i))
        }
        let scrwidth = self.view.frame.width
        cellWidth = scrwidth/8
        cellHeight = scrwidth/8

        collectionView.delegate = self
        collectionView.dataSource = self

        setNumber()

        skipcount = 0
        GameStatus = true
        life = 3

        sideLabel.text = "\(passNumbers.count)\(NSLocalizedString("digit", comment: ""))"

        rewardBasedVideo = GADRewardBasedVideoAd.sharedInstance()
        rewardBasedVideo?.delegate = self

        setupRewardBasedVideoAd()

        setPlayer(player: &audioPlayer, contentof: "typewriter", volume: volume1)
        setPlayer(player: &audioPlayer2, contentof: "select04", volume: volume2)
        setPlayer(player: &musicPlayer, contentof: "music1", volume: musicvol)

        musicPlayer.numberOfLoops = -1
        musicPlayer.play()


        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }

    override func viewDidLayoutSubviews() {
        //        setContentOffset()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if passNumbers.count - section*100 > 100{
            return 100
        }
        return passNumbers.count - section*100

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return passNumbers.count/100 + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel

        var numbersInSection = [String]()
        if passNumbers.count - indexPath.section*100 > 100{
            numbersInSection += passNumbers[indexPath.section*100...indexPath.section*100 + 99]
        }else{
            numbersInSection += passNumbers[indexPath.section*100...passNumbers.count - 1]
        }
        label.text = numbersInSection[indexPath.row]
        label.textColor = .white

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func setContentOffset(){
        collectionView.setContentOffset(offset, animated: true)
    }


    @IBAction func numberTapped(_ sender: UIButtonAnimated){
        if GameStatus{
            if String(sender.tag) == PieArray[count]{
                audioPlayer.stop()
                audioPlayer.currentTime = 0.1
                audioPlayer.play()
                count += 1
                nomiss += 1
                self.passNumbers.append(String(sender.tag))
                self.collectionView.reloadData()
                sideLabel.text = "\(count)\(NSLocalizedString("digit", comment: ""))"
                offset.y += cellHeight/8
                if passNumbers.count%100 == 0{offset.y += 30 + cellHeight/8 * 4}
                if nomiss == 8{
                    nomiss = 0
                    heal()
                }
                if count >= 999{
                    timer?.invalidate()
                    sideLabel.text = NSLocalizedString("wonderful", comment: "")
                    GameStatus = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        self.playAd()
                    }
                }
                setContentOffset()
            }else{
                audioPlayer2.currentTime = 0
                audioPlayer2.play()
                nomiss = 0
                life -= 1
                drawLife()
                if life <= 0{
                    GameStatus = false
                    sideLabel.text = "\(NSLocalizedString("endat", comment: ""))\(count)\(NSLocalizedString("deowari", comment: ""))"
                    let highScore = uds.integer(forKey: KEY.highScore)
                    if count > highScore{
                        uds.set(count, forKey: KEY.highScore)
                        if !isreviewd && count > 30{
                            musicPlayer.stop()
                            instructReview()
                            uds.set(true, forKey: KEY.isreviewd)
                            return
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.playAd()
                    }
                }
            }
        }
    }

    func setNumber(){
        passNumbers.removeAll()
        passNumbers.append("3.")
        let section = passNumbers.count/100
        offset = CGPoint(x: 0, y: cellHeight * CGFloat(((passNumbers.count + section * 4)/8) - 4) + CGFloat(section * 30))
        sideLabel.text = "\(passNumbers.count)\(NSLocalizedString("digit", comment: ""))"
    }

    @objc func doubleTap(_ gesture: UITapGestureRecognizer) {
        setContentOffset()
    }

    @objc func countDown(){
        timeCount -= 1
        let sec = (timeCount/10)%60
        let min = (timeCount/10)/60
        let formatSec = String(format: "%02d", sec)
        let formatMin = String(format: "%02d", min)
        timeLabel.text = "\(formatMin):\(formatSec)"


        if timeCount < 60 * 10{
            timeLabel.textColor = .red
        }
        if timeCount < 0{
            timer!.invalidate()
            sideLabel.text = NSLocalizedString("timeUp", comment: "")
            GameStatus = false
            let highScore = uds.integer(forKey: KEY.highScore)
            if count > highScore{
                uds.set(count, forKey: KEY.highScore)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.playAd()
            }
        }
    }

    func heal(){
        if life < 3{
            life += 1
            drawLife()
        }
    }

    func drawLife(){
// 左から123
        switch life {
        case 1:life1.isHidden = true
            life2.isHidden = true
            life3.isHidden = false
        case 2:life1.isHidden = true
            life2.isHidden = false
            life3.isHidden = false
        case 3:life1.isHidden = false
        life2.isHidden = false
        life3.isHidden = false
        default:
            life1.isHidden = true
            life2.isHidden = true
            life3.isHidden = true
        }
    }

    func setupRewardBasedVideoAd(){
        rewardBasedVideo?.load(GADRequest(),withAdUnitID: AdUnitID)
    }

    func playAd(){
        musicPlayer.stop()
        if rewardBasedVideo?.isReady ?? false{
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }else{
            backToTitle()
        }
    }
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }

    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }

    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        backToTitle()

    }

    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }

    @IBAction func tap(_ sender: UIButton) {
        GameStatus = false
        sideLabel.text = "\(NSLocalizedString("endat", comment: ""))\(count)\(NSLocalizedString("deowari", comment: ""))"
        let highScore = uds.integer(forKey: KEY.highScore)
        if count > highScore{
            uds.set(count, forKey: KEY.highScore)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.playAd()
        }
    }

    @IBAction func mute(_ sender: UIButton) {
        if isSoundMute{return}
        if ismute{
            ismute = false
            sender.setImage(onimg, for: .normal)
            musicPlayer.volume = musicvol
        }else{
            ismute = true
            sender.setImage(offimg, for: .normal)
            musicPlayer.volume = 0
        }
    }

    func setPlayer( player:inout AVAudioPlayer,contentof name:String,volume:Float){
        let audioPath = Bundle.main.path(forResource: name, ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        do {
            player = try AVAudioPlayer(contentsOf: audioUrl)
        }catch{
            print("mp3読み込み失敗")
        }
        if isSoundMute{
            player.volume = 0
        }else{
            player.volume = volume
        }
        player.delegate = self
        player.prepareToPlay()
    }

    func instructReview(){
        if #available(iOS 10.3, *){
            SKStoreReviewController.requestReview()
        }else{
            let alert = UIAlertController(title: NSLocalizedString("request", comment: ""), message: NSLocalizedString("submessage", comment: ""), preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel){_ in
                    self.backToTitle()
            })
            alert.addAction(UIAlertAction(title: NSLocalizedString("review", comment: ""), style: .default, handler: {_ in
                guard let url = URL(string: "https://itunes.apple.com/app/id\(self.AppID)?action=write-review") else { return }
                UIApplication.shared.open(url)
                self.dismiss(animated: true)
            }))
            self.present(alert,animated: true)
        }
    }

    func backToTitle(){
        performSegue(withIdentifier: "backSegue", sender: nil)
    }


}
