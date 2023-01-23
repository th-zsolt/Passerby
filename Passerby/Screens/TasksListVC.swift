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
        view.backgroundColor = .systemPink
//        configureViewController()
        bindTableView()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Tickets"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func bindTableView() {
        let dummyid = "PublishSubject"
        self.viewModel.getTasks(userId: dummyid)
//        self.viewModel.output
//            .observe(on: MainScheduler.instance)
//            .filter{$0 != nil}
//            .bind(to: tableView.rx.items) {
//                (tableView: tableView, index: Int, element: String) in
//                let cell = UITableViewCell(style: .default, reuseIdentifier: "TableViewCell") as! PBTableViewCell
//
//                return cell
//            }
        self.viewModel.output
                .observe(on: MainScheduler.instance)
                .filter{$0 != nil}
                .subscribe(onNext: { tasksList in
                print("List of posts:", tasksList)
                })
        .disposed(by: bag)
        
        configureTableView()
    }


    func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 50
//        tableView.dataSource = self

//        tableView.register(PBTableViewCell.self, forCellReuseIdentifier: PBTableViewCell.reuseID)
    }

//    func updateUI(with tasks: [TaskItem]) {
//        if tasks.isEmpty {
//            print("hiba")
//        } else {
//            self.tasks = tasks
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.view.bringSubviewToFront(self.tableView)
//            }
//        }
//    }

}

//extension TasksListVC: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.output.value?.count ?? 0
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return tableView.dequeueReusableCell(withIdentifier: PBTableViewCell.reuseID) as! PBTableViewCell
//    }
//
//}

//guard let task = viewModel.output.value?[indexPath.row] else  { return }
