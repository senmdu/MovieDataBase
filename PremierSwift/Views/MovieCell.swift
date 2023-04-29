import UIKit

final class MovieCell: UITableViewCell {
    
    static private let columnSpacing: CGFloat = 16
    private let posterSize = CGSize(width: 92, height: 134)
    
    let tagView : TagView = TagView()
    
    let coverImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.cornerRadius = 8
        img.layer.masksToBounds = true
        return img
    }()
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Heading.small
        lbl.textColor = UIColor.Text.charcoal
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Body.small
        lbl.textColor = UIColor.Text.grey
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    let textStackView : UIStackView  = {
        let stcView =  UIStackView()
        stcView.spacing = 4
        stcView.alignment = .leading
        stcView.axis = .vertical
        return stcView
    }()
    
    let imageStackView : UIStackView  = {
        let stcView =  UIStackView()
        stcView.spacing = 10
        stcView.alignment = .leading
        stcView.axis = .vertical
        return stcView
    }()
    
    let containerStackView : UIStackView  = {
        let stcView =  UIStackView()
        stcView.spacing = columnSpacing
        stcView.alignment = .top
        stcView.translatesAutoresizingMaskIntoConstraints = false
        return stcView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        setupViewsHierarchy()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupViewsHierarchy() {
        contentView.addSubview(containerStackView)
        imageStackView.dm_addArrangedSubviews(coverImage, tagView)
        textStackView.dm_addArrangedSubviews(titleLabel, descriptionLabel)
        containerStackView.dm_addArrangedSubviews(imageStackView, textStackView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -10),
            
            coverImage.widthAnchor.constraint(equalToConstant: posterSize.width),
            coverImage.heightAnchor.constraint(equalToConstant: posterSize.height)
        ])
    }
    
    func configure(_ movie: Movie) {
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
        tagView.configure(.rating(value: movie.voteAverage))
        
        if let path = movie.posterPath {
            coverImage.dm_setImage(posterPath: path)
        } else {
            coverImage.image = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
