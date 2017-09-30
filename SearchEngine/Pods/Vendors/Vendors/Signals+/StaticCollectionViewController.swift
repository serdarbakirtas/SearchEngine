//
//  StaticCollectionViewController.swift
//  fotobaski
//
//  Created by ALI KIRAN on 3/15/16.
//  Copyright © 2016 ALI KIRAN. All rights reserved.
//

import Foundation
import Signals

class StaticCollectionViewController: UICollectionViewController {
  var cellTouchEvent: Signal<(IndexPath?, StaticCollectionViewCell, UICollectionView)> = Signal<(IndexPath?, StaticCollectionViewCell, UICollectionView)>()
  var isReady: Bool = false
  var readyEvent: Signal<Void> = Signal<Void>()
  var selectedIndexPath: IndexPath?

  override func viewDidLoad() {
    isReady = true
    collectionView!.reload({
      self.readyEvent.fire()
    })

    cellTouchEvent.subscribe(on: self) { [unowned self] index, _, _ in
      self.selectedIndexPath = index
    }
  }

  func reset() {
    selectedIndexPath = nil
    collectionView?.reloadData()
  }

  var _actions: [String] = []
  var dataProvider: [String: [String: AnyObject]] = [:]
  var itemCount: Int = 0
  @IBInspectable var actions: String = "" {
    didSet {
      _actions = actions.characters.split { $0 == "," }.map(String.init)
      self.itemCount = _actions.count
      // self.collectionView?.reloadData()
    }
  }
  override func numberOfSections(in _: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return _actions.count
  }

  func setLabel(_ label: String, index: Int) {
    let identifier = _actions[index]
    if dataProvider[identifier] == nil {
      dataProvider[identifier] = Dictionary<String, AnyObject>()
    }

    dataProvider[identifier]!["label"] = label as AnyObject?
  }

  func setImage(_ image: UIImage, index: Int) {
    let identifier = _actions[index]
    if dataProvider[identifier] == nil {
      dataProvider[identifier] = Dictionary<String, AnyObject>()
    }

    dataProvider[identifier]!["image"] = image
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = _actions[(indexPath as NSIndexPath).item]
    let cell: StaticCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! StaticCollectionViewCell

    if let data = dataProvider[identifier] {
      if let label = data["label"] {
        cell.label.text = (label as! String)
      }

      if let image = data["image"] {
        cell.photo.image = (image as! UIImage)
      }
    }

    if (indexPath as NSIndexPath).row == (selectedIndexPath as NSIndexPath?)?.row {
      cell.select()
    } else {
      cell.deselect()
    }

    return cell
  }

  func selectItem(_ index: Int) {
    let cell: StaticCollectionViewCell = collectionView!.cellForItem(at: IndexPath(item: index, section: 0)) as! StaticCollectionViewCell
    cell.actionTouch(nil)
  }

  func itemAt(_ index: Int) -> StaticCollectionViewCell {
    return collectionView!.cellForItem(at: IndexPath(item: index, section: 0)) as! StaticCollectionViewCell
  }
}

class StaticCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var photo: UIImageView!
  @IBOutlet weak var btnHit: UIButton!

  @IBOutlet weak var indicatorView: UIView?
  @IBAction func actionTouch(_: UIButton?) {
    let collection: UICollectionView = findClassInstance(self)!
    let indexPath = collection.indexPath(for: self)
    let space: StaticCollectionViewController = findClassInstance(self)!
    space.cellTouchEvent.fire((indexPath, self, collection))

    select()

    for cell in collection.visibleCells where cell is StaticCollectionViewCell && cell != self {
      let spaceCell = cell as! StaticCollectionViewCell
      spaceCell.indicatorView?.isHidden = true
    }
  }

  func deselect() {
    indicatorView?.isHidden = true
  }

  func select() {
    let collection: UICollectionView = findClassInstance(self)!
    let indexPath = collection.indexPath(for: self)
    let space: StaticCollectionViewController = findClassInstance(self)!
    space.selectedIndexPath = indexPath

    if let indicatorView = indicatorView {
      indicatorView.isHidden = false
    }
  }
}

class SpaceCollectionContainer: UIView {
  var menu: StaticCollectionViewController {
    return (self.subviews.first! as UIView).next as! StaticCollectionViewController
  }
}

func findClassInstance<T>(_ responder: UIResponder) -> T? {
  func traverseResponderChainForUIViewController(_ responder: UIResponder) -> T? {
    if let nextResponder = responder.next {
      if let nextResp = nextResponder as? T {
        return nextResp
      } else {
        return traverseResponderChainForUIViewController(nextResponder)
      }
    }
    return nil
  }

  return traverseResponderChainForUIViewController(responder)
}

func superviewWithClassName(_ className: String, fromView view: UIView?) -> UIView? {
  guard let classType = NSClassFromString(className) else {
    return nil
  }
  var v: UIView? = view
  while v != nil {
    if v!.isKind(of: classType) {
      return v
    }
    v = v!.superview
  }
  return nil
}

class FixedPhotoCountFlow: UICollectionViewFlowLayout {
  @IBInspectable var columnCount: Int = 3 {
    didSet {
      self.invalidateLayout()
    }
  }

  @IBInspectable var vertical: Bool = true {
    didSet {
      self.invalidateLayout()
    }
  }

  @IBInspectable var padding: CGFloat = 10.0 {
    didSet {
      self.invalidateLayout()
    }
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override func prepare() {
    super.prepare()

    setup()
  }

  override func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
    return true
  }

  func setup() {

    let contentSize = collectionView != nil ? collectionView!.bounds : UIScreen.main.bounds
    let cellSize = floor((contentSize.width - (CGFloat(columnCount) + 1) * padding) / CGFloat(columnCount))
    minimumLineSpacing = padding
    sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding)
    scrollDirection = vertical ? UICollectionViewScrollDirection.vertical : UICollectionViewScrollDirection.horizontal
    itemSize = CGSize(width: cellSize, height: min(cellSize, collectionView!.height))
  }
}
