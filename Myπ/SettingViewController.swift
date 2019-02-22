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

    var colors = [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10]

    let checkingColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    var selectingNumber:Int?
    var selectingColor:Int?
    let userDefaults = UserDefaults.standard
    let VC = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorUse = userDefaults.bool(forKey: "KEY_colorUse")

        colorSet = self.userDefaults.dictionary(forKey: "KEY_colorSet") as! [String : Int]

        skipCountLabel.text = String(userDefaults.integer(forKey: "KEY_skipcount"))
        skipCountStepper.value = userDefaults.double(forKey: "KEY_skipcount")
        skipcount = userDefaults.integer(forKey: "KEY_skipcount")

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
            return 10
        }

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if collectionView == numberCollectionView{
            if indexPath.row == selectingNumber{
                cell.backgroundColor = checkingColor
            }else{
                cell.backgroundColor = .white
            }
            let label = cell.viewWithTag(1) as! UILabel
            label.text = String(indexPath.row)
            label.textColor = colors[colorSet[String(indexPath.row)]!]
            return cell
        }else{
            if indexPath.row == selectingColor{
                cell.backgroundColor = checkingColor
            }
            cell.backgroundColor = colors[indexPath.row]
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
            userDefaults.set(colorSet, forKey: "KEY_colorSet")
        }
        numberCollectionView.reloadData()
        colorCollectionView.reloadData()
    }


    
    @IBAction func stepper(_ sender: UIStepper) {
        skipCountLabel.text = String(Int(sender.value))
        userDefaults.set(sender.value, forKey: "KEY_skipcount")
        skipcount = userDefaults.integer(forKey: "KEY_skipcount")

    }


    @IBAction func ColorButton(_ sender: UISwitch) {
        if sender.isOn{
            colorUse = true
        }else{
            colorUse = false
        }
        userDefaults.set(colorUse, forKey: "KEY_colorUse")
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch:UITouch in touches{
            let tag = touch.view!.tag
            if tag == 1{
                dismiss(animated: true, completion: nil)
            }
            if tag == 2{
                selectingNumber = 10
                selectingColor = 10
                numberCollectionView.reloadData()
                colorCollectionView.reloadData()
            }
        }
    }

}
