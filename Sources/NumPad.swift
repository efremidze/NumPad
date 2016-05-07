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
    public let row: Int
    public let column: Int
}

// MARK: - Item
public struct Item {
    public var backgroundColor: UIColor? = .whiteColor()
    public var selectedBackgroundColor: UIColor? = .clearColor()
    public var image: UIImage?
    public var title: String?
    public var titleColor: UIColor? = .blackColor()
    public var titleFont: UIFont?
    
    public init() {}
}

// MARK: - NumPadDataSource
public protocol NumPadDataSource: class {
    func numberOfRowsInNumPad(numPad: NumPad) -> Int
    func numPad(numPad: NumPad, numberOfColumnsInRow row: Int) -> Int
    func numPad(numPad: NumPad, itemForPosition position: Position) -> Item
}

// MARK: - NumPadDelegate
public protocol NumPadDelegate: class {
    func numPad(numPad: NumPad, itemTappedAtPosition position: Position)
    func numPad(numPad: NumPad, sizeForItemAtPosition position: Position) -> CGSize
}

public extension NumPadDelegate {
    func numPad(numPad: NumPad, sizeForItemAtPosition position: Position) -> CGSize { return numPad.sizeForItemAtPosition(position) }
}

// MARK: - NumPad
public class NumPad: UIView {
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clearColor()
        collectionView.allowsSelection = false
        collectionView.scrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: String(Cell))
        self.addSubview(collectionView)
        let views = ["collectionView": collectionView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
        return collectionView
    }()
    
    public weak var dataSource: NumPadDataSource?
    public weak var delegate: NumPadDelegate?
    
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
        cell.item = dataSource?.numPad(self, itemForPosition: position)
        cell.buttonTapped = { [unowned self] _ in
            self.delegate?.numPad(self, itemTappedAtPosition: position)
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NumPad: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let position = positionForIndexPath(indexPath)
        let size = sizeForItemAtPosition(position)
        return delegate?.numPad(self, sizeForItemAtPosition: position) ?? size
    }
    
}

// MARK: - Public Helpers
public extension NumPad {
    
    func indexForPosition(position: Position) -> Int {
        var index = (0..<position.row).map { numberOfColumnsInRow($0) }.reduce(0, combine: +)
        index += position.column
        return index
    }
    
    func itemForPosition(position: Position) -> Item? {
        let indexPath = indexPathForPosition(position)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        return (cell as? Cell)?.item
    }
    
    func sizeForItemAtPosition(position: Position) -> CGSize {
        let indexPath = indexPathForPosition(position)
        
        let numberOfRows = CGFloat(self.numberOfRows())
        let numberOfColumns = CGFloat(self.numberOfColumnsInRow(indexPath.section))
        
        let width = collectionView.frame.width / numberOfColumns
        let height = collectionView.frame.height / numberOfRows
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - Private Helpers
extension NumPad {
    
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
    
    lazy var button: UIButton = { [unowned self] in
        let button = UIButton(type: .Custom)
        button.titleLabel?.textAlignment = .Center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(_buttonTapped), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(button)
        let views = ["button": button]
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-1-[button]|", options: [], metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-1-[button]|", options: [], metrics: nil, views: views))
        return button
    }()
    
    var item: Item? {
        didSet {
            button.setTitle(item?.title, forState: .Normal)
            
            button.setTitleColor(item?.titleColor, forState: .Normal)
            
            button.titleLabel?.font = item?.titleFont
            
            button.setImage(item?.image, forState: .Normal)
            
            var image = item?.backgroundColor.map { UIImage(color: $0) }
            button.setBackgroundImage(image, forState: .Normal)
            image = item?.selectedBackgroundColor.map { UIImage(color: $0) }
            button.setBackgroundImage(image, forState: .Highlighted)
            button.setBackgroundImage(image, forState: .Selected)
            
            button.tintColor = item?.titleColor
        }
    }
    
    var buttonTapped: (UIButton -> ())?
    
    @IBAction func _buttonTapped(button: UIButton) {
        buttonTapped?(button)
    }
    
    func configure(withItem item: Item) {
        self.item = item
    }
    
}

// MARK: - UIImage
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
