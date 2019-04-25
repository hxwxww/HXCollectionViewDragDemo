//
//  DragAndDropCollectionViewController.swift
//  HXCollectionViewDragDemo
//
//  Created by HongXiangWen on 2019/4/25.
//  Copyright © 2019年 WHX. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let cellSpacing: CGFloat = 15
private let cellWH: CGFloat = floor((UIScreen.main.bounds.width - 15 * 4) / 3)

class DragAndDropCollectionViewController: UICollectionViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.itemSize = CGSize(width: cellWH, height: cellWH)
        collectionView.setCollectionViewLayout(layout, animated: false)
        // 开启拖放手势，设置代理。
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
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
    
    // MARK: -  UICollectionViewDragDelegate, UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell,
            let text = emojiCell.emojiLabel.text else {
            return []
        }
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: text as NSItemProviderWriting))
        dragItem.localObject = text
        return [dragItem]
    }
    
    /// 设置拖拽cell的临时样式
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 10)
        return previewParameters
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: String.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath,
                let text = item.dragItem.localObject as? String {
                collectionView.performBatchUpdates({
                    emojis.remove(at: sourceIndexPath.item)
                    emojis.insert(text, at: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
}
