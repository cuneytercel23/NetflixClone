//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 3.10.2022.
//

import UIKit
//Bu tableviewcell, örneğin upcomingde gördüğümüz her şey.

class TitleTableViewCell: UITableViewCell {

    static let identifier = "UITableViewCell"
    
    private let  playTitleButton : UIButton  = {
       let button = UIButton()
        let image = UIImage(systemName: "play.circle" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)) // sağ taraf butonun büyüklüğü
        button.setImage(image, for: .normal )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white

        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    
    private let titlePosterUIimageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // tableview için view, subviewler için contentviewdı, fotolar içinde content var . Burada contentmode diye geçiyor, ekranı doldurma mevzusu için
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true // bu fotoların dışarı kaymasını önler.
        
        return imageView
    }()
    
    
    
    // override required ezbers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterUIimageView) // resim de subview olduğu için contentviewa koyduk.
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        
        applyConstraints()
        
    }
    
    private func applyConstraints() {
        let titlePosterUIimageViewConstraints = [
            titlePosterUIimageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUIimageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titlePosterUIimageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            titlePosterUIimageView.widthAnchor.constraint(equalToConstant: 100) ]
        
        let titleLabelConstraints = [titleLabel.leadingAnchor.constraint(equalTo: titlePosterUIimageView.trailingAnchor, constant: 20),
                                     titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), titleLabel.trailingAnchor.constraint(equalTo: playTitleButton.trailingAnchor, constant: -15)
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)]
        
        NSLayoutConstraint.activate(playTitleButtonConstraints)
        NSLayoutConstraint.activate(titlePosterUIimageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    
    //Url alır resim indirir ve yerleştirir.
    public func configure(with model : TitleViewModel) {
       
        guard let url = URL(string:"https://image.tmdb.org/t/p/w500\(model.posterURL)") else {return}
        
        titlePosterUIimageView.sd_setImage(with: url)
        titleLabel.text = model.titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
