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
    public var backgroundColor: UIColor? = .white
    public var selectedBackgroundColor: UIColor? = .clear
    public var image: UIImage?
    public var title: String?
    public var titleColor: UIColor? = .black
    public var font: UIFont? = .systemFont(ofSize: 17)
    
    public init() {}
    public init(title: String?) {
        self.title = title
    }
    public init(image: UIImage?) {
        self.image = image
    }
}

// MARK: - NumPadDataSource
public protocol NumPadDataSource: class {
    
    /// The number of rows.
    func numberOfRowsInNumPad(_ numPad: NumPad) -> Int
    
    /// The number of columns.
    func numPad(_ numPad: NumPad, numberOfColumnsInRow row: Row) -> Int
    
    /// The item at position.
    func numPad(_ numPad: NumPad, itemAtPosition position: Position) -> Item
    
}

// MARK: - NumPadDelegate
public protocol NumPadDelegate: class {
    
    /// The item was tapped handler.
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position)
    
    /// The size of an item at position.
    func numPad(_ numPad: NumPad, sizeForItemAtPosition position: Position) -> CGSize
    
}

public extension NumPadDelegate {
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {}
    func numPad(_ numPad: NumPad, sizeForItemAtPosition position: Position) -> CGSize { return CGSize() }
}

// MARK: - NumPad
open class NumPad: UIView {
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = CollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = false
        collectionView.isScrollEnabled = false
        collectionView.numPad = self
        collectionView.dataSource = collectionView
        collectionView.delegate = collectionView
        collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
        self.addSubview(collectionView)
        let views = ["collectionView": collectionView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: views))
        return collectionView
    }()
    
    /// Data source for the number pad.
    open weak var dataSource: NumPadDataSource?
    
    /// Delegate for the number pad.
    open weak var delegate: NumPadDelegate?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

// MARK: - Public Helpers
public extension NumPad {
    
    /// Returns the item at the specified position.
    func item(forPosition position: Position) -> Item? {
        let indexPath = self.indexPath(forPosition: position)
        let cell = collectionView.cellForItem(at: indexPath)
        return (cell as? Cell)?.item
    }
    
}

// MARK: - Private Helpers
extension NumPad {
    
    /// Returns the index path at the specified position.
    func indexPath(forPosition position: Position) -> IndexPath {
        return IndexPath(item: position.column, section: position.row)
    }
    
    /// Returns the position at the specified index path.
    func position(forIndexPath indexPath: IndexPath) -> Position {
        return Position(row: indexPath.section, column: indexPath.item)
    }
    
}

// MARK: - CollectionView
class CollectionView: UICollectionView {
    
    weak var numPad: NumPad!
    
}

// MARK: - UICollectionViewDataSource
extension CollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numPad.dataSource?.numberOfRowsInNumPad(numPad) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numPad.dataSource?.numPad(numPad, numberOfColumnsInRow: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let position = numPad.position(forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        let item = numPad.dataSource?.numPad(numPad, itemAtPosition: position) ?? Item()
        cell.item = item
        cell.buttonTapped = { [unowned self] _ in
            self.numPad.delegate?.numPad(self.numPad, itemTapped: item, atPosition: position)
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let position = numPad.position(forIndexPath: indexPath)
        let size = numPad.delegate?.numPad(numPad, sizeForItemAtPosition: position) ?? CGSize()
        return !size.isZero() ? size : {
            let indexPath = numPad.indexPath(forPosition: position)
            var size = collectionView.frame.size
            size.width /= CGFloat(self.collectionView(self, numberOfItemsInSection: indexPath.section))
            size.height /= CGFloat(self.numberOfSections(in: self))
            return size
        }()
    }
    
}

// MARK: - Cell
class Cell: UICollectionViewCell {
    
    lazy var button: UIButton = { [unowned self] in
        let button = UIButton(type: .custom)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(_buttonTapped), for: .touchUpInside)
        self.contentView.addSubview(button)
        let views = ["button": button]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[button]|", options: [], metrics: nil, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[button]|", options: [], metrics: nil, views: views))
        return button
    }()
    
    var item: Item! {
        didSet {
            button.setTitle(item.title, for: UIControlState())
            
            button.setTitleColor(item.titleColor, for: UIControlState())
            
            button.titleLabel?.font = item.font
            
            button.setImage(item.image, for: UIControlState())
            
            var image = item.backgroundColor.map { UIImage(color: $0) }
            button.setBackgroundImage(image, for: UIControlState())
            image = item.selectedBackgroundColor.map { UIImage(color: $0) }
            button.setBackgroundImage(image, for: .highlighted)
            button.setBackgroundImage(image, for: .selected)
            
            button.tintColor = item.titleColor
        }
    }
    
    var buttonTapped: ((UIButton) -> Void)?
    
    @IBAction func _buttonTapped(_ button: UIButton) {
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
        self.init(cgImage: (image?.cgImage!)!)
    }
    
}

// MARK: - CGSize
extension CGSize {
    
    func isZero() -> Bool {
        return self.equalTo(CGSize())
    }
    
}

// MARK: - DefaultNumPad
open class DefaultNumPad: NumPad {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        dataSource = self
    }
    
}

extension DefaultNumPad: NumPadDataSource {
    
    public func numberOfRowsInNumPad(_ numPad: NumPad) -> Int {
        return 4
    }
    
    public func numPad(_ numPad: NumPad, numberOfColumnsInRow row: Row) -> Int {
        return 3
    }
    
    public func numPad(_ numPad: NumPad, itemAtPosition position: Position) -> Item {
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
                var index = (0..<position.row).map { self.numPad(self, numberOfColumnsInRow: $0) }.reduce(0, +)
                index += position.column
                return "\(index + 1)"
            }
        }()
        item.titleColor = {
            switch position {
            case (3, 0):
                return .orange
            default:
                return UIColor(white: 0.3, alpha: 1)
            }
        }()
        item.font = .systemFont(ofSize: 40)
        return item
    }
    
}
