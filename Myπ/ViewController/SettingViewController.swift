//
//  SettingViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/18.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var skipCountLabel: UILabel!
    @IBOutlet weak var skipCountStepper: UIStepper!
    @IBOutlet weak var colorSwitch: UISwitch!

    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var numberCollectionView: UICollectionView!

    let checkingColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let backGroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    let numBackgroundColor = #colorLiteral(red: 0.5153377135, green: 0.620017712, blue: 0.8072057424, alpha: 0.9358037243)
    let numCheckingColor = #colorLiteral(red: 0.3731030401, green: 0.4495403372, blue: 0.585606496, alpha: 0.8944777397)
    var selectingNumber:Int?
    var selectingColor:Int?
    let userDefaults = UserDefaults.standard
    let VC = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorUse = userDefaults.bool(forKey: "KEY_colorUse")

        colorSet = self.userDefaults.dictionary(forKey: "KEY_colorSet") as! [String : Int]
        let count = userDefaults.integer(forKey: "KEY_skipcount")
        skipCountLabel.text = String(count)
        skipCountStepper.value = Double(count)
        skipcount = count

        if colorUse{
            colorSwitch.isOn = true
        }else{
            colorSwitch.isOn = false
        }

        self.numberCollectionView.delegate = self
        self.numberCollectionView.dataSource = self
        self.colorCollectionView.delegate = self
        self.colorCollectionView.dataSource = self

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == numberCollectionView{
            return 10
        }else{
            return 14
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if !colorUse{cell.isUserInteractionEnabled = false}else{cell.isUserInteractionEnabled = true}
        if collectionView == numberCollectionView{
            let label = cell.viewWithTag(1) as! UILabel
            label.text = String(indexPath.row)
            if !colorUse{
                cell.backgroundColor = numBackgroundColor
                label.textColor = .black
                return cell
            }
            if indexPath.row == selectingNumber{
                cell.backgroundColor = numCheckingColor
            }else{
                cell.backgroundColor = numBackgroundColor
            }
            label.textColor = colors[colorSet[String(indexPath.row)]!]
            return cell
        }else{
            let button = cell.viewWithTag(1) as! UIButtonAnimated
            button.backgroundColor = colors[indexPath.row]
            if !colorUse{
                cell.backgroundColor = backGroundColor
                return cell
            }
            if indexPath.row == selectingColor{
                cell.backgroundColor = checkingColor
            }else{
                cell.backgroundColor = backGroundColor
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let scrwidth = collectionView.frame.width
        if collectionView == numberCollectionView{
            return CGSize(width: scrwidth/5, height: scrwidth/5)
        }else{
            return CGSize(width: scrwidth/6, height: scrwidth/6)
        }

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if collectionView == numberCollectionView{
            let label = cell.viewWithTag(1) as! UILabel
            selectingNumber = indexPath.row
            selectingColor = colorSet[String(indexPath.row)]
            label.textColor = colors[colorSet[String(indexPath.row)]!]
        }else{
            selectingColor = indexPath.row
            guard let selectingNumber = selectingNumber else{return}
            colorSet[String(selectingNumber)] = indexPath.row
        }
        numberCollectionView.reloadData()
        colorCollectionView.reloadData()

    }


    
    @IBAction func stepper(_ sender: UIStepper) {
        let count = sender.value
        skipCountLabel.text = String(Int(count))

        skipcount = Int(count)
    }


    @IBAction func ColorButton(_ sender: UISwitch) {
        if sender.isOn{
            colorUse = true
        }else{
            colorUse = false
        }
        numberCollectionView.reloadData()
        colorCollectionView.reloadData()
    }

    @IBAction func random(_ sender: UIButton) {
        let indexs = [Int](0...13)
        let shuffledIndexArray = indexs.shuffled()
        for i in 0...9{
            colorSet[String(i)] = shuffledIndexArray[i]
        }
        numberCollectionView.reloadData()
        colorCollectionView.reloadData()
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch:UITouch in touches{
            let tag = touch.view!.tag
            if tag == 2{
                selectingNumber = -1
                selectingColor = -1
                numberCollectionView.reloadData()
                colorCollectionView.reloadData()
            }
        }
    }

    @IBAction func close(_ sender: Any) {
        userDefaults.set(skipcount, forKey: "KEY_skipcount")
        userDefaults.set(colorUse, forKey: "KEY_colorUse")
        userDefaults.set(colorSet, forKey: "KEY_colorSet")
        dismiss(animated: true, completion: nil)
    }

}
