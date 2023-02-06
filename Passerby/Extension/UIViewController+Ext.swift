//
//  UIViewController+Ext.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 02. 28..
//

import UIKit

extension UIViewController {
    
    func presentPBAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = PBAlertVC(title: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
    func presentDefaultError() {
        let alertVC = PBAlertVC(title: "Something went wrong",
                                message: "We were unable to complete your task at this time.",
                                buttonTitle: "Ok")
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
    
}
