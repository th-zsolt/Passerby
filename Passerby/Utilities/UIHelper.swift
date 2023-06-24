//
//  UIHelper.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 07. 02..
//

import UIKit

enum UIHelper {
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let itemWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowlayout.itemSize = CGSize(width: itemWidth, height: 110)
        
        return flowlayout
    }
    
}
