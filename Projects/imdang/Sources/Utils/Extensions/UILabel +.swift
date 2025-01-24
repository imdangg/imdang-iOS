//
//  UILabel +.swift
//  imdang
//
//  Created by 임대진 on 12/4/24.
//

import UIKit

extension UILabel {
//    /// 고정값 간격
//    func setLineSpacing(spacing: CGFloat) {
//        guard let text = text else { return }
//
//        let attributeString = NSMutableAttributedString(string: text)
//        let style = NSMutableParagraphStyle()
//        style.lineSpacing = spacing
//        attributeString.addAttribute(.paragraphStyle,
//                                     value: style,
//                                     range: NSRange(location: 0, length: attributeString.length))
//        attributedText = attributeString
//    }
//    
//    /// 비율 간격
//    func setLineSpacing(lineHeightMultiple: CGFloat) {
//        guard let text = self.text else { return }
//        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple
//        
//        let attributedString = NSAttributedString(string: text, attributes: [
//            .paragraphStyle: paragraphStyle
//        ])
//        
//        self.attributedText = attributedString
//    }
    
    /// 피그마 Line height 그대로 넣으면 적용됨
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat, textAlignment: NSTextAlignment = .left) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
            self.textAlignment = textAlignment
        }
    }
}
