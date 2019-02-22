//
//  ViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/09.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var fontColor = #colorLiteral(red: 1, green: 0.7451832748, blue: 0.07623420159, alpha: 0.85)
    var backgroundColor = #colorLiteral(red: 0.666592598, green: 0.6667093039, blue: 0.666585207, alpha: 1)
    var colors = [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10]
    let userDefaults = UserDefaults.standard

    var skipcount = 0
    var GameStatus = false
    var count = 0
    var passNumbers = [String]()

    let spaceRemovedPie = pie.replacingOccurrences(of: " ", with: "")

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
        colorSet = userDefaults.dictionary(forKey: "KEY_colorSet") as! [String : Int]
        colorUse = userDefaults.bool(forKey: "KEY_colorUse")

        for i in spaceRemovedPie{
            PieArray.append(String(i))
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        skipcount = UserDefaults.standard.integer(forKey: "KEY_skipcount")
        setNumber()
        sideLabel.text = "\(passNumbers.count)桁目です"
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
        print(passNumbers.count/100 + 1)
        return passNumbers.count/100 + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        print(indexPath.section)
        var PNs = [String]()
        if passNumbers.count - indexPath.section*100 > 100{
            PNs += passNumbers[indexPath.section*100...indexPath.section*100 + 99]

            label.text = PNs[indexPath.row]

        }else{
            PNs += passNumbers[indexPath.section*100...passNumbers.count - 1]
            label.text = PNs[indexPath.row]
        }

        if colorUse{
            if let colorSet = colorSet[passNumbers[indexPath.row]]{
                label.textColor = colors[colorSet]
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let CVscrwidth = self.collectionView.frame.width
        return CGSize(width: CVscrwidth/10, height: CVscrwidth/9)
    }

    func setContentOffset(){
        let CVscrwidth = self.collectionView.frame.width
        let offset = CGPoint(x: 0, y: CVscrwidth/9 * CGFloat(passNumbers.count/10 - 5))
        collectionView.setContentOffset(offset, animated: true)
    }
    

    @IBAction func numberTapped(_ sender: UIButtonAnimated){
        if GameStatus{
            if String(sender.tag) == PieArray[count + skipcount]{
                count += 1
                self.passNumbers.append(String(sender.tag))
                self.collectionView.reloadData()
                sideLabel.text = "\(passNumbers.count)桁目です"
            }else{
                GameStatus = false
                count = 0
                sideLabel.text = "\(passNumbers.count)桁で終了"
                passNumbers.removeAll()
                setNumber()
            }
        }else if sender.tag == Int(PieArray[skipcount]){
            GameStatus = true
            passNumbers.append(String(sender.tag))
            sideLabel.text = "\(passNumbers.count)桁目です"
            count += 1
        }
        self.collectionView.reloadData()
        DispatchQueue.main.async {
            self.setContentOffset()
        }

    }

    func setNumber(){
        passNumbers.append("3.")
        if skipcount != 0{
            for i in 0 ... skipcount-1{
                passNumbers.append(PieArray[i])
            }
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
}


class UIButtonAnimated: UIButton {
    var selectView: UIView! = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        myInit()
    }

    func myInit() {
        // 角を丸くする
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        // ボタンを押している時にボタンの色を暗くするためのView
        selectView = UIView(frame: self.bounds)
        selectView.backgroundColor = UIColor.black
        selectView.alpha = 0.0
        self.addSubview(selectView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        selectView.frame = self.bounds
    }

    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches as! Set<UITouch>, with: event)
        self.touchStartAnimation()
    }

    func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches as! Set<UITouch>, with: event)
        self.touchEndAnimation()
    }

    func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches as! Set<UITouch>, with: event)
        self.touchEndAnimation()
    }

    private func touchStartAnimation(){
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {() -> Void in
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95);
                        self.alpha = 0.7
        },
                       completion: nil
        )
    }
    private func touchEndAnimation(){
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {() -> Void in
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                        self.alpha = 1
        },
                       completion: nil
        )
    }


}
