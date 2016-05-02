//
//  NumPad.swift
//  NumPad
//
//  Created by Lasha Efremidze on 1/9/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

// MARK: - Position
public struct Position {
    let row: Int
    let column: Int
}

// MARK: - NumPadDataSource
public protocol NumPadDataSource: class {
    func numberOfRowsInNumPad(numPad: NumPad) -> Int
    func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int
    func numPad(numPad: NumPad, buttonForPosition position: Position) -> UIButton
}

// MARK: - NumPadDelegate
public protocol NumPadDelegate: class {
    func numPad(numPad: NumPad, sizeForButtonAtPosition position: Position, defaultSize size: CGSize) -> CGSize
    func numPad(numPad: NumPad, buttonTappedAtPosition position: Position)
}

public extension NumPadDelegate {
    func numPad(numPad: NumPad, sizeForButtonAtPosition position: Position, defaultSize size: CGSize) -> CGSize { return size }
    func numPad(numPad: NumPad, buttonTappedAtPosition position: Position) {}
}

// MARK: - NumPad
public class NumPad: UIView {
    
    let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    
    public weak var dataSource: NumPadDataSource?
    public weak var delegate: NumPadDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clearColor()
        collectionView.allowsSelection = false
        collectionView.scrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: String(Cell))
        addSubview(collectionView)
        
        let views = ["collectionView": collectionView]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - UICollectionViewDataSource
extension NumPad: UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numberOfRows()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumnsInRow(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let position = positionForIndexPath(indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell), forIndexPath: indexPath) as! Cell
        cell.button = dataSource?.numPad(self, buttonForPosition: position) ?? UIButton()
        cell.buttonTapped = { [unowned self] _ in
            self.delegate?.numPad(self, buttonTappedAtPosition: position)
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NumPad: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let numberOfRows = CGFloat(self.numberOfRows())
        let numberOfColumns = CGFloat(self.numberOfColumnsInRow(indexPath.section))
        
        let width = collectionView.frame.width / numberOfColumns
        let height = collectionView.frame.height / numberOfRows
        let size = CGSize(width: width, height: height)
        
        let position = positionForIndexPath(indexPath)
        return delegate?.numPad(self, sizeForButtonAtPosition: position, defaultSize: size) ?? size
    }
    
}

// MARK: - Helpers
public extension NumPad {
    
    func indexForPosition(position: Position) -> Int {
        var index = (0..<position.row).map { numberOfColumnsInRow($0) }.reduce(0, combine: +)
        index += position.column
        return index
    }
    
    func buttonForPosition(position: Position) -> UIButton? {
        let indexPath = indexPathForPosition(position)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        return (cell as? Cell)?.button
    }
    
}

private extension NumPad {
    
    func indexPathForPosition(position: Position) -> NSIndexPath {
        return NSIndexPath(forItem: position.column, inSection: position.row)
    }
    
    func positionForIndexPath(indexPath: NSIndexPath) -> Position {
        return Position(row: indexPath.section, column: indexPath.item)
    }
    
    func numberOfRows() -> Int {
        return dataSource?.numberOfRowsInNumPad(self) ?? 0
    }
    
    func numberOfColumnsInRow(row: Int) -> Int {
        return dataSource?.numPad(self, numberOfColumnsInRow: row) ?? 0
    }
    
}

// MARK: - Cell
class Cell: UICollectionViewCell {
    
    var button: UIButton! {
        didSet {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(_buttonTapped), forControlEvents: .TouchUpInside)
            contentView.addSubview(button)
            
            let views = ["button": button]
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-1-[button]|", options: [], metrics: nil, views: views))
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-1-[button]|", options: [], metrics: nil, views: views))
        }
    }
    
    var buttonTapped: (UIButton -> ())?
    
    @IBAction func _buttonTapped(button: UIButton) {
        buttonTapped?(button)
    }
    
}
