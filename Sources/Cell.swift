//
//  Cell.swift
//  NumPad
//
//  Created by Lasha Efremidze on 1/7/18.
//  Copyright © 2018 Lasha Efremidze. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    lazy var button: UIButton = { [unowned self] in
        let button = UIButton(type: .custom)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(_buttonTapped), for: .touchUpInside)
        self.contentView.addSubview(button)
        let edges = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 0)
        button.constrainToEdges(edges)
        return button
    }()
    
    var item: Item! {
        didSet {
            if let attributedString = item.attributedString {
              button.titleLabel.attributedString = attributedString 
            }else{
                
              button.title = item.title
              button.titleColor = item.titleColor
              button.titleLabel?.font = item.font
              button.tintColor = item.titleColor
            }
            button.image = item.image
            var image = item.backgroundColor.map { UIImage(color: $0) }
            button.backgroundImage = image
            image = item.selectedBackgroundColor.map { UIImage(color: $0) }
            button.setBackgroundImage(image, for: .highlighted)
            button.setBackgroundImage(image, for: .selected)
        }
    }
    
    var buttonTapped: ((UIButton) -> Void)?
    
    @IBAction func _buttonTapped(_ button: UIButton) {
        buttonTapped?(button)
    }
    
}
