//
//  NumPad.swift
//  NumPad
//
//  Created by Lasha Efremidze on 1/9/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

public typealias Row = Int
public typealias Column = Int

// MARK: - Position
public typealias Position = (row: Row, column: Column)

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
    public var rows: Int = 0
    
    /**
     The number of columns in row.
     
         numPad.columns = { row in
            return 3
         }
     */
    public var columns: (Row -> Int) = { _ in 0 }
    
    /**
     The item at position.
     
         numPad.item = { position in
            return Item()
         }
     */
    public var item: (Position -> Item) = { _ in Item() }
    
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
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - Public Helpers
public extension NumPad {
    
    /// Returns the item at the specified position.
    func item(forPosition position: Position) -> Item? {
        let indexPath = self.indexPath(forPosition: position)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        return (cell as? Cell)?.item
    }
    
}

// MARK: - Private Helpers
extension NumPad {
    
    /// Returns the index path at the specified position.
    func indexPath(forPosition position: Position) -> NSIndexPath {
        return NSIndexPath(forItem: position.column, inSection: position.row)
    }
    
    /// Returns the position at the specified index path.
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
        let item = numPad.item(position)
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
        return numPad.itemSize?(position) ?? {
            let indexPath = numPad.indexPath(forPosition: position)
            var size = collectionView.frame.size
            size.width /= CGFloat(numPad.columns(indexPath.section))
            size.height /= CGFloat(numPad.rows)
            return size
        }()
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
    
    convenience init(color: UIColor) {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: CGPoint(), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
    
}

// MARK: - DefaultNumPad
public class DefaultNumPad: NumPad {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        rows = 4
        columns = { _ in 3 }
        item = { [unowned self] position in
            var item = Item()
            item.title = {
                switch position {
                case (3, 0):
                    return "C"
                case (3, 1):
                    return "0"
                case (3, 2):
                    return "00"
                default:
                    var index = (0..<position.row).map { self.columns($0) }.reduce(0, combine: +)
                    index += position.column
                    return "\(index + 1)"
                }
            }()
            item.titleColor = {
                switch position {
                case (3, 0):
                    return .orangeColor()
                default:
                    return UIColor(white: 0.3, alpha: 1)
                }
            }()
            item.titleFont = .systemFontOfSize(40)
            return item
        }
    }
    
}
