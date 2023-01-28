//
//  AccountVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 02. 05..
//

import UIKit
import RxSwift
import RxCocoa

class AccountVC: UIViewController {
    private let bag = DisposeBag()
    var viewModel: AccountViewModel!

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let nameLabel = PBTitleLabel(textAlignment: .center, fontSize: 38
    )
    let teamLabel = PBSecondaryTitleLabel(fontSize: 26)
    let permissionLabel = PBSecondaryTitleLabel(fontSize: 20)
    let permissionsLabelValue = PBBodyLabel(textAlignment: .left)
    let openTicketsLabel = PBSecondaryTitleLabel(fontSize: 20)

    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubViews(nameLabel, teamLabel, permissionLabel, permissionsLabelValue, openTicketsLabel)
        layoutUI()
        configureViewController()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = nil
        configureUIElements()
    }
    
    
    func configureUIElements() {
        permissionLabel.text = "Permissions:"

        nameLabel.text = viewModel.fullName
        teamLabel.text = viewModel.teamName
        permissionsLabelValue.text = viewModel.permissions
        openTicketsLabel.text = "Open tickets: " + viewModel.openTicketsCount
    }
    
    
    func layoutUI() {
        let padding: CGFloat = 10
        let sectionPadding: CGFloat = 50
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),
            
            teamLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40),
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            teamLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            teamLabel.heightAnchor.constraint(equalToConstant: 20),
            
            permissionLabel.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: sectionPadding),
            permissionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            permissionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            permissionLabel.heightAnchor.constraint(equalToConstant: 20),
            
            permissionsLabelValue.topAnchor.constraint(equalTo: permissionLabel.bottomAnchor, constant: 10),
            permissionsLabelValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            permissionsLabelValue.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            permissionsLabelValue.heightAnchor.constraint(equalToConstant: 20),
            
            openTicketsLabel.topAnchor.constraint(equalTo: permissionsLabelValue.bottomAnchor, constant: sectionPadding),
            openTicketsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            openTicketsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            openTicketsLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
