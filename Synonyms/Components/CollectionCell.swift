//
//  CollectionCell.swift
//  Merima Muhovic
//
//  Created by Merima Muhovic on 7. 3. 2023..
//

import Foundation
import UIKit

class CollectionCell: UICollectionViewCell {
    
    static let identifier = "CollectionCell"
    let textLabel1 = UILabel()
    let deleteButton = UIButton()
    var viewModel: WelcomeViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Design.Color.gray.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        textLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel1)
        textLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textLabel1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        textLabel1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
        deleteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
    }
    
    @objc func deleteButtonTapped() {
        guard let collectionView = superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) else {
            return
        }
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
            if let word = textLabel1.text?.components(separatedBy: " (").first {
                viewModel?.removeWord(word)
            }
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String?, synonyms: [String]) {
        if let text = text {
            textLabel1.text = text + " (" + synonyms.joined(separator: ", ") + ")"
            contentView.backgroundColor = .white
            textLabel1.textColor = .black
            deleteButton.isHidden = false
        } else {
            textLabel1.text = ""
            contentView.layer.borderColor = .none
            contentView.layer.borderWidth = 0
            textLabel1.textColor = .clear
            deleteButton.isHidden = true
        }
    }
}
