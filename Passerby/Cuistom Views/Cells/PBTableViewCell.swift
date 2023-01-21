//
//  PBTableViewCell.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 21..
//

import UIKit

class PBTableViewCell: UITableViewCell {

    static let reuseID = "TaskCell"
    let taskNameLabel = PBTitleLabel(textAlignment: .left, fontSize: 18)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(task: TaskItem) {
        taskNameLabel.text = task.taskName
    }
    
    
    private func configure() {
        addSubview(taskNameLabel)
        
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            
            taskNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            taskNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            taskNameLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
        
    }
    
}

