//
//  LoginVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 07..
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: PBDataLoadingVC {
    var viewModel: LoginViewModel!
    
    private let bag = DisposeBag()
    
//    private let buttonClickedSubject = PublishSubject<Bool>()
//    var buttonClicked: Observable <Bool> {
//        return buttonClickedSubject.asObservable()
//    }
            
    let logoImageView = UIImageView()
    let userNameTextField = PBTextField()
    let callToActionButton = PBButton(color: .systemGreen, title: "Login")
    
    var isLoginNameEntered: Bool {return !userNameTextField.text!.isEmpty }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubViews(logoImageView, userNameTextField, callToActionButton)
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        navigationController?.setToolbarHidden(true, animated: true)
    }

    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Constants.Images.logo
        
        let topConstraintConstant: CGFloat = Constants.DeviceTypes.isiPhoneSE || Constants.DeviceTypes.isiPhone8Zoomed ? 20 : 80
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    
    func configureTextField() {
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureCallToActionButton() {
        callToActionButton.rx.tap
            .withLatestFrom(userNameTextField.rx.text.orEmpty)
            .subscribe(onNext: { loginName in
                if loginName != "" {
                    self.viewModel.getUser(loginName: loginName)
                } else {
                    self.presentPBAlert(title: "Empty Login Name", message: "Please enter the login name", buttonTitle: "Ok")
                }
            })
            .disposed(by: bag)
        
        userNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(userNameTextField.rx.text.orEmpty)
            .subscribe(onNext: { loginName in
                if loginName != "" {
                    self.viewModel.getUser(loginName: loginName)
                } else {
                    self.presentPBAlert(title: "Empty Login Name", message: "Please enter the login name", buttonTitle: "Ok")
                }
            })
            .disposed(by: bag)
        
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    

}


