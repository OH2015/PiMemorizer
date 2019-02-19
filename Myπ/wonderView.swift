//
//  wonderView.swift
//  Myπ
//
//  Created by 123 on 2019/02/15.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class wonderView: UIView {
    let color = #colorLiteral(red: 0.9764705896, green: 0.9700892212, blue: 0.2490049194, alpha: 1)
    let spaceReplacedPi = pie.replacingOccurrences(of: " ", with: "")

    let img1 = UIImage(named: "Image-1")
    let img2 = UIImage(named: "Image-2")
    let img3 = UIImage(named: "Image-3")
    let img4 = UIImage(named: "Image-4")
    let img5 = UIImage(named: "Image-5")
    let img6 = UIImage(named: "Image-6")
    let img7 = UIImage(named: "Image-7")
    let img8 = UIImage(named: "Image-8")
    let img9 = UIImage(named: "Image-9")
    let img10 = UIImage(named: "Image-10")

    var comboLabel = UILabel()
    var randomX:Int?
    var randomY:Int?

    let VC = WonderViewController()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.toValue = -Double.pi*2
        rotationAnimation.duration = 1.0
        rotationAnimation.repeatCount = 1
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
        UIView.animate(withDuration: 1.0, animations: {self.alpha = 0}){_ in
            self.removeFromSuperview()
        }
        comboLabel.font = UIFont.boldSystemFont(ofSize: 30)
        comboLabel.frame = CGRect(x: Int(superview!.frame.width/4), y: 100, width: 300, height: 60)
        comboLabel.textColor = color
        if self.tag == currentTag+1{
            combo += 1
            currentTag = self.tag
            addImage(tag: self.tag)
//GAMEOVER
        }else{
            comboLabel.font = UIFont.boldSystemFont(ofSize: 20)
            comboLabel.text = "記録:\(combo)コンボ"
            combo = -1
            currentTag = -1
            let scrSize = superview!.frame.size
            let OVERLabel = UILabel()
            OVERLabel.frame = CGRect(x: scrSize.width/2, y: 200, width: 250, height: 100)
            OVERLabel.font = UIFont.boldSystemFont(ofSize: 30)
            OVERLabel.textColor = UIColor.black
            OVERLabel.text = "GAMEOVER"
            OVERLabel.tag = -200
            superview!.addSubview(OVERLabel)
            comboLabel.tag = -200
            comboLabel.frame = CGRect(x: scrSize.width/2, y: 250, width: 250, height: 100)
            superview!.addSubview(comboLabel)
            for subview in superview!.subviews{
                if subview.tag != -200{
                subview.removeFromSuperview()
                }
            }

        }
    }

    func addImage(tag: Int){
        let screenSize = superview?.frame.size
        randomX = Int.random(in: 0...Int(screenSize!.width)-100)
        randomY = Int.random(in: 50...Int(screenSize!.height)-100)

        for i in spaceReplacedPi{
            PieArray.append(String(i))
        }
        DispatchQueue.main.async {
            for subview in (self.superview?.subviews)!{
                if subview.tag == -100{
                    subview.removeFromSuperview()
                }
            }
        }


        if combo < 5{
            comboLabel.text = " "
        }else if combo < 10{
            comboLabel.text = "\(combo)Combo"
            comboLabel.font = UIFont.boldSystemFont(ofSize: 40)
            comboLabel.tag = -100
        }else{
            self.comboLabel.text = "\(combo)Combo!"
            self.comboLabel.font = UIFont.boldSystemFont(ofSize: 50)
            comboLabel.tag = -100

            let imgArray = [img1,img2,img3,img4,img5,img6,img7,img8,img9,img10]
            imgIndex = Int(PieArray[tag])!
            print("imgIndex\(imgIndex)")
            print("tag\(tag)")
            let Image = UIImageView(image: imgArray[imgIndex])
            Image.contentMode = UIImageView.ContentMode.scaleAspectFill
            Image.alpha = 0.8
            Image.frame = CGRect(x: randomX!, y: randomY!, width: 100, height: 100)
            superview!.addSubview(Image)

        }
        DispatchQueue.main.async {
            self.superview!.addSubview(self.comboLabel)
        }


    }

}
