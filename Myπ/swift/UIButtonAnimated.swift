//
//  UIButtonAnimated.swift
//  Myπ
//
//  Created by 123 on 2019/03/28.
//  Copyright © 2019 123. All rights reserved.
//
import UIKit

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

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
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

