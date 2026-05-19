
import UIKit

class GFUserInfoFooter: UICollectionReusableView {
    
    static let resuseId = "footer"
    var date = ""
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(date: String){
        self.date = date
        configure()
    }
    
    func configure(){
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Github User Since: \(date)"
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
    
}
