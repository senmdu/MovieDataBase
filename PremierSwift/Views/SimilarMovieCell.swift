//
//  SimilarMovieCell.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import UIKit

final class SimilarMovieCell: UICollectionViewCell {
    
    static let columnSpacing: CGFloat = 16
    static let edgeInsets = UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 2)
    static let contentSize = CGSize(width: 150, height: 350)
    fileprivate let posterSize = CGSize(width: 144, height: 212)
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Carosul.title
        lbl.textColor = UIColor.Text.charcoal
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Carosul.subtitle
        lbl.textColor = UIColor.Text.grey
        lbl.numberOfLines = 2
        lbl.lineBreakMode = .byTruncatingTail
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    let coverImage : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 14
        return img
    }()
    let tagView : TagView = {
        let tgView = TagView()
        tgView.translatesAutoresizingMaskIntoConstraints = false
        return tgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func commonInit() {
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        setupViewsHierarchy()
        setupConstraints()
    }
    
    /**
     Adding Views to `Hierarchy`
     */
    private func setupViewsHierarchy() {
        self.contentView.addSubview(coverImage)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(tagView)
    }
    
    /**
     Setting up `Constraints`
     */
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            // Cover image Constraints
            coverImage.topAnchor.constraint(equalTo: self.topAnchor),
            coverImage.leftAnchor.constraint(equalTo: self.leftAnchor),
            coverImage.rightAnchor.constraint(equalTo: self.rightAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: posterSize.height),
            
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            // Description Label Constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            // Tag View Constraints
            tagView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            tagView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            tagView.heightAnchor.constraint(equalToConstant: 32),
            tagView.widthAnchor.constraint(equalToConstant: 65)
            
        ])
    }
    
    /**
     Configuring `Movie`
     */
    func configure(_ movie: Movie) {
        titleLabel.text = movie.title
        if let genreIds = movie.genreIds {
            descriptionLabel.text = Genres.get(by: genreIds)
        }
        tagView.configure(.rating(value: movie.voteAverage))
        
        if let path = movie.posterPath {
            coverImage.dm_setImage(posterPath: path)
        } else {
            coverImage.image = nil
        }
    }
}
