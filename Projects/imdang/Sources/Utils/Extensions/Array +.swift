//
//  Array +.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/21/25.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
