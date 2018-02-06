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
//        button.addTarget(self, action: #selector(_buttonTapped), for: .touchUpInside)
        self.contentView.addSubview(button)
        let edges = UIEdgeInsets(top: 1, left: 1, bottom: 0, right: 0)
        button.constrainToEdges(edges)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var item: Item! {
        didSet {
            button.title = item.title
            button.titleColor = item.titleColor
            button.titleLabel?.font = item.font
            button.image = item.image
            button.tintColor = item.titleColor
            button.backgroundColor = item.backgroundColor
        }
    }
    
//    var buttonTapped: ((UIButton) -> Void)?
//
//    @IBAction func _buttonTapped(_ button: UIButton) {
//        buttonTapped?(button)
//    }
    
    var _isHighlighted: Bool = false {
        didSet {
            print("\(_isHighlighted)")
            guard _isHighlighted != oldValue else { return }
            button.alpha = _isHighlighted ? 0.5 : 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        _isHighlighted = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if let touch = touches.first, self.hitTest(touch.location(in: self), with: event) != nil {
            _isHighlighted = true
        } else {
            _isHighlighted = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        _isHighlighted = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        _isHighlighted = false
    }
    
}
