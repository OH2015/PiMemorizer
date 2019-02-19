//
//  titleViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/17.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class titleViewController: UIInputViewController {
    @IBOutlet weak var imageView: UIImageView!

    var currentScale:CGFloat = 1.0
    var colorSet = [String:Int]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...9{
            colorSet[String(i)] = i
        }
        userDefaults.register(defaults: ["KEY_colorSet":colorSet])

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        imageView.addGestureRecognizer(pinchGesture)

    }

    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
        // imageViewを拡大縮小する
        // ピンチ中の拡大率は0.3〜2.5倍、指を離した時の拡大率は0.5〜2.0倍とする
        switch sender.state {
        case .began, .changed:
            // senderのscaleは、指を動かしていない状態が1.0となる
            // 現在の拡大率に、(scaleから1を引いたもの) / 10(補正率)を加算する
            currentScale = currentScale + (sender.scale - 1) / 10
            // 拡大率が基準から外れる場合は、補正する
            if currentScale < 1.0 {
                currentScale = 1.0
            } else if currentScale > 2.5 {
                currentScale = 2.5
            }
            // 計算後の拡大率で、imageViewを拡大縮小する
            imageView.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
        default:
            // ピンチ中と同様だが、拡大率の範囲が異なる
            if currentScale > 2.0 {
                currentScale = 2.0
            }

            // 拡大率が基準から外れている場合、指を離したときにアニメーションで拡大率を補正する
            // 例えば指を離す前に拡大率が0.3だった場合、0.2秒かけて拡大率が0.5に変化する
            UIView.animate(withDuration: 0.2, animations: {
                self.imageView.transform = CGAffineTransform(scaleX: self.currentScale, y: self.currentScale)
            }, completion: nil)

        }
    }


}
