//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 5/27/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit
import NumPad

class ViewController: UIViewController {

    private let borderColor = UIColor(white: 0.9, alpha: 1)
    
    private lazy var containerView: UIView = { [unowned self] in
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = self.borderColor.CGColor
        containerView.layer.borderWidth = 1
        self.view.addSubview(containerView)
        return containerView
    }()
    
    private lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .Right
        textField.textColor = UIColor(white: 0.3, alpha: 1)
        textField.font = .systemFontOfSize(40)
        textField.placeholder = "0"
        textField.enabled = false
        self.containerView.addSubview(textField)
        return textField
    }()
    
    private lazy var numPad: NumPad = { [unowned self] in
        let numPad = DefaultNumPad()
        numPad.itemTapped = self.itemTapped
        numPad.translatesAutoresizingMaskIntoConstraints = false
        numPad.backgroundColor = self.borderColor
        self.containerView.addSubview(numPad)
        return numPad
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views = ["containerView": containerView, "textField": textField, "numPad": numPad]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[containerView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[containerView]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[textField]-20-|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[numPad]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[textField(==120)][numPad]|", options: [], metrics: nil, views: views))
    }
    
}

private extension ViewController {
    
    func itemTapped(item: Item, position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            textField.text = nil
        default:
            let item = numPad.item(forPosition: position)!
            let string = textField.text! + item.title!
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string
            }
        }
    }
    
}
