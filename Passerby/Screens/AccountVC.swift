//
//  AccountVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 02. 05..
//

import UIKit
import RxSwift
import RxCocoa

class AccountVC: PBDataLoadingVC {
    private let bag = DisposeBag()
    var viewModel: AccountViewModel!
        
    let scrollView = UIScrollView()
    let contentView = UIView()
    let iconImageView = UIImageView()
    let separatorView = UIView()
    let separatorView2 = UIView()
    
    let nameLabel = PBTitleLabel(textAlignment: .center, fontSize: 38
    )
    let teamLabel = PBTertiaryTitleLabel(textAlignment: .center, fontSize: 26)
    let permissionLabel = PBSecondaryTitleLabel(fontSize: 20)
    let permissionsLabelValue = PBBodyLabelValue(textAlignment: .left)
    let openTicketsLabel = PBSecondaryTitleLabel(fontSize: 20)

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(iconImageView ,nameLabel, teamLabel, separatorView, permissionLabel, permissionsLabelValue, separatorView2, openTicketsLabel)
        configureIconImageView()
        layoutUI()
        configureViewController()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Profile"
        configureUIElements()
    }
    
    
    func configureUIElements() {
        separatorView.backgroundColor = UIColor.systemGray2
        separatorView2.backgroundColor = UIColor.systemGray2
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView2.translatesAutoresizingMaskIntoConstraints = false
        permissionLabel.text = "Permissions:"

        nameLabel.text = viewModel.fullName
        teamLabel.text = viewModel.teamName
        permissionsLabelValue.text = viewModel.permissions
        openTicketsLabel.text = "Open tickets: " + viewModel.openTicketsCount
    }
    
    
    func configureIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if self.traitCollection.userInterfaceStyle == .dark {
            iconImageView.image = UIImage(named: "account-icon-black")
        } else {
            iconImageView.image = UIImage(named: "account-icon-white")
        }
        
        let topConstraintConstant: CGFloat = Constants.DeviceTypes.isiPhoneSE || Constants.DeviceTypes.isiPhone8Zoomed ? 0 : 0
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 200),
            iconImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 10
        let sectionPadding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: sectionPadding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            teamLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: sectionPadding),
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            teamLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamLabel.heightAnchor.constraint(equalToConstant: 20),
            
            separatorView.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 18),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            permissionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 8),
            permissionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            permissionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            permissionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            permissionsLabelValue.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 10),
            permissionsLabelValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            permissionsLabelValue.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            permissionsLabelValue.heightAnchor.constraint(equalToConstant: 20),
            
            separatorView2.topAnchor.constraint(equalTo: permissionsLabelValue.bottomAnchor, constant: 8),
            separatorView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            separatorView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            separatorView2.heightAnchor.constraint(equalToConstant: 1),
            
            openTicketsLabel.topAnchor.constraint(equalTo: separatorView2.bottomAnchor, constant: 18),
            openTicketsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            openTicketsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            openTicketsLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
