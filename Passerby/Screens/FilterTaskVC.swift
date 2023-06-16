//
//  FilterTaskVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 13..
//

import UIKit
import RxSwift
import RxCocoa

class FilterTaskVC: UIViewController {
    
    private let bag = DisposeBag()
    var viewModel: FilterTaskViewModel!
    
    var prioSegmentedVC: PrioSegmentedVC!
    var weightSegmentedVC: WeightSegmentedVC!
    var reporterPickerVC: TeamMemberPickerVC!
    var dialogVC: PBDialogVC!
    var statePickerVC: StatePickerVC!
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let statePickerView = UIView()
    let reporterPickerView = UIView()
    let prioView = UIView()
    let weightView = UIView()

    let taskIdTextField = PBTextField(placeholder: "")
    let taskIdLabel = PBBodyLabel(textAlignment: .left)
    let nameTextField = PBTextField(placeholder: "")
    let nameLabel = PBBodyLabel(textAlignment: .left)
    let descriptionTextField = PBTextField(placeholder: "")
    let desciptionLabel = PBBodyLabel(textAlignment: .left)
    let prioLabel = PBBodyLabel(textAlignment: .left)
    let weightLabel = PBBodyLabel(textAlignment: .left)
    let reporterLabel = PBBodyLabel(textAlignment: .left)
    let stateLabel = PBBodyLabel(textAlignment: .left)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureUIElements()
        createDismissKeyboardTapGesture()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Filter"
        
        self.taskIdTextField.text = viewModel.filterItem.taskId
        self.nameTextField.text = viewModel.filterItem.taskName
        self.descriptionTextField.text = viewModel.filterItem.description
                
        let doFilterButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doFilterButton))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilter))
        
        navigationItem.rightBarButtonItems = [doFilterButton, resetButton]
        

        doFilterButton.rx.tap
            .bind(to: viewModel.doFilterButtonClicked)
            .disposed(by: bag)
        
        resetButton.rx.tap.subscribe(onNext: { self.viewModel.resetFilter()
            self.nameTextField.text = ""
            self.taskIdTextField.text = ""
            self.descriptionTextField.text = ""
        }).disposed(by: bag)
        
        viewModel.presentError.subscribe(onNext: { error in
            if error != "" { self.presentPBAlert(title: error, message: "Please try again", buttonTitle: "Ok")}
        }).disposed(by: bag)
        
        taskIdTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledIdSubject).disposed(by: bag)        
        nameTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledTitleSubject).disposed(by: bag)
        descriptionTextField.rx.text.map { $0 ?? "" }.bind(to: viewModel.filledDescriptionSubject).disposed(by: bag)
    }
    
    

    @objc func doFilterButton() { // Do not delete this, the selector need it
    }
    
    @objc func resetFilter() { // Do not delete this, the selector need it
    }

    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
                         
        NSLayoutConstraint.activate([
             contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
             contentView.heightAnchor.constraint(equalToConstant: 750)
        ])

        contentView.addSubViews(taskIdTextField, taskIdLabel, nameTextField, nameLabel, descriptionTextField, desciptionLabel, prioLabel, prioView, weightLabel, weightView, reporterLabel, reporterPickerView, stateLabel, statePickerView)
        
    }
    
    
    func configureUIElements() {
        taskIdTextField.translatesAutoresizingMaskIntoConstraints = false
        taskIdLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        desciptionLabel.translatesAutoresizingMaskIntoConstraints = false
        prioLabel.translatesAutoresizingMaskIntoConstraints = false
        prioView.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightView.translatesAutoresizingMaskIntoConstraints = false
        reporterLabel.translatesAutoresizingMaskIntoConstraints = false
        reporterPickerView.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        statePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        taskIdLabel.text = "ID:"
        nameLabel.text = "Name:"
        desciptionLabel.text = "Description:"
        prioLabel.text = "Priority:"
        weightLabel.text = "Weight:"
        reporterLabel.text = "Reporter:"
        stateLabel.text = "State:"
        
        self.add(childVC: prioSegmentedVC, to: self.prioView)
        self.add(childVC: weightSegmentedVC, to: self.weightView)
        self.add(childVC: reporterPickerVC, to: self.reporterPickerView)
        self.add(childVC: statePickerVC, to: self.statePickerView)
        
        let padding: CGFloat = 24
        let sectionPadding: CGFloat = 24
        let valuePadding: CGFloat = 10
               
        NSLayoutConstraint.activate([
            
            taskIdLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            taskIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            taskIdLabel.widthAnchor.constraint(equalToConstant: 100),
            taskIdLabel.heightAnchor.constraint(equalToConstant: 40),
            
            taskIdTextField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            taskIdTextField.leadingAnchor.constraint(equalTo: taskIdLabel.trailingAnchor, constant: valuePadding),
            taskIdTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            taskIdTextField.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: taskIdTextField.bottomAnchor, constant: sectionPadding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            nameTextField.topAnchor.constraint(equalTo: taskIdTextField.bottomAnchor, constant: sectionPadding),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: valuePadding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            desciptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: sectionPadding),
            desciptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            desciptionLabel.widthAnchor.constraint(equalToConstant: 100),
            desciptionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: sectionPadding),
            descriptionTextField.leadingAnchor.constraint(equalTo: desciptionLabel.trailingAnchor, constant: valuePadding),
            descriptionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 40),

            prioLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: sectionPadding),
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

            reporterLabel.topAnchor.constraint(equalTo: weightView.bottomAnchor, constant: 110),
            reporterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            reporterLabel.widthAnchor.constraint(equalToConstant: 110),
            reporterLabel.heightAnchor.constraint(equalToConstant: 20),

            reporterPickerView.topAnchor.constraint(equalTo: weightView.bottomAnchor, constant: 10),
            reporterPickerView.leadingAnchor.constraint(equalTo: reporterLabel.trailingAnchor, constant: valuePadding),
            reporterPickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            reporterPickerView.heightAnchor.constraint(equalToConstant: 200),

            stateLabel.topAnchor.constraint(equalTo: reporterPickerView.bottomAnchor, constant: 110),
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stateLabel.widthAnchor.constraint(equalToConstant: 110),
            stateLabel.heightAnchor.constraint(equalToConstant: 20),

            statePickerView.topAnchor.constraint(equalTo: reporterPickerView.bottomAnchor, constant: 10),
            statePickerView.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: valuePadding),
            statePickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            statePickerView.heightAnchor.constraint(equalToConstant: 200)

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
