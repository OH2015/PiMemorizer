//
//  UIView.swift
//  Myπ
//
//  Created by 123 on 2019/02/17.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

extension UILabel {
    func setBackgroundColor(_ color: UIColor, duration: TimeInterval = 0, option: UIView.AnimationOptions = [], completion:(()->())? = nil) {
        var setting: UIView.AnimationOptions = option
        setting.insert(UIView.AnimationOptions.transitionCrossDissolve)
        UIView.transition(with: self, duration: duration, options: setting, animations: {
            self.backgroundColor = color
        }) { (finish) in
            if finish { completion?() }
        }
    }

    func setTextColor(_ color: UIColor, duration: TimeInterval = 0, option: UIView.AnimationOptions = [], completion:(()->())? = nil) {
        var setting: UIView.AnimationOptions = option
        setting.insert(UIView.AnimationOptions.transitionCrossDissolve)
        UIView.transition(with: self, duration: duration, options: setting, animations: {
            self.textColor = color
        }) { (finish) in
            if finish { completion?() }
        }
    }
}


