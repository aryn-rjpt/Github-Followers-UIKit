
import UIKit

class GFSecondaryLabel: UILabel {

    init(fontSize: CGFloat, weight: UIFont.Weight = .medium){
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        textColor                   = .secondaryLabel
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.90
        lineBreakMode               = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
