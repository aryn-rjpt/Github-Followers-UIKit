import UIKit

enum GFDetailCardType {
    case githubCard
    case FollowerCard
}

class GFDetailCard: UIViewController {
    var count1: Int
    var count2: Int
    var cardType: GFDetailCardType
    
    var leftContainer = UIView()
    var rightContainer = UIView()
    var icon1 = UIImageView()
    var label1 = GFSecondaryLabel(fontSize: 18, weight: .bold)
    var countLabel1 = GFSecondaryLabel(fontSize: 18, weight: .bold)
    var icon2 = UIImageView()
    var label2 = GFSecondaryLabel(fontSize: 18, weight: .bold)
    var countLabel2 = GFSecondaryLabel(fontSize: 18, weight: .bold)
    
    var actionBtn: GFButton
    
    weak var delegate: UserInfoVCDelegate?
    
    init(count1: Int?, count2: Int?, card: GFDetailCardType){
        self.count1 = count1 ?? 0
        self.count2 = count2 ?? 0
        cardType = card
        
        actionBtn = GFButton(
            backgroundColor: card == .FollowerCard ? .systemGreen : .systemPink,
            title: card == .FollowerCard ? "Get Followers" : "Github Profile",
        )
        
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        layoutUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        
        icon1.image = UIImage(systemName: cardType == .FollowerCard ? SFSymbols.heart : SFSymbols.folder)
        icon2.image = UIImage(systemName: cardType == .FollowerCard ? SFSymbols.people : SFSymbols.text)
        icon1.tintColor                 = .label
        icon2.tintColor                 = .label
        icon1.contentMode               = .scaleAspectFit
        icon2.contentMode               = .scaleAspectFit
        
        label1.text                     = cardType == .FollowerCard ? "Following" : "Public Repos"
        label2.text                     = cardType == .FollowerCard ? "Followers" : "Public Gists"
        
        countLabel1.text                = "\(count1)"
        countLabel2.text                = "\(count2)"
        countLabel1.textAlignment       = .center
        countLabel2.textAlignment       = .center
        
        
        actionBtn.addTarget(self, action: #selector(actionBtnTapped), for: .touchUpInside)
        
    }
    
    @objc private func actionBtnTapped(){
        delegate?.didTapActionBtn(for: cardType)
    }
    
    
    private func layoutUI(){
        
        view.addSubview(leftContainer)
        view.addSubview(rightContainer)
        view.addSubview(actionBtn)
        leftContainer.addSubview(icon1)
        leftContainer.addSubview(label1)
        leftContainer.addSubview(countLabel1)
        rightContainer.addSubview(icon2)
        rightContainer.addSubview(label2)
        rightContainer.addSubview(countLabel2)
        
        
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.translatesAutoresizingMaskIntoConstraints = false
        icon1.translatesAutoresizingMaskIntoConstraints = false
        icon2.translatesAutoresizingMaskIntoConstraints = false
        
        let viewWidth = view.bounds.width
        
        let padding = 20.0
        
        NSLayoutConstraint.activate([
            leftContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            leftContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            leftContainer.widthAnchor.constraint(equalToConstant: viewWidth/2 - 30),
            leftContainer.heightAnchor.constraint(equalToConstant: 70),
            
            icon1.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            icon1.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            icon1.widthAnchor.constraint(equalToConstant: 30),
            icon1.heightAnchor.constraint(equalToConstant: 30),
            
            label1.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            label1.leadingAnchor.constraint(equalTo: icon1.trailingAnchor, constant: 10),
            label1.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor),
            label1.heightAnchor.constraint(equalToConstant: 30),
            
            countLabel1.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            countLabel1.trailingAnchor.constraint(equalTo: leftContainer.trailingAnchor),
            countLabel1.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 5),
            countLabel1.heightAnchor.constraint(equalToConstant: 30),
            
      
            rightContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            rightContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            rightContainer.widthAnchor.constraint(equalToConstant: viewWidth/2 - 30),
            rightContainer.heightAnchor.constraint(equalToConstant: 70),
            
            icon2.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            icon2.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            icon2.widthAnchor.constraint(equalToConstant: 30),
            icon2.heightAnchor.constraint(equalToConstant: 30),
            
            label2.leadingAnchor.constraint(equalTo: icon2.trailingAnchor, constant: 10),
            label2.topAnchor.constraint(equalTo: rightContainer.topAnchor),
            label2.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor),
            label2.heightAnchor.constraint(equalToConstant: 30),
            
            countLabel2.leadingAnchor.constraint(equalTo: rightContainer.leadingAnchor),
            countLabel2.trailingAnchor.constraint(equalTo: rightContainer.trailingAnchor),
            countLabel2.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 5),
            countLabel2.heightAnchor.constraint(equalToConstant: 30),
            
            
            actionBtn.topAnchor.constraint(equalTo: leftContainer.bottomAnchor, constant: padding),
            actionBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionBtn.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
