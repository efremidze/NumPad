//
//  Extension.swift
//  Example
//
//  Created by Lasha Efremidze on 1/7/18.
//  Copyright © 2018 Lasha Efremidze. All rights reserved.
//

import UIKit

extension UIView {
    
    @discardableResult
    func constrainToEdges(_ inset: UIEdgeInsets = UIEdgeInsets()) -> [NSLayoutConstraint] {
        return constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: inset.top),
            $0.leftAnchor.constraint(equalTo: $0.superview!.leftAnchor, constant: inset.left),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor, constant: inset.bottom),
            $0.rightAnchor.constraint(equalTo: $0.superview!.rightAnchor, constant: inset.right)
            ]}
    }
    
    @discardableResult
    func constrain(constraints: (UIView) -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = constraints(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return constraints
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
        return filter { "01234567890".contains($0) }
    }
    
}
