//
//  ColorCell.swift
//  UICollectionViewFlowLayout-Demo
//
//  Created by Armand Kaguermanov on 10/05/2023.
//

import UIKit

class ColorCell: UICollectionViewCell {
    var nameLabel: UILabel!
    var colorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = frame.size.width / 2
        contentView.clipsToBounds = true
        
        colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with namedColor: ColorData) {
        nameLabel.text = namedColor.name
        colorView.backgroundColor = UIColor(namedColor.color)
    }
}
