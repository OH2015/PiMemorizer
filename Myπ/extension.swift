//
//  extension.swift
//  Myπ
//
//  Created by 123 on 2019/03/26.
//  Copyright © 2019 123. All rights reserved.
//

import UIKit

public extension UICollectionView {

    public func adaptBeautifulGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat) {
        let inset = UIEdgeInsets(
            top: space, left: space, bottom: space, right: space
        )
        adaptBeautifulGrida(numberOfGridsPerRow: numberOfGridsPerRow, gridLineSpace: space, sectionInset: inset)
    }

    public func adaptBeautifulGrida(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat, sectionInset inset: UIEdgeInsets) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard numberOfGridsPerRow > 0 else {
            return
        }
        let isScrollDirectionVertical = layout.scrollDirection == .vertical
        var length = isScrollDirectionVertical ? self.frame.width : self.frame.height
        length -= space * CGFloat(numberOfGridsPerRow - 1)
        length -= isScrollDirectionVertical ? (inset.left + inset.right) : (inset.top + inset.bottom)
        let side = length / CGFloat(numberOfGridsPerRow)
        guard side > 0.0 else {
            return
        }
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = inset
        layout.invalidateLayout()
    }

}


