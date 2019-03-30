//
//  ViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/09.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,AVAudioPlayerDelegate{

    let userDefaults = UserDefaults.standard

    var GameStatus = false
    var count = 0
    var passNumbers = [String]()
    var offset:CGPoint!

    var audioPlayer:AVAudioPlayer!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sideLabel: UILabel!

    @IBOutlet weak var button0: UIButtonAnimated!
    @IBOutlet weak var button1: UIButtonAnimated!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        collectionView.addGestureRecognizer(doubleTapGesture)
        colorSet = userDefaults.dictionary(forKey: "KEY_colorSet") as! [String : Int]
        colorUse = userDefaults.bool(forKey: "KEY_colorUse")
        skipcount = userDefaults.integer(forKey: "KEY_skipcount")
        PieArray.removeAll()
        for i in pie{
            PieArray.append(String(i))
        }
        let scrwidth = self.view.frame.width
        cellWidth = scrwidth/8
        cellHeight = scrwidth/8

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        setNumber()

        let audioPath = Bundle.main.path(forResource: "typewriter", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        }catch{
            print("mp3読み込み失敗")
        }

        audioPlayer.delegate = self
        audioPlayer.volume = 0.9
        audioPlayer.prepareToPlay()
    }

    override func viewDidLayoutSubviews() {
        setContentOffset()
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
        let number = numbersInSection[indexPath.row]
        label.text = number

        if colorUse{
            if let colorIndex = colorSet[number]{
                label.textColor = colors[colorIndex]
            }
            if indexPath.section == 0 && indexPath.row == 0{
                label.textColor = colors[colorSet["3"]!]
            }
        }

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
            audioPlayer.currentTime = 0.1
            audioPlayer.play()
            if String(sender.tag) == PieArray[count]{
                count += 1
                self.passNumbers.append(String(sender.tag))
                self.collectionView.reloadData()
                offset.y += cellHeight/8
                if passNumbers.count%100 == 0{offset.y += 30 + cellHeight/8 * 4}
                setContentOffset()
            }
        }else if sender.tag == Int(PieArray[skipcount]){
            audioPlayer.currentTime = 0.1
            audioPlayer.play()
            GameStatus = true
            passNumbers.append(String(sender.tag))
            sideLabel.text = "\(count)digit"
            count += 1
            self.collectionView.reloadData()
        }
        sideLabel.text = "\(count)digit"

    }

    func setNumber(){
        count += skipcount
        passNumbers.removeAll()
        passNumbers.append("3.")
        if skipcount != 0{
            for i in 0 ... skipcount-1{
                passNumbers.append(PieArray[i])
            }
        }
        let section = passNumbers.count/100
        offset = CGPoint(x: 0, y: cellHeight * CGFloat(((passNumbers.count + section * 4)/8) - 4) + CGFloat(section * 30))
        sideLabel.text = "\(count)digit"
    }

    @objc func doubleTap(_ gesture: UITapGestureRecognizer) {
        setContentOffset()
    }

}

//    func colorToImage(color:UIColor)->UIImage{
//        let rect = CGRect(x:0, y:0, width:1.0,height: 1.0)
//        UIGraphicsBeginImageContext(rect.size)
//        let context:CGContext = UIGraphicsGetCurrentContext()!
//
//        context.setFillColor(color.cgColor)
//        context.fill(rect)
//
//        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        return image
//    }



