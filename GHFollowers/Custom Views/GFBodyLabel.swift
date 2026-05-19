
import UIKit

class GFBodyLabel: UILabel {

    init(textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        
        self.textAlignment = textAlignment
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        font                        = UIFont.preferredFont(forTextStyle: .body)
        textColor                   = .secondaryLabel
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.75
        lineBreakMode               = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
