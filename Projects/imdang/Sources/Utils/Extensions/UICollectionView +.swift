//
//  UICollectionView +.swift
//  imdang
//
//  Created by 임대진 on 11/26/24.
//

import UIKit

extension UICollectionReusableView: Reusable { }

extension UICollectionView {
    func cellForItem<T: UICollectionViewCell>(atIndexPath indexPath: IndexPath) -> T {
        guard
            let cell = cellForItem(at: indexPath) as? T
        else {
            fatalError("Could not cellForItemAt at indexPath: \(T.reuseIdentifier)")
        }
        return cell
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func register<T>(cell: T.Type) where T: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
}
