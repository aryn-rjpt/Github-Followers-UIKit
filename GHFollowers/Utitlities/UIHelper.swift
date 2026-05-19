import UIKit

struct UIHelper{
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewLayout {
        let width               = view.bounds.width
        let padding             = 12.0
        let minItemsSpacing     = 10.0
        let availableWidth      = width - 2 * padding - 2 * minItemsSpacing
        let itemWidth           = availableWidth / 3
        
        let flowLayout          = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize     = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
        
        
    }
}
