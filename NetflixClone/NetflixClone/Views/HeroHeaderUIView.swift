//
//  HeroHeaderUIView.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 22.09.2022.
//

import UIKit
import SDWebImage

class HeroHeaderUIView: UIView {
    
    // İmage Oluşturma
    private let heroImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // bu ile aşağıdakileri anlaayıp anlamama arasındayım basit ama mantığa oturmuyor.
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "lacasadepapel")
        return imageView
        
    }()
    
    private let playButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1 // border kalınlığı
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
        
    }()
    
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1 // border kalınlığı
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
        
    }()
    
    
    private func applyConstraints() { // Kod ile Constraints yapmak.
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70), // soldan 90 git
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), // aşağıdan 50 yukarı cık
            playButton.widthAnchor.constraint(equalToConstant: 120)
            // 100 genişlik verdik ama çerçeve için verdik.
        ]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70), // soldan 90 git
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    
    
    private func addGradient() { // Ekranın Çevresini, çizgiyle kapladığımız bir uygulama (sadece header için)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
    }


    override init(frame: CGRect) { // override required ezber. // Buraya hep yazdığımız yaptığımız fonksiyonları çalıştırmaya geliyoruz. :D:DDDDDD
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurehhuview(with model : TitleViewModel) {
        
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500\(model.posterURL)") else {return}
        
        heroImageView.sd_setImage(with: url)
        
    }
    
    
    // layout subviews kısmı
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    
    
}
