//
//  CommentCell.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 24..
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    static let reuseID = "CommentCell"
    let creatorLabel = PBTitleLabel(textAlignment: .left, fontSize: 16)
    let creationDate = PBSecondaryTitleLabel(fontSize: 14)
    let commentText = PBBodyLabel(textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(comment: Comment) {
        commentText.text = comment.text
        creatorLabel.text = comment.creatorName
        creationDate.text = comment.creationDate
        }
    
    
    private func configure() {
            self.clipsToBounds = false
            self.backgroundColor = .systemBackground
            self.layer.cornerRadius = 10
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
            self.layer.shadowRadius = 10
            self.layer.shadowOpacity = 0.2
        
        addSubViews(creatorLabel, creationDate, commentText)
        let padding: CGFloat = 8
        
        creatorLabel.translatesAutoresizingMaskIntoConstraints = false
        creationDate.translatesAutoresizingMaskIntoConstraints = false
        commentText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            creatorLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            creatorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            creatorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            creatorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            creationDate.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: padding),
            creationDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            creationDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            creationDate.heightAnchor.constraint(equalToConstant: 20),
            
            commentText.topAnchor.constraint(equalTo: creationDate.bottomAnchor, constant: padding),
            commentText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            commentText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            commentText.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
