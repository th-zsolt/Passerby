//
//  EditTaskVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 12..
//

import UIKit
import RxSwift
import RxCocoa

class NewTaskVC: UIViewController, UIScrollViewDelegate {

    private let bag = DisposeBag()
    var viewModel: NewTaskViewModel!
    
    var prioSegmentedVC: PrioSegmentedVC!
    var weightSegmentedVC: WeightSegmentedVC!
    var ownerPickerVC: OwnerPickerVC!
//    var statePickerVC: StatePickerVC!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
//    let statePickerView = UIView()
    let ownerPickerView = UIView()
    let prioView = UIView()
    let weightView = UIView()

    let nameTextField = PBTextField(placeholder: "Enter the title")
    let taskIdLabel = PBBodyLabel(textAlignment: .left)
    let taskIdLabelValue = PBBodyLabelValue(textAlignment: .left)
    let prioLabel = PBBodyLabel(textAlignment: .left)
    let weightLabel = PBBodyLabel(textAlignment: .left)
    let reporterLabel = PBBodyLabel(textAlignment: .left)
    let reporterLabelValue = PBBodyLabelValue(textAlignment: .left)
    let ownerLabel = PBBodyLabel(textAlignment: .left)
//    let stateLabel = PBBodyLabel(textAlignment: .left)
    let creationDateLabel = PBBodyLabel(textAlignment: .left)
    let creationDateLabelValue = PBBodyLabelValue(textAlignment: .left)
    let modificationDateLabel = PBBodyLabel(textAlignment: .left)
    let modificationDateLabelValue = PBBodyLabelValue(textAlignment: .left)
    let descriptionLabel = PBBodyLabel(textAlignment: .left)
    let descriptionTextView = PBTextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 200.0))
    
//    let commentButton = PBButton(color: .systemBlue, title: "Comments")
       
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
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createTask))
        navigationItem.rightBarButtonItem = saveButton
        
        saveButton.isEnabled = false
        
        nameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledTitleSubject).disposed(by: bag)
        descriptionTextView.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledDescriptionSubject).disposed(by: bag)
        
        viewModel.isValid().bind(to: saveButton.rx.isEnabled).disposed(by: bag)
        
        saveButton.rx.tap.subscribe(onNext: { self.viewModel.createTask() }).disposed(by: bag)
    }
    
    @objc func createTask() {
    }
        
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
                         
        NSLayoutConstraint.activate([
             contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
             contentView.heightAnchor.constraint(equalToConstant: 800)
//             1200
        ])

        contentView.addSubViews(nameTextField, taskIdLabel, taskIdLabelValue, prioLabel, prioView, weightLabel, weightView, reporterLabel, reporterLabelValue, ownerLabel, ownerPickerView, creationDateLabel, creationDateLabelValue,    modificationDateLabel, modificationDateLabelValue, descriptionLabel, descriptionTextView)
        
    }
    
    
    func getInitialTaskValues() {
        _ = self.viewModel.initialTask
            .subscribe(onNext: { initialTaskViewModel in
                self.creationDateLabelValue.text = initialTaskViewModel.creationDate
                self.modificationDateLabelValue.text = initialTaskViewModel.modifiedDate
                self.reporterLabelValue.text = initialTaskViewModel.creator
            })
    }
    
        
    func configureUIElements() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        prioView.translatesAutoresizingMaskIntoConstraints = false
        weightView.translatesAutoresizingMaskIntoConstraints = false
        ownerPickerView.translatesAutoresizingMaskIntoConstraints = false
//        stateLabel.translatesAutoresizingMaskIntoConstraints = false
//        statePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        taskIdLabel.text = "ID:"
        taskIdLabelValue.text = "1234"
        prioLabel.text = "Priority:"
        weightLabel.text = "Weight:"
        reporterLabel.text = "Reporter:"
        ownerLabel.text = "Owner:"
        creationDateLabel.text = "Created:"
        modificationDateLabel.text = "Last modified:"
        descriptionLabel.text = "Description:"
//        stateLabel.text = "State:"
        
        self.add(childVC: prioSegmentedVC, to: self.prioView)
        self.add(childVC: weightSegmentedVC, to: self.weightView)
        self.add(childVC: ownerPickerVC, to: self.ownerPickerView)
//        self.add(childVC: statePickerVC, to: self.statePickerView)
        

        let padding: CGFloat = 24
        let sectionPadding: CGFloat = 24
        let valuePadding: CGFloat = 10
               
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
                        
            taskIdLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: sectionPadding),
            taskIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            taskIdLabel.widthAnchor.constraint(equalToConstant: 30),
            taskIdLabel.heightAnchor.constraint(equalToConstant: 20),

            taskIdLabelValue.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: sectionPadding),
            taskIdLabelValue.leadingAnchor.constraint(equalTo: taskIdLabel.trailingAnchor, constant: valuePadding),
            taskIdLabelValue.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            taskIdLabelValue.heightAnchor.constraint(equalToConstant: 20),
            

            prioLabel.topAnchor.constraint(equalTo: taskIdLabelValue.bottomAnchor, constant: sectionPadding),
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
            
//            stateLabel.topAnchor.constraint(equalTo: ownerPickerView.bottomAnchor, constant: 110),
//            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
//            stateLabel.widthAnchor.constraint(equalToConstant: 110),
//            stateLabel.heightAnchor.constraint(equalToConstant: 20),

//            statePickerView.topAnchor.constraint(equalTo: ownerPickerView.bottomAnchor, constant: 10),
//            statePickerView.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: valuePadding),
//            statePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
//            statePickerView.heightAnchor.constraint(equalToConstant: 200),
            
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
