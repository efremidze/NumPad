//
//  ViewController.swift
//  NumPad
//
//  Created by Lasha Efremidze on 5/1/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

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
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[containerView]-10-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[containerView]-10-|", options: [], metrics: nil, views: views))
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
            containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textField(==120)][numPad]|", options: [], metrics: nil, views: views))
        }
    }
    
}

// MARK: - NumPadDataSource
extension ViewController: NumPadDataSource {
    
    func numberOfRowsInNumberPad(numPad: NumPad) -> Int {
        return 4
    }
    
    func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int {
        return 3
    }
    
}

// MARK: - NumPadDelegate
extension ViewController: NumPadDelegate {
    
    func numPad(numPad: NumPad, willDisplayButton button: UIButton, forPosition position: Position) {
        let index = numPad.indexForPosition(position)
        
        // title
        var title = "\(index + 1)"
        switch index {
        case 9: title = "C"
        case 10: title = "0"
        case 11: title = "00"
        default: break
        }
        button.setTitle(title, forState: .Normal)
        
        // titleColor
        var titleColor = UIColor(white: 0.3, alpha: 1)
        if index == 9 {
            titleColor = .orangeColor()
        }
        button.setTitleColor(titleColor, forState: .Normal)
        
        // font
        button.titleLabel?.font = UIFont.systemFontOfSize(40)
        
        // backgroundImage
        var image = UIColor.whiteColor().toImage()
        button.setBackgroundImage(image, forState: .Normal)
        image = backgroundColor.toImage()
        button.setBackgroundImage(image, forState: .Highlighted)
        button.setBackgroundImage(image, forState: .Selected)
    }
    
    func numPad(numPad: NumPad, buttonTappedAtPosition position: Position) {
        let index = numPad.indexForPosition(position)
        if index == 9 {
            textField.text = nil
        } else {
            let button = numPad.buttonForPosition(position)!
            let string = (textField.text ?? "") + (button.titleForState(.Normal) ?? "")
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string
            }
        }
    }
    
}

// MARK: - Extensions

private extension UIColor {
    
    func toImage() -> UIImage {
        return UIImage(color: self)
    }
    
}

private extension UIImage {
    
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        var rect = CGRectZero
        rect.size = size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
    
}
