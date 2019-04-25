//
//  LongPressCollectionViewController.swift
//  HXCollectionViewDragDemo
//
//  Created by HongXiangWen on 2019/4/25.
//  Copyright © 2019年 WHX. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let cellSpacing: CGFloat = 15
private let cellWH: CGFloat = floor((UIScreen.main.bounds.width - 15 * 4) / 3)

class LongPressCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.itemSize = CGSize(width: cellWH, height: cellWH)
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        /// UICollectionViewController默认开启长按拖拽手势
        installsStandardGestureForInteractiveMovement = false
        /// 如果是UIViewController中的UICollectionView则手动添加长按拖拽手势
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(collectionViewHandleLongPressGesture(gesture:))))
    }
    
    /// 记录长按的手指中心点相对于临时视图的偏移
    private var tmpCellCenterOffset: CGPoint = .zero
    private var dragCell: UICollectionViewCell?
    
    /// 长按拖拽调换位置
    @objc private func collectionViewHandleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        let locationCenter = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)),
                let cell = collectionView.cellForItem(at: indexPath) else { return }
            tmpCellCenterOffset = CGPoint(x: cell.center.x - locationCenter.x, y: cell.center.y - locationCenter.y)
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            dragCell = cell
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            let targetPosition = locationCenter.applying(CGAffineTransform(translationX: tmpCellCenterOffset.x, y: tmpCellCenterOffset.y))
            collectionView.updateInteractiveMovementTargetPosition(targetPosition)
        case .ended:
            UIView.animate(withDuration: 0.2, animations: {
                self.dragCell?.transform = CGAffineTransform.identity
            }) { (_) in
                self.dragCell = nil
            }
            collectionView.endInteractiveMovement()
        default:
            UIView.animate(withDuration: 0.2, animations: {
                self.dragCell?.transform = CGAffineTransform.identity
            }) { (_) in
                self.dragCell = nil
            }
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private var emojis = "😀😔😕🙃🤑😲☹️🙁😖😞😟😤😢😭😦😧😨😩🤯😬😰😱😳🤪😵😡😠🤬😷🤒🤕🤢🤮🤧😇🤠🤡🤥🤫🤭🧐🤓😈👿".map { String($0) }
    
    // MARK: UICollectionViewDataSource, UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let emojiCell = cell as? EmojiCollectionViewCell {
            emojiCell.emojiLabel.text = emojis[indexPath.item]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let emoji = emojis[sourceIndexPath.item]
        emojis.remove(at: sourceIndexPath.item)
        emojis.insert(emoji, at: destinationIndexPath.item)
    }
    
}
