//
//  TeamMemberPickerVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 13..
//

import RxSwift
import RxCocoa
import UIKit

class TeamMemberPickerVC: UIViewController {
    
    var viewModel: TeamMemberPickerType!
    private let bag = DisposeBag()
    
    var teamUser: [TeamUser]?
    var teamUserNames = [] as NSMutableArray
    
    let picker = UIPickerView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurePicker()
    }
    
    func configurePicker() {

        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        picker.delegate = self
        picker.dataSource = self

        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        viewModel.teamUser
            .subscribe(onNext: { teamUser in
                self.teamUser = teamUser
                if self.teamUser != nil {
                    self.createTeamUserNames(teamUser: self.teamUser!)
                }
            })
            .disposed(by: bag)
        
        
        picker.rx.itemSelected.asObservable()
            .map({ (row: Int, component: Int) in
                return self.mapUserIDFromRow(row: row)
            })
            .subscribe(viewModel.selectedOwnerSubject)
            .disposed(by: bag)
        
        
        viewModel.defaultOwnerValue
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { row in
                self.picker.selectRow(row, inComponent: 0, animated: true)
            }).disposed(by: bag)
    }
    
    
    func createTeamUserNames(teamUser: [TeamUser]) {
        teamUser.forEach { result in
            self.teamUserNames.add(result.userName)
        }
    }

    
    func mapUserIDFromRow(row: Int) -> String {
        return teamUser![row].userId
    }
        
}

extension TeamMemberPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamUserNames.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamUserNames[row] as? String
    }
    
    
}
