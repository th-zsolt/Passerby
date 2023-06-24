//
//  CommentsViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 24..
//

import Foundation
import RxCocoa
import RxSwift

class CommentsViewModel {
    
    var bag: DisposeBag = DisposeBag()
    
    // MARK: - Input
    
    let addCommentClicked: AnyObserver<Void>
    
    let taskId : String
    let teamUser : [TeamUser]
    
    // MARK: - Output
    let presentError = PublishRelay<String>()
    let CommentItems = BehaviorRelay<[Comment]?>(value: nil)
    let showNewComment: Observable<Void>
    
    // MARK: - Init
    init(taskId: String, teamUser: [TeamUser]) {
        self.taskId = taskId
        self.teamUser = teamUser
        
        let _addCommentClicked = PublishSubject<Void>()
        self.addCommentClicked = _addCommentClicked.asObserver()
        self.showNewComment = _addCommentClicked.asObservable()
        
        getComments()
    }
    
    
    func getComments() {
        ApiClient.getComments(taskid: self.taskId).asObservable()
            .subscribe(onNext: { result in
                    self.CommentItems.accept( self.createCommentsWithCreatorNames(comments: result.comments))
        }, onError: { error in
            let errorMessage = ErrorHelper.parseErroMessage(error: error)
            self.presentError.accept(errorMessage)
        }).disposed(by: bag)
    }
    
    
    func createCommentsWithCreatorNames(comments: [Comment]) ->[Comment] {
        return comments.map { comment in
            Comment(commentId: comment.commentId, text: comment.text, creatorId: comment.creatorId, creationDate: comment.creationDate, creatorName: fetchCreatorName(creatorId: comment.creatorId))
        }
    }
    
    
    func fetchCreatorName(creatorId: Int) -> String {
        return self.teamUser.filter { $0.userId == String(creatorId)}.first.flatMap{ $0.userName } ?? ""
    }
    
}
