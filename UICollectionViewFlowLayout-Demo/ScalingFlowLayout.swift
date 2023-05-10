//
//  ScalingFlowLayout.swift
//  UICollectionViewFlowLayout-Demo
//
//  Created by Armand Kaguermanov on 10/05/2023.
//

import UIKit

class ScalingFlowLayout: UICollectionViewFlowLayout {
    var offset: CGFloat { UIScreen.main.bounds.width * 0.4 }
    var minScale: CGFloat { 75 / (UIScreen.main.bounds.height * 0.4) }
    var maxScale: CGFloat = 1
    var minAlpha: CGFloat = 0.25
    var scaleItems: Bool = true
    
    private var previousSize: CGSize = .zero
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        cache.removeAll()
        setupItemSize()
        setupSectionInset()
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        
        guard let cv = collectionView else { return }
        let currentSize = cv.bounds.size
        if !currentSize.equalTo(previousSize) {
            cache.removeAll()
            previousSize = currentSize
        }
    }
    
    private func setupItemSize() {
        let sideSize: CGFloat = offset
        let spacing: CGFloat = (UIScreen.main.bounds.height - (sideSize * 3)) / 4
        
        minimumLineSpacing = spacing
        itemSize = CGSize(width: sideSize, height: sideSize)
        scrollDirection = .vertical
    }
    
    private func setupSectionInset() {
        guard let cv = collectionView else { return }
        
        let insetX = (cv.bounds.width - itemSize.width) / 2
        let insetY = (cv.bounds.height - itemSize.height) / 2
        sectionInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let cv = collectionView else { return proposedOffset }
        
        let size = cv.bounds.size
        let proposedRect = CGRect(x: proposedOffset.x, y: proposedOffset.y, width: size.width, height: size.height)
        guard let attrs = layoutAttributesForElements(in: proposedRect) else { return proposedOffset }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedCenterY = proposedOffset.y + size.height / 2
        
        for attr in attrs {
            if attr.representedElementCategory != .cell { continue }
            if candidateAttributes == nil || abs(attr.center.y - proposedCenterY) < abs(candidateAttributes!.center.y - proposedCenterY) {
                candidateAttributes = attr
            }
        }
        
        guard let candidate = candidateAttributes else { return proposedOffset }
        
        var newY = candidate.center.y - cv.bounds.height / 2
        let offset = newY - cv.contentOffset.y
        
        if (velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0) {
            let pageHeight = itemSize.height + minimumLineSpacing
            newY += velocity.y > 0 ? pageHeight : -pageHeight
        }
        
        return CGPoint(x: proposedOffset.x, y: newY)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !scaleItems || collectionView == nil {
            return super.layoutAttributesForElements(in: rect)
        }
        
        if cache.isEmpty {
            guard let superAttrs = super.layoutAttributesForElements(in: rect) else { return nil }
            
            let offset = collectionView!.contentOffset
            let size = collectionView!.bounds.size
            
            let visibleRect = CGRect(x: offset.x, y: offset.y, width: size.width, height: size.height)
            let visibleCenterY = visibleRect.midY
            
            for attr in superAttrs {
                let newAttr = attr.copy() as! UICollectionViewLayoutAttributes
                cache.append(newAttr)
                
                let distance = visibleCenterY - newAttr.center.y
                let absDistance = min(abs(distance), self.offset)
                
                let scale = absDistance * (minScale - maxScale) / self.offset + maxScale
                let alpha = absDistance * (minAlpha - 1) / self.offset + 1
                
                newAttr.alpha = alpha
                newAttr.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
                newAttr.zIndex = Int(alpha * 10)
            }
        }
        
        return cache
    }
}
