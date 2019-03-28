//
//  MyUINavigationViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/19.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class MyUINavigationViewController: UINavigationController {
    let color = #colorLiteral(red: 0.9619605698, green: 1, blue: 0.4483916544, alpha: 1)


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()

        //　ナビゲーションバーの背景色
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        // Do any additional setup after loading the view.


    }
    



}
