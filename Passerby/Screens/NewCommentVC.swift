//
//  NewCommentVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 07. 09..
//

import Foundation
import RxCocoa
import RxSwift

class NewCommentVC: PBDataLoadingVC {
    
    private let bag = DisposeBag()
    var viewModel: NewCommentViewModel!
    
    let commentTextView = PBTextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 200.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUIElements()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "New Comment"
    
        view.addSubview(commentTextView)
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addComment))
        navigationItem.rightBarButtonItem = saveButton
        
        saveButton.isEnabled = false
        
        commentTextView.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledCommentTextSubject).disposed(by: bag)
        
        viewModel.isValid()
            .bind(to: saveButton.rx.isEnabled).disposed(by: bag)
        
        saveButton.rx.tap.bind(to: viewModel.addCommentButtonClicked).disposed(by: bag)
        
        viewModel.presentError.subscribe(onNext: { error in
            self.presentPBAlert(title: "Bad stuff happened", message: error, buttonTitle: "Ok")
        }).disposed(by: bag)
        
    }

    @objc func addComment() { // Do not delete this, needed for the selector
    }
    
    
    func configureUIElements() {
        
        let padding: CGFloat = 24
               
        NSLayoutConstraint.activate([
            commentTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            commentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            commentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            commentTextView.heightAnchor.constraint(equalToConstant: 170)
            ])
    }
}
