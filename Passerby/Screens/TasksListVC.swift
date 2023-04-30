//
//  TasksListVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 07..
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class TasksListVC: PBDataLoadingVC {
    
    private let bag = DisposeBag()
        
    var viewModel: TasksListViewModel!
    
    let tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        bindTableView()
        configureTableView()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Tickets"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        
        let config = UIImage.SymbolConfiguration(scale: .large)

        let profileButton = UIButton(type: .custom)
        profileButton.setImage(UIImage(systemName: "person.circle", withConfiguration: config), for: .normal)
        profileButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barProfileButton = UIBarButtonItem(customView: profileButton)
        
        let filterButton = UIButton(type: .custom)
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle", withConfiguration: config), for: .normal)
        filterButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barFilterButton = UIBarButtonItem(customView: filterButton)
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)
        addButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        let barAddButton = UIBarButtonItem(customView: addButton)
        
        navigationItem.rightBarButtonItems = [barAddButton, barFilterButton,  barProfileButton]
        
        profileButton.rx.tap
            .bind(to: viewModel.accountButtonClicked)
            .disposed(by: bag)
        
        addButton.rx.tap
            .bind(to: viewModel.addButtonClicked)
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .map { Int($0.item) }
            .bind(to: viewModel.taskItemSelected)
            .disposed(by: bag)

    }
            
    
    func bindTableView() {
        self.viewModel.taskItems.asDriver()
//            .observe(on: MainScheduler.instance)
            .filter{$0 != nil}
            .drive(onNext: { [weak self] _ in self?.tableView.reloadData() })
            .disposed(by: bag)
    }


    func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 50
        tableView.dataSource = self

        tableView.register(PBTableViewCell.self, forCellReuseIdentifier: PBTableViewCell.reuseID)
    }
}


extension TasksListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskItems.value?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: PBTableViewCell.reuseID) as? PBTableViewCell
        cell?.update(viewModel.taskItems.value![indexPath.row].taskName, priority: viewModel.taskItems.value![indexPath.row].taskPrio)
        print(viewModel.taskItems.value![indexPath.row].taskName)
        return cell ?? UITableViewCell()
        }
}

