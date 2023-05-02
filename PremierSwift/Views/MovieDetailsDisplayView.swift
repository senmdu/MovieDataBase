//
//  MovieDetailsDisplayView.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import UIKit


final class MovieDetailsDisplayView: UIView {
    
    private let scrollView : UIScrollView = {
        let scView = UIScrollView()
        scView.translatesAutoresizingMaskIntoConstraints = false
        return scView
    }()
    
    let backdropImageView :  UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Heading.medium
        lbl.textColor = UIColor.Text.charcoal
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.setContentHuggingPriority(.required, for: .vertical)
        return lbl
    }()
    
    private let overviewLabel : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Body.small
        lbl.textColor = UIColor.Text.grey
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let similarHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.Carosul.header
        lbl.text = LocalizedString(key: "movies.similar.title" )
        lbl.textColor =  UIColor.Text.charcoal
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private lazy var headerStackView : UIStackView = {
        let headerStack = UIStackView(arrangedSubviews: [similarHeaderLabel,similarHeaderViewAllButton])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        headerStack.distribution = .fillProportionally
        return headerStack
    }()
    
    private lazy var contentStackView :  UIStackView  = {
        let stackView  = UIStackView(arrangedSubviews: [backdropImageView, titleLabel, overviewLabel, headerStackView,  similarCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.setCustomSpacing(8, after: titleLabel)
        return stackView
    }()
    
    let similarHeaderViewAllButton: UIButton = {
        let btn = UIButton()
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleLabel?.font = UIFont.Body.small
        btn.setTitleColor(UIColor.Brand.popsicle40, for: .normal)
        btn.setImage(UIImage(named: "ArrowRight"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        btn.setTitle(LocalizedString(key: "movies.similar.viewall"), for: .normal)
        return btn
    }()
    
    let similarCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemBackground
        
        setupViewsHierarchy()
        setupConstraints()
    }
    /**
     Adding Views to `Hierarchy`
     */
    private func setupViewsHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
    }
    /**
     Setting up `Constraints`
     */
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                // ScrollView Constraints
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                
                backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 11 / 16, constant: 0),
                headerStackView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor),
                similarCollectionView.heightAnchor.constraint(equalToConstant: 350),
                
                // Content Stackview Constraints
                contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24)
            ]
        )
        
        scrollView.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        preservesSuperviewLayoutMargins = false
    }
    /**
     Configuring `MovieDetails` 
     */
    func configure(movieDetails: MovieDetails) {
        if let backDropImage = movieDetails.backdropPath {
            backdropImageView.dm_setImage(backdropPath: backDropImage)
        }else if let posterImage = movieDetails.posterPath {
            backdropImageView.dm_setImage(posterPath: posterImage)
        }
       
        
        titleLabel.text = movieDetails.title
        
        overviewLabel.text = movieDetails.overview
    }
}
