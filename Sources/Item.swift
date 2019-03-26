//
//  Item.swift
//  NumPad
//
//  Created by Lasha Efremidze on 1/7/18.
//  Copyright © 2018 Lasha Efremidze. All rights reserved.
//

import Foundation

public struct Item {
    public var backgroundColor: UIColor? = .white
    public var selectedBackgroundColor: UIColor? = .clear
    public var image: UIImage?
    public var title: String?
    public var titleColor: UIColor? = .black
    public var font: UIFont? = .systemFont(ofSize: 17)
    public var attributedString: NSAttributedString?
    
    public init() {}

    public init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    public init(title: String?) {
        self.title = title
    }

    public init(image: UIImage?) {
        self.image = image
    }
}
