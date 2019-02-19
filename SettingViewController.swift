//
//  SettingViewController.swift
//  Myπ
//
//  Created by 123 on 2019/02/18.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var skipCountLabel: UILabel!
    @IBOutlet weak var skipCountStepper: UIStepper!
    let color = #colorLiteral(red: 0.1793359518, green: 0.607385695, blue: 0.9852330089, alpha: 1)


    let userDefaults = UserDefaults.standard
    let VC = ViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        skipCountLabel.text = String(userDefaults.integer(forKey: "KEY_skipcount"))
        skipCountStepper.value = userDefaults.double(forKey: "KEY_skipcount")
        VC.skipcount = userDefaults.integer(forKey: "KEY_skipcount")

    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        skipCountLabel.text = String(Int(sender.value))
        userDefaults.set(sender.value, forKey: "KEY_skipcount")
        VC.skipcount = userDefaults.integer(forKey: "KEY_skipcount")

    }
    @IBAction func setButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        sender.tintColor = color

    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch:UITouch in touches{
            let tag = touch.view!.tag
            if tag == 1{
                dismiss(animated: true, completion: nil)
            }
        }
    }

}
