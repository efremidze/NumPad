//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 5/2/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit
import NumPad

class ViewController: UIViewController {
    
    private let backgroundColor = UIColor(white: 0.9, alpha: 1)
    
    private let containerView = UIView()
    private let textField = UITextField()
    private let numPad = NumPad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = backgroundColor.CGColor
        containerView.layer.borderWidth = 1
        view.addSubview(containerView)
        
        do {
            let views = ["containerView": containerView]
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: [], metrics: nil, views: views))
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .Right
        textField.textColor = UIColor(white: 0.3, alpha: 1)
        textField.font = .systemFontOfSize(40)
        textField.placeholder = "0"
        textField.enabled = false
        containerView.addSubview(textField)
        
        numPad.translatesAutoresizingMaskIntoConstraints = false
        numPad.backgroundColor = backgroundColor
        numPad.dataSource = self
        numPad.delegate = self
        containerView.addSubview(numPad)
        
        do {
            let views = ["textField": textField, "numPad": numPad]
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[textField]-20-|", options: [], metrics: nil, views: views))
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[numPad]|", options: [], metrics: nil, views: views))
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[textField(==120)][numPad]|", options: [], metrics: nil, views: views))
        }
    }
    
}

// MARK: - NumPadDataSource
extension ViewController: NumPadDataSource {
    
    func numberOfRowsInNumPad(numPad: NumPad) -> Int {
        return 4
    }
    
    func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int {
        return 3
    }
    
    func numPad(numPad: NumPad, itemForPosition position: Position) -> Item {
        let index = numPad.indexForPosition(position)
        
        let title: String
        switch index {
        case 9: title = "C"
        case 10: title = "0"
        case 11: title = "00"
        default: title = "\(index + 1)"
        }
        var item = Item(title: title)
        
        if index == 9 {
            item.titleColor = .orangeColor()
        } else {
            item.titleColor = UIColor(white: 0.3, alpha: 1)
        }
        
        item.titleFont = .systemFontOfSize(40)
        
        return item
    }
    
}

// MARK: - NumPadDelegate
extension ViewController: NumPadDelegate {
    
    func numPad(numPad: NumPad, itemTappedAtPosition position: Position) {
        let index = numPad.indexForPosition(position)
        if index == 9 {
            textField.text = nil
        } else {
            let item = numPad.itemForPosition(position)!
            let string = (textField.text ?? "") + (item.title ?? "")
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string
            }
        }
    }
    
}
