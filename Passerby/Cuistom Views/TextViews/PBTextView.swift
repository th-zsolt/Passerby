//
//  PBTextView.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 18..
//

import UIKit

class PBTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray3.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .left
        font = UIFont.preferredFont(forTextStyle: .title3)

        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go

        autocorrectionType = UITextAutocorrectionType.yes
        spellCheckingType = UITextSpellCheckingType.yes
    }
}
