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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.allowsSelection = false
        collectionView.allowsMultipleSelection = true
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.register(Cell.self, forCellWithReuseIdentifier: String(describing: Cell.self))
//        collectionView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panned(recognizer:))))
//        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:))))
        self.addSubview(collectionView)
        collectionView.constrainToEdges()
        return collectionView
    }()
    
    /// Data source for the number pad.
    open weak var dataSource: NumPadDataSource?
    
    /// Delegate for the number pad.
    open weak var delegate: NumPadDelegate?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        _ = collectionView
    }
    
    open func invalidateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func longPressed(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            print("--->")
            for cell in collectionView.visibleCells as! [Cell] {
                let containsPoint = cell.frame.contains(point)
                cell.isHighlighted = containsPoint
            }
        default: break
        }
    }
    
    @IBAction func panned(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self)
        switch recognizer.state {
        case .changed, .ended:
            for cell in collectionView.visibleCells as! [Cell] {
                let containsPoint = cell.frame.contains(point)
                switch recognizer.state {
                case .changed:
                    cell.isHighlighted = containsPoint
                case .ended where containsPoint:
                    cell.button.sendActions(for: .touchUpInside)
                    fallthrough
                default:
                    cell.isHighlighted = false
                }
            }
        default: break
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension NumPad: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfColumns(section: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let position = self.position(forIndexPath: indexPath)
        guard let item = dataSource?.numPad(self, itemAtPosition: position) else { return Cell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
        cell.item = item
//        cell.buttonTapped = { [unowned self] _ in
//            self.delegate?.numPad(self, itemTapped: item, atPosition: position)
//        }
        return cell
    }
    
}

// MARK: - UICollectionViewDataSource
extension NumPad: UICollectionViewDelegate {
    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let position = self.position(forIndexPath: indexPath)
//        guard let item = dataSource?.numPad(self, itemAtPosition: position) else { return }
//        delegate?.numPad(self, itemTapped: item, atPosition: position)
//    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("----->")
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        print("----> Unhighlight")
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NumPad: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let position = self.position(forIndexPath: indexPath)
        let size = delegate?.numPad(self, sizeForItemAtPosition: position) ?? CGSize()
        return !size.isZero() ? size : {
            let indexPath = self.indexPath(for: position)
            var size = collectionView.bounds.size
            size.width /= CGFloat(numberOfColumns(section: indexPath.section))
            size.height /= CGFloat(numberOfRows())
            return size
        }()
    }
    
}

// MARK: -
public extension NumPad {
    
    /// Returns the item at the specified position.
    func item(for position: Position) -> Item? {
        let indexPath = self.indexPath(for: position)
        let cell = collectionView.cellForItem(at: indexPath)
        return (cell as? Cell)?.item
    }
    
}

// MARK: -
private extension NumPad {
    
    /// Returns the index path at the specified position.
    func indexPath(for position: Position) -> IndexPath {
        return IndexPath(item: position.column, section: position.row)
    }
    
    /// Returns the position at the specified index path.
    func position(forIndexPath indexPath: IndexPath) -> Position {
        return Position(row: indexPath.section, column: indexPath.item)
    }
    
    func numberOfRows() -> Int {
        return dataSource?.numberOfRowsInNumPad(self) ?? 0
    }
    
    func numberOfColumns(section: Int) -> Int {
        return dataSource?.numPad(self, numberOfColumnsInRow: section) ?? 0
    }
    
}
