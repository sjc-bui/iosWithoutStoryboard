//
//  UIButtonExt.swift
//  iosWithoutStoryboard
//
//  Created by quan bui on 2021/05/11.
//

import UIKit

extension UIButton {
    func RoundAndWeight(title: String, size: CGFloat, style: UIFont.Weight, background: UIColor) {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 4
        self.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: style)
        self.backgroundColor = background
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
}
