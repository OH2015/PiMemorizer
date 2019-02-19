//
//  ViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/09.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

var pie = "1415926535 8979323846 2643383279 5028841971 6939937510 5820974944 5923078164 0628620899 8628034825 34211706798214808651 3282306647 0938446095 5058223172 5359408128 4811174502 8410270193 8521105559 6446229489 54930381964428810975 6659334461 2847564823 3786783165 2712019091 4564856692 3460348610 4543266482 1339360726 02491412737245870066 0631558817 4881520920 9628292540 9171536436 7892590360 0113305305 4882046652 1384146951 94151160943305727036 5759591953 0921861173 8193261179 3105118548 0744623799 6274956735 1885752724 8912279381 83011949129833673362 4406566430 8602139494 6395224737 1907021798 6094370277 0539217176 2931767523 8467481846 76694051320005681271 4526356082 7785771342 7577896091 7363717872 1468440901 2249534301 4654958537 1050792279 68925892354201995611 2129021960 8640344181 5981362977 4771309960 5187072113 4999999837 2978049951 0597317328 16096318595024459455 3469083026 4252230825 3344685035 2619311881 7101000313 7838752886 5875332083 8142061717 76691473035982534904 2875546873 1159562863 8823537875 9375195778 1857780532 1712268066 1300192787 6611195909 2164201989"

var PieArray = [String]()
let color1 = #colorLiteral(red: 0.9994240403, green: 0.5774123991, blue: 0.1090971477, alpha: 1)
let color2 = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
let color3 = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
let color4 = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
let color5 = #colorLiteral(red: 0.5947770427, green: 0.9994240403, blue: 0.1722204232, alpha: 1)
let color6 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
let color7 = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
let color8 = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
let color9 = #colorLiteral(red: 0.9994240403, green: 0.1946822109, blue: 0.980411319, alpha: 1)
let color10 = #colorLiteral(red: 0.9994240403, green: 0.04911660341, blue: 0.1450915709, alpha: 1)

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    var fontColor = #colorLiteral(red: 1, green: 0.7451832748, blue: 0.07623420159, alpha: 0.85)
    var backgroundColor = #colorLiteral(red: 0.666592598, green: 0.6667093039, blue: 0.666585207, alpha: 1)
    var colors = [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10]
    

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
        return passNumbers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = passNumbers[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let CVscrwidth = self.collectionView.frame.width
        let CVscrheight = self.collectionView.frame.height
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

    func colorToImage(color:UIColor)->UIImage{
        let rect = CGRect(x:0, y:0, width:1.0,height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContext = UIGraphicsGetCurrentContext()!

        context.setFillColor(color.cgColor)
        context.fill(rect)

        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
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
