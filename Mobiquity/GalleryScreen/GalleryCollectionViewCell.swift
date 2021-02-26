//
//  GalleryCollectionViewCell.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GalleryCollectionViewCell"
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        setupConstraints(for: imageView)
        return imageView
    }()
    
    // MARK: Public Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }

    func setup(with image: UIImage) {
        photoImageView.image = image
    }
    
}

extension GalleryCollectionViewCell {
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.clipsToBounds = true
        photoImageView.image = UIImage(named: "photo_placeholder_icon")
    }
    
    private func setupConstraints(for imageView: UIImageView) {
        self.addSubview(imageView)
        
        imageView.topAnchor
            .constraint(equalTo: contentView.topAnchor)
            .isActive = true
        imageView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor)
            .isActive = true
        imageView.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        imageView.centerXAnchor
            .constraint(equalTo: contentView.centerXAnchor)
            .isActive = true
    }
    
}
