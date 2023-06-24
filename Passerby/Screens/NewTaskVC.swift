//
//  EditTaskVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 12..
//

import UIKit
import RxSwift
import RxCocoa

class NewTaskVC: PBDataLoadingVC, UIScrollViewDelegate {

    private let bag = DisposeBag()
    var viewModel: NewTaskViewModel!
    
    var prioSegmentedVC: PrioSegmentedVC!
    var weightSegmentedVC: WeightSegmentedVC!
    var ownerPickerVC: TeamMemberPickerVC!
    var dialogVC: PBDialogVC!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let ownerPickerView = UIView()
    let prioView = UIView()
    let weightView = UIView()

    let nameTextField = PBTextField(placeholder: "Enter the title")
    let prioLabel = PBBodyLabel(textAlignment: .left)
    let weightLabel = PBBodyLabel(textAlignment: .left)
    let reporterLabel = PBBodyLabel(textAlignment: .left)
    let reporterLabelValue = PBBodyLabelValue(textAlignment: .left)
    let ownerLabel = PBBodyLabel(textAlignment: .left)
    let creationDateLabel = PBBodyLabel(textAlignment: .left)
    let creationDateLabelValue = PBBodyLabelValue(textAlignment: .left)
    let modificationDateLabel = PBBodyLabel(textAlignment: .left)
    let modificationDateLabelValue = PBBodyLabelValue(textAlignment: .left)
    let descriptionLabel = PBBodyLabel(textAlignment: .left)
    let descriptionTextView = PBTextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 200.0))

       
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureUIElements()
        getInitialTaskValues()
        createDismissKeyboardTapGesture()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = nil
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(modifyTask))
        navigationItem.rightBarButtonItem = saveButton
        
        saveButton.isEnabled = false
        
        nameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledTitleSubject).disposed(by: bag)
        descriptionTextView.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledDescriptionSubject).disposed(by: bag)
        
        viewModel.isValid().bind(to: saveButton.rx.isEnabled).disposed(by: bag)
        
        saveButton.rx.tap.subscribe(onNext: { self.viewModel.createTask() }).disposed(by: bag)
        
        viewModel.presentError.subscribe(onNext: { error in
            self.presentPBAlert(title: "Bad stuff happened", message: error, buttonTitle: "Ok")
        }).disposed(by: bag)

        viewModel.presentCompletionWithId.subscribe(onNext: { id in
            if id != "" { self.presentPBDialog(title: "New task created", message: "Task Id: " + id, buttonTitle: "Ok" )}
        }).disposed(by: bag)
    }
    
    
    @objc func modifyTask() { // Do not delete this, needed for the selector
    }
    
    
    func presentPBDialog(title: String, message: String, buttonTitle: String) {
        self.dialogVC.modalPresentationStyle = .overFullScreen
        self.dialogVC.modalTransitionStyle = .crossDissolve
        self.dialogVC.setValues(title: title, message: message, buttonTitle: buttonTitle)
        self.present(dialogVC, animated: true)
    }
        
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
                         
        NSLayoutConstraint.activate([
             contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
             contentView.heightAnchor.constraint(equalToConstant: 1050)
//             1200
        ])

        contentView.addSubViews(nameTextField, prioLabel, prioView, weightLabel, weightView, reporterLabel, reporterLabelValue, ownerLabel, ownerPickerView, creationDateLabel, creationDateLabelValue,    modificationDateLabel, modificationDateLabelValue, descriptionLabel, descriptionTextView)
        
    }
    
    
    func getInitialTaskValues() {
        _ = self.viewModel.initialTask
            .subscribe(onNext: { initialTask in
                self.creationDateLabelValue.text = initialTask.creationDate
                self.modificationDateLabelValue.text = initialTask.modifiedDate
                self.reporterLabelValue.text = initialTask.creatorName
            })
    }
    
        
    func configureUIElements() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        prioView.translatesAutoresizingMaskIntoConstraints = false
        weightView.translatesAutoresizingMaskIntoConstraints = false
        ownerPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        prioLabel.text = "Priority:"
        weightLabel.text = "Weight:"
        reporterLabel.text = "Reporter:"
        ownerLabel.text = "Owner:"
        creationDateLabel.text = "Created:"
        modificationDateLabel.text = "Last modified:"
        descriptionLabel.text = "Description:"
        
        self.add(childVC: prioSegmentedVC, to: self.prioView)
        self.add(childVC: weightSegmentedVC, to: self.weightView)
        self.add(childVC: ownerPickerVC, to: self.ownerPickerView)
        

        let padding: CGFloat = 24
        let sectionPadding: CGFloat = 24
        let valuePadding: CGFloat = 10
               
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            prioLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: sectionPadding),
            prioLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            prioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            prioLabel.heightAnchor.constraint(equalToConstant: 20),

            prioView.topAnchor.constraint(equalTo: prioLabel.bottomAnchor, constant: 6),
            prioView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            prioView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            prioView.heightAnchor.constraint(equalToConstant: 30),

            weightLabel.topAnchor.constraint(equalTo: prioView.bottomAnchor, constant: sectionPadding),
            weightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            weightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weightLabel.heightAnchor.constraint(equalToConstant: 20),

            weightView.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 6),
            weightView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            weightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            weightView.heightAnchor.constraint(equalToConstant: 30),

            creationDateLabel.topAnchor.constraint(equalTo: weightView.bottomAnchor, constant: sectionPadding),
            creationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            creationDateLabel.widthAnchor.constraint(equalToConstant: 120),
            creationDateLabel.heightAnchor.constraint(equalToConstant: 20),

            creationDateLabelValue.topAnchor.constraint(equalTo: weightView.bottomAnchor, constant: sectionPadding),
            creationDateLabelValue.leadingAnchor.constraint(equalTo: creationDateLabel.trailingAnchor, constant: valuePadding),
            creationDateLabelValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            creationDateLabelValue.heightAnchor.constraint(equalToConstant: 20),

            modificationDateLabel.topAnchor.constraint(equalTo: creationDateLabelValue.bottomAnchor, constant: sectionPadding),
            modificationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            modificationDateLabel.widthAnchor.constraint(equalToConstant: 120),
            modificationDateLabel.heightAnchor.constraint(equalToConstant: 20),

            modificationDateLabelValue.topAnchor.constraint(equalTo: creationDateLabel.bottomAnchor, constant: sectionPadding),
            modificationDateLabelValue.leadingAnchor.constraint(equalTo: modificationDateLabel.trailingAnchor, constant: valuePadding),
            modificationDateLabelValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            modificationDateLabelValue.heightAnchor.constraint(equalToConstant: 20),
            
            reporterLabel.topAnchor.constraint(equalTo: modificationDateLabelValue.bottomAnchor, constant: sectionPadding),
            reporterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            reporterLabel.widthAnchor.constraint(equalToConstant: 120),
            reporterLabel.heightAnchor.constraint(equalToConstant: 20),

            reporterLabelValue.topAnchor.constraint(equalTo: modificationDateLabelValue.bottomAnchor, constant: sectionPadding),
            reporterLabelValue.leadingAnchor.constraint(equalTo: reporterLabel.trailingAnchor, constant: valuePadding),
            reporterLabelValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            reporterLabelValue.heightAnchor.constraint(equalToConstant: 20),

            ownerLabel.topAnchor.constraint(equalTo: reporterLabelValue.bottomAnchor, constant: 110),
            ownerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ownerLabel.widthAnchor.constraint(equalToConstant: 110),
            ownerLabel.heightAnchor.constraint(equalToConstant: 20),

            ownerPickerView.topAnchor.constraint(equalTo: reporterLabelValue.bottomAnchor, constant: 10),
            ownerPickerView.leadingAnchor.constraint(equalTo: ownerLabel.trailingAnchor, constant: valuePadding),
            ownerPickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ownerPickerView.heightAnchor.constraint(equalToConstant: 200),
                        
            descriptionLabel.topAnchor.constraint(equalTo: ownerPickerView.bottomAnchor, constant: sectionPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: ownerPickerView.leadingAnchor, constant: padding),
            descriptionLabel.trailingAnchor.constraint(equalTo: ownerPickerView.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
        
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
}
