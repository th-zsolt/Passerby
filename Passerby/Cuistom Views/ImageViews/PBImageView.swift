//
//  PBImageView.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 07..
//

import UIKit

class PBImageView: UIImageView {

    let logoImage = Constants.Images.logo

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = logoImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
