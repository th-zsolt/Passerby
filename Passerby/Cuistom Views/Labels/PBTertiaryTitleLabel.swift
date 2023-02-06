//
//  PBTertiaryTitleLabel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 02. 26..
//

import UIKit

class PBTertiaryTitleLabel: UILabel {

        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        convenience init(textAlignment:NSTextAlignment, fontSize: CGFloat) {
            self.init(frame: .zero)
            self.textAlignment = textAlignment
            self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
        
        
        private func configure() {
            textColor = .secondaryLabel
            adjustsFontSizeToFitWidth = true
            minimumScaleFactor = 0.9
            lineBreakMode = .byTruncatingTail
            translatesAutoresizingMaskIntoConstraints = false
        }
}

