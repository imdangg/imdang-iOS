//
//  Color +.swift
//  imdang
//
//  Created by daye on 11/14/24.
//

import UIKit

extension UIColor {
    // MARK: - Gray
    static let grayScale900 = UIColor(hexCode: "#1E1E1E")
    static let grayScale800 = UIColor(hexCode: "#3C3C3C")
    static let grayScale700 = UIColor(hexCode: "#5B5B5B")
    static let grayScale600 = UIColor(hexCode: "#797979")
    static let grayScale500 = UIColor(hexCode: "#979797")
    static let grayScale400 = UIColor(hexCode: "#A7A7A7")
    static let grayScale300 = UIColor(hexCode: "#BABABA")
    static let grayScale200 = UIColor(hexCode: "#CFCFCF")
    static let grayScale100 = UIColor(hexCode: "#E6E6E6")
    static let grayScale50 = UIColor(hexCode: "#F2F2F2")
    static let grayScale25 = UIColor(hexCode: "#FBFBFB") // Background
    
    static let newLightGrayScale = UIColor(hexCode: "868686")
    
    // MARK: - Orange
    static let mainOrange900 = UIColor(hexCode: "#331500")
    static let mainOrange800 = UIColor(hexCode: "#662A00")
    static let mainOrange700 = UIColor(hexCode: "#994000")
    static let mainOrange600 = UIColor(hexCode: "#CC5500")
    static let mainOrange500 = UIColor(hexCode: "#FF6A00") // Main
    static let mainOrange400 = UIColor(hexCode: "#FF8833")
    static let mainOrange300 = UIColor(hexCode: "#FFA666")
    static let mainOrange200 = UIColor(hexCode: "#FFC399")
    static let mainOrange100 = UIColor(hexCode: "#FFE1CC")
    static let mainOrange50 = UIColor(hexCode: "#FFF0E5")
    
    // MARK: - Other
    static let error = UIColor(hexCode: "#E93528")
    static let darkBlue = UIColor(hexCode: "#11388B")
    static let lightBlue = UIColor(hexCode: "#EDF3FF")
    static let backgroundLightBlue = UIColor(hexCode: "#EBEEFF")
    static let gradientBrown = UIColor(hexCode: "#642E07")

}

// rgb to hex
extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in:. whitespacesAndNewlines)
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Error: Invaild hex format.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
