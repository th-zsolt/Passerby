//
//  CommentsVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 24..
//

import UIKit
import RxSwift
import RxCocoa

class CommentsVC: PBDataLoadingVC {
    
    enum Section { case main}
    
    private let bag = DisposeBag()
    var viewModel: CommentsViewModel!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Comment>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        bindCollectionView()
        configureDataSource()
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Comments"
        
        let addCommentButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCommentButtonTapped))
        navigationItem.rightBarButtonItem = addCommentButton
        
        addCommentButton.rx.tap
            .bind(to: viewModel.addCommentClicked)
            .disposed(by: bag)
        
        viewModel.presentError.subscribe(onNext: { error in
            self.presentPBAlert(title: "Bad stuff happened", message: error, buttonTitle: "Ok")
        }).disposed(by: bag)
    }
    
    
    @objc func addCommentButtonTapped() {}
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        //        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.reuseID)

    }
    
    
    func bindCollectionView() {
        self.viewModel.CommentItems
            .filter{$0 != nil}
            .subscribe(onNext: { result in
                self.updateData(on: result!)
            })
            .disposed(by: bag)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Comment>(collectionView: collectionView, cellProvider: { (collectionView, IndexPath, comment ) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.reuseID, for: IndexPath) as! CommentCell
            cell.set(comment: comment)
            return cell
        })
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath as IndexPath)
        headerView.frame.size.height = 100
        return headerView
    }
    
    
    func updateData(on comments: [Comment]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Comment>()
        snapshot.appendSections([.main])
        snapshot.appendItems(comments)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

