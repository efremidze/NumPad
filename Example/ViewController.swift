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
    
    lazy var containerView: UIView = { [unowned self] in
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = self.borderColor.cgColor
        containerView.layer.borderWidth = 1
        self.view.addSubview(containerView)
        return containerView
    }()
    
    lazy var textField: UITextField = { [unowned self] in
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.textColor = UIColor(white: 0.3, alpha: 1)
        textField.font = .systemFont(ofSize: 40)
        textField.placeholder = "0".currency()
        textField.isEnabled = false
        self.containerView.addSubview(textField)
        return textField
    }()
    
    lazy var numPad: NumPad = { [unowned self] in
        let numPad = DefaultNumPad()
        numPad.delegate = self
        numPad.translatesAutoresizingMaskIntoConstraints = false
        numPad.backgroundColor = self.borderColor
        self.containerView.addSubview(numPad)
        return numPad
    }()
    
    let borderColor = UIColor(white: 0.9, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let views = ["containerView": containerView, "textField": textField, "numPad": numPad]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textField]-20-|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[numPad]|", options: [], metrics: nil, views: views))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[textField(==120)][numPad]|", options: [], metrics: nil, views: views))
    }
    
}

extension ViewController: NumPadDelegate {
    
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            textField.text = nil
        default:
            let item = numPad.item(forPosition: position)!
            let string = textField.text!.sanitized() + item.title!
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string.currency()
            }
        }
    }
    
}

extension String {
    
    func currency() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let digits = NSDecimalNumber(string: sanitized())
        let place = NSDecimalNumber(value: powf(10, 2))
        return formatter.string(from: digits.dividing(by: place))
    }
    
    func sanitized() -> String {
        return String(self.characters.filter { "01234567890".characters.contains($0) })
    }
    
}
