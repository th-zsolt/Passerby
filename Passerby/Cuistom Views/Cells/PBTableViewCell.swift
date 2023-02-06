//
//  PBTableViewCell.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 21..
//

import UIKit

class PBTableViewCell: UITableViewCell {

    static let reuseID = "TaskCell"
    let priorityIcon = UIImageView()
    let taskNameLabel = PBTitleLabel(textAlignment: .left, fontSize: 18)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(_ taskName: String, priority: Int) {
        taskNameLabel.text = taskName
        switch priority {
        case 1:
            priorityIcon.image = UIImage(systemName: "l.square")
            priorityIcon.tintColor = .systemYellow
        case 2:
            priorityIcon.image = UIImage(systemName: "m.square")
            priorityIcon.tintColor = .systemBlue
        default:
            priorityIcon.image = UIImage(systemName: "h.square")
            priorityIcon.tintColor = .systemRed
        }
    }
    
    
    private func configure() {
        addSubViews(priorityIcon, taskNameLabel)
            
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        priorityIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            priorityIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            priorityIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            priorityIcon.widthAnchor.constraint(equalToConstant: 32),
            priorityIcon.heightAnchor.constraint(equalToConstant: 32),

            
            taskNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskNameLabel.leadingAnchor.constraint(equalTo: priorityIcon.trailingAnchor, constant: padding),
            taskNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            taskNameLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        
    }
    
}

