//
//  ViewController.swift
//  NumPadDemo
//
//  Created by Lasha Efremidze on 1/10/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit
import NumPad

class ViewController: UIViewController {
    
    private let backgroundColor = UIColor(white: 0.9, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numPad = NumPad()
        numPad.translatesAutoresizingMaskIntoConstraints = false
        numPad.backgroundColor = backgroundColor
        numPad.layer.borderColor = backgroundColor.CGColor
        numPad.layer.borderWidth = 1
        numPad.dataSource = self
        numPad.delegate = self
        view.addSubview(numPad)
        
        let views = ["numPad": numPad]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[numPad]-10-|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[numPad]-20-|", options: [], metrics: nil, views: views))
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
    
    func numPad(numPad: NumPad, configureButton button: UIButton, forPosition position: Position) {
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
    
}

// MARK: - Extensions
extension UIColor {
    
    func toImage() -> UIImage {
        return UIImage(color: self)
    }
    
}

extension UIImage {
    
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
