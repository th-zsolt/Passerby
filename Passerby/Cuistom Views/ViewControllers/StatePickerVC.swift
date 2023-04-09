//
//  StatePickerVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 19..
//

import RxSwift
import RxCocoa
import UIKit

class StatePickerVC: UIViewController {
    
    var viewModel: NewTaskViewModel!
    private let bag = DisposeBag()

    let data = ["Deleted", "Closed", "Pending", "Open", "In Progress"]
    
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
    }
        
}

extension StatePickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return data[row]
    }
    
    
}

