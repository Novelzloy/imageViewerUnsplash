//
//  ItemsCollectionViewCell.swift
//  imageViewerUnsplash
//
//  Created by Роман on 08.02.2022.
//

import UIKit

class ItemsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemsCollectionViewCell"
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    func config(with url: String) {
        guard let urlString = URL(string: url) else {return}
        URLSession.shared.dataTask(with: urlString) {[weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self?.imageView.image = image
            }
        }.resume()
    }
}
