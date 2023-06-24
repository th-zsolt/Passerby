//
//  NewCommentViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 07. 09..
//

import Foundation
import RxCocoa
import RxSwift

class NewCommentViewModel {
    
    private let bag = DisposeBag()
    
    // MARK: - Input
    
    let addCommentButtonClicked: AnyObserver<Void>
    let filledCommentTextSubject = PublishSubject<String>()

    let taskId : String
    let user : User

    var commentText: String
    
    // MARK: - Output

    let presentError = PublishRelay<String>()
    var backToComments = PublishRelay<Void>()
    
    // MARK: - Init
    init(taskId: String, user: User) {
        self.commentText = ""
        self.taskId = taskId
        self.user = user

        let _addCommentButtonClicked = PublishSubject<Void>()
        self.addCommentButtonClicked = _addCommentButtonClicked.asObserver()
        _addCommentButtonClicked.asObservable().subscribe(onNext: { _ in
            self.createComment()
        }).disposed(by: bag)
        
        _ = filledCommentTextSubject.subscribe(onNext: { commentText in
            self.commentText = commentText
        })
    }
    
    
    func isValid() -> Observable<Bool> {

        return filledCommentTextSubject.asObservable().map { commentText in
            return commentText.count > 3
        }
    }
    
    
    func createComment() {

        let newComment = NewCommentItem(taskId: self.taskId, creatorId: Int(self.user.userId)!, text: self.commentText)
        
        ApiClient.createComment(newComment: newComment).asObservable().subscribe(
            onNext: { doneFlag in
                if doneFlag {
                    self.backToComments.accept(())
                }
                else { self.presentError.accept("Unknown error") }
                
            }, onError: { error in
                let errorMessage = ErrorHelper.parseErroMessage(error: error)
                self.presentError.accept(errorMessage)
            }).disposed(by: bag)
    }
}
