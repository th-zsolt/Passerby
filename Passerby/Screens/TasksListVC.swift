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
    var viewModel: TasksListViewModel!
    
    private let bag = DisposeBag()
//    let tableView = UITableView()
    var tasks: [TaskItem] = []
           
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
//        configureViewController()
//        getTaskItems()
    }

    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Tickets"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func getTaskItems() {
        let userId = "PublishSubject"
        self.viewModel.getTasks(userId: userId)
        self.viewModel.output
                .observe(on: MainScheduler.instance)
                .filter{$0 != nil}
                .subscribe(onNext: { tasksList in
                print("List of posts:", tasksList)
        })
        .disposed(by: bag)
    }
    
    
    func bindViewModel() {
        
    }

//
//    func configureTableView() {
//        view.addSubview(tableView)
//
//        tableView.frame = view.bounds
//        tableView.rowHeight = 50
////        tableView.dataSource = self
//
//        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseID)
//    }
//
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

//extension ViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tasks.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseID) as! TableViewCell
//        let task = tasks[indexPath.row]
//        cell.set (task: task)
//        return cell
//    }
//
//}
