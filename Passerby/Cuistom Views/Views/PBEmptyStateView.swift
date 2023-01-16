//
//  PBEmptyStateView.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 05..
//

import UIKit

class PBEmptyStateView: UIView {

    let messageLabel = PBTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configure() {
        
    }
    
    
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel

        let labelCenterYConstant: CGFloat = Constants.DeviceTypes.isiPhoneSE || Constants.DeviceTypes.isiPhone8Zoomed ? -80 : -150
        let messageLabelCenterYConstraint = messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant)
        messageLabelCenterYConstraint.isActive = true

        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }


    private func configureLogoImageView() {
        logoImageView.image = Constants.Images.logo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        let logoBottomYConstraint: CGFloat = Constants.DeviceTypes.isiPhoneSE || Constants.DeviceTypes.isiPhone8Zoomed ? 80 : 40
        let logoImageViewBottom = logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomYConstraint)
        logoImageViewBottom.isActive = true

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
        ])
    }
}
