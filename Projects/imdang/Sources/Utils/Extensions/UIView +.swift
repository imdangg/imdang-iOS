//
//  UIView +.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/18/25.
//

import UIKit

extension UIView {
    
    func applyTopBlur() {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -20)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 20
        self.layer.masksToBounds = false
    }
}
