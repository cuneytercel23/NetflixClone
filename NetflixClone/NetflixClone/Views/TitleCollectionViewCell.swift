//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 1.10.2022.
//

// Bu CollectionTableViewCell içindeki, collectionviewcelller (sadece resimler)
import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView : UIImageView = {
        let imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFill // kutunu doldur
        return imageView
    }()
    
    
    override init(frame: CGRect) { // override required olayı şart
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
        // imageın çevresi contentviewın sınırları olsun. genelde ana ekranda view dioyurz, böylesubviewlar için contentView diyoruz.
    }
    
    
    
    //Fotoları çekme mevzuatı -SdWebimage ile
    
    public func configure(with models : String ) { // models ismini biz verdik.
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500\(models)") else {return}
        
        posterImageView.sd_setImage(with: url)
        
    }
}
