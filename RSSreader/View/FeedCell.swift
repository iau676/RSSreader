//
//  FeedCell.swift
//  RSSreader
//
//  Created by ibrahim uysal on 13.04.2023.
//

import UIKit

final class FeedCell: UITableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [dateLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        
        addSubview(stack)
        stack.centerY(inView: self)
        stack.anchor(left: leftAnchor, right: rightAnchor,
                     paddingLeft: 16, paddingRight: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
