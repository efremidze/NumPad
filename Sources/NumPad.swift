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
        let collectionView = CollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clearColor()
        collectionView.allowsSelection = false
        collectionView.scrollEnabled = false
        collectionView.numPad = self
        collectionView.dataSource = collectionView
        collectionView.delegate = collectionView
        collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: String(Cell))
        self.addSubview(collectionView)
        let views = ["collectionView": collectionView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|", options: [], metrics: nil, views: views))
        return collectionView
    }()
    
    /// The number of rows.
    public var rows: Int
    
    /**
     The number of columns in row.
     
         numPad.columns = { row in
            return 3
         }
     */
    public var columns: (Int -> Int)
    
    /**
     The item at position.
     
         numPad.item = { position in
            return Item()
         }
     */
    public var item: (Position -> Item)?
    
    /**
     The size of an item at position.
     
         numPad.itemSize = { position in
             return CGSize(width: 20, height: 20)
         }
     */
    public var itemSize: (Position -> CGSize)?
    
    /**
     The item was tapped handler.
     
         numPad.itemTapped = { item, position in
             print("item tapped")
         }
     */
    public var itemTapped: ((Item, Position) -> Void)?
    
    override public init(frame: CGRect) {
        rows = 4
        columns = { _ in 3 }
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        rows = 4
        columns = { _ in 3 }
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.item = { position in
            let index = self.index(forPosition: position)
            
            var item = Item()
            
            switch index {
            case 9:
                item.title = "C"
            case 10:
                item.title = "0"
            case 11:
                item.title = "00"
            default:
                item.title = "\(index + 1)"
            }
            
            switch index {
            case 9:
                item.titleColor = .orangeColor()
            default:
                item.titleColor = UIColor(white: 0.3, alpha: 1)
            }
            
            item.titleFont = .systemFontOfSize(40)
            
            return item
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - Public Helpers
public extension NumPad {
    
    /// Returns the index at the specified position.
    func index(forPosition position: Position) -> Int {
        var index = (0..<position.row).map { columns($0) }.reduce(0, combine: +)
        index += position.column
        return index
    }
    
    /// Returns the item at the specified position.
    func item(forPosition position: Position) -> Item? {
        let indexPath = self.indexPath(forPosition: position)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        return (cell as? Cell)?.item
    }
    
    /// Returns the item size at the specified position.
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
    
}

// MARK: - CollectionView
class CollectionView: UICollectionView {
    
    weak var numPad: NumPad!
    
}

// MARK: - UICollectionViewDataSource
extension CollectionView: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numPad.rows
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numPad.columns(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let position = numPad.position(forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(Cell), forIndexPath: indexPath) as! Cell
        let item = numPad.item?(position) ?? Item()
        cell.item = item
        cell.buttonTapped = { [unowned self] _ in
            self.numPad.itemTapped?(item, position)
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let position = numPad.position(forIndexPath: indexPath)
        let size = numPad.size(forItemAtPosition: position)
        return numPad.itemSize?(position) ?? size
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
