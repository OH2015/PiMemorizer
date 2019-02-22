//
//  WonderViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/15.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit


var imgIndex = 0
var currentTag = -1
var combo = 0

class WonderViewController: UIViewController {

    @IBOutlet weak var button: UIButton!

    let img1 = UIImage(named: "Image-1")
    let img2 = UIImage(named: "Image-2")
    let img3 = UIImage(named: "Image-3")
    let img4 = UIImage(named: "Image-4")
    let img5 = UIImage(named: "Image-5")
    let img6 = UIImage(named: "Image-6")
    let img7 = UIImage(named: "Image-7")
    let img8 = UIImage(named: "Image-8")
    let img9 = UIImage(named: "Image-9")

    var timer:Timer?
    let spaceRemovedPie = pie.replacingOccurrences(of: " ", with: "")
    let userDefaults = UserDefaults.standard

    var count = 0


    var colors = [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorSet = userDefaults.dictionary(forKey: "KEY_colorSet") as! [String : Int]
        PieArray.append("3.")

        for i in spaceRemovedPie{
            PieArray.append(String(i))
        }

    }

    @IBAction func buttonTapped(sender: UIButton) {
        sender.removeFromSuperview()

        addSubview()
    }

    @objc func addSubview(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.5 - Double(Double(count)/1000), target: self, selector: #selector(addSubview), userInfo: nil, repeats: true)
        if combo == -1{
            timer?.invalidate()
            combo = 0
            return
        }
        let height = view.frame.height
        let width = view.frame.width

        let myView = wonderView()
        let myLab = wonderLabel()

        let randomX = Random(10, Int(width)-100)
        let randomY = Random(50, Int(height)-100)

        myView.frame = CGRect(x: randomX, y: randomY, width: 100, height: 100)
        myView.addSubview(myLab)
        myView.tag = count

        myLab.text = String(PieArray[count])
        if colorUse{
            myLab.textColor = colors[colorSet[PieArray[count]]!]
        }

        myLab.minimumScaleFactor = 0.3
        myLab.font = UIFont.boldSystemFont(ofSize: 40)
        myLab.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        myLab.isUserInteractionEnabled = true
        myLab.adjustsFontSizeToFitWidth = true

        for i in (-1 ... count-1).reversed(){
            if let preview = view.viewWithTag(i){
                view.insertSubview(myView, belowSubview: preview)
                break
            }
            if i == -1{
                view.addSubview(myView)
            }
        }

        var counter = 0
        let maxCounter = 500

        let transX = CGFloat(self.Random(10-randomX, Int(width-100)-randomX))
        let transY = CGFloat(self.Random(50-randomY, Int(height-100)-randomY))

        let currentX = myView.frame.origin.x
        let currentY = myView.frame.origin.y

        //回転させる
        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.toValue = Double.pi*2
        rotationAnimation.duration = 5.0
        rotationAnimation.repeatCount = 1
        myView.layer.add(rotationAnimation, forKey: "rotationAnimation")

        //0.01秒ごとに動かす
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){timer in
            if counter >= maxCounter{
                timer.invalidate()}
            myView.frame.origin = CGPoint(
                x: currentX + transX * CGFloat(counter)/CGFloat(maxCounter),
                y: currentY + transY * CGFloat(counter)/CGFloat(maxCounter))
            counter += 1
        }
        count += 1
    }

    func Random(_ pre:Int,_ end:Int)->Int{
        return Int.random(in: pre ... end)
    }

    func reset(){
        timer?.invalidate()
        timer = nil
        count = 0
        for subView in self.view.subviews{
            if subView.tag != -2{
                subView.removeFromSuperview()
            }
        }
    }



}
