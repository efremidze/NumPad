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
    
    public var rows: Int = 4
    public var columns: (Int -> Int) = { _ in 3 }
    public var item: (Position -> Item)?
    public var itemSize: (Position -> CGSize)?
    public var itemTapped: ((Item, Position) -> Void)?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - UICollectionViewDataSource
extension NumPad: UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return rows
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns(section)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let position = self.position(forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell), forIndexPath: indexPath) as! Cell
        let item = self.item?(position) ?? self.item(forPosition: position)
        cell.item = item
        cell.buttonTapped = { [unowned self] _ in
            self.itemTapped?(item, position)
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NumPad: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let position = self.position(forIndexPath: indexPath)
        let size = self.size(forItemAtPosition: position)
        return itemSize?(position) ?? size
    }
    
}

// MARK: - Public Helpers
public extension NumPad {
    
    func index(forPosition position: Position) -> Int {
        var index = (0..<position.row).map { columns($0) }.reduce(0, combine: +)
        index += position.column
        return index
    }
    
    func item(forPosition position: Position) -> Item? {
        let indexPath = self.indexPath(forPosition: position)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        return (cell as? Cell)?.item
    }
    
    func size(forItemAtPosition position: Position) -> CGSize {
        let indexPath = self.indexPath(forPosition: position)
        
        let numberOfRows = CGFloat(rows)
        let numberOfColumns = CGFloat(columns(indexPath.section))
        
        var size = collectionView.frame.size
        size.width /= numberOfColumns
        size.height /= numberOfRows
        return size
    }
    
}

// MARK: - Private Helpers
extension NumPad {
    
    func indexPath(forPosition position: Position) -> NSIndexPath {
        return NSIndexPath(forItem: position.column, inSection: position.row)
    }
    
    func position(forIndexPath indexPath: NSIndexPath) -> Position {
        return Position(row: indexPath.section, column: indexPath.item)
    }
    
    func item(forPosition position: Position) -> Item {
        let index = self.index(forPosition: position)
        
        var item = Item()
        
        let title: String
        switch index {
        case 9: title = "C"
        case 10: title = "0"
        case 11: title = "00"
        default: title = "\(index + 1)"
        }
        item.title = title
        
        if index == 9 {
            item.titleColor = .orangeColor()
        } else {
            item.titleColor = UIColor(white: 0.3, alpha: 1)
        }
        
        item.titleFont = .systemFontOfSize(40)
        
        return item
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
    
    var buttonTapped: (UIButton -> Void)?
    
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
