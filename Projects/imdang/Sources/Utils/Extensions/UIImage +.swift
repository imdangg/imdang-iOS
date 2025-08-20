//
//  UIImage +.swift
//  imdang
//
//  Created by daye on 8/17/25.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
