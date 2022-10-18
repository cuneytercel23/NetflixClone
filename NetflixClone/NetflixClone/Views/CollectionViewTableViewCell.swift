//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 21.09.2022.
//

import UIKit

protocol collectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell : CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
        
}

// CollectionViewTableViewCell ismi var ama UITABLEVIEWCELL UNUTMAA !
// staticlet id, override init , required init kısımı en baş kısım ve ezber. Daha sonra yeni şeyler ekliyoruz.
// bunu daha sonra homeviewcontrollerdaki register yaptığımız uitableviewcell yerine collectiontableviewcell yazıyoruz.
class CollectionViewTableViewCell: UITableViewCell {
    
    private var titles : [Title] = [Title]()
    
static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate : collectionViewTableViewCellDelegate?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView) // oluşturduğumuz collectionviewı ekleme.
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds // çerçevesi contentviewın sınırları olsun
    }
    
    
    
    public func configure(with baslik : [Title]) { // Buradaki titles kısmını, baslik(homeviewda kullancaz) a eşitliyoruz.
        self.titles = baslik
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    
    
    // collectionview oluşturulması tableview cell içine
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200) // kutu(item) büyüklüğü
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout )
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier) // ilkine türü ikincisine özel isim
    
        return collectionView
    }()
    
    
    // contextMenuConfigurationForItemAt (aşağıda) fonksiyonu ile alakalı
    
    //Coredata Kısmını da burda yapıcaz.(Datapersistenmanager)
    private func downloadTitleAt(indexPatso: IndexPath){
        
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPatso.row]) { resultsforcoredata in
            switch resultsforcoredata {
            case .success(): // void var diye içine tanımıyoruz bir şey
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    }


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource { // Bunda Cellforitem, numbersofiteminsec var :).
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        guard let model = titles[indexPath.row].poster_path else {return UICollectionViewCell()}
        cell.configure(with: model) // Titleda açtığım configure fonksiyonunu kullanarak, resim çekiyoruz. 

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count// bir tableview cellindeki item sayısı (kutu)
        
    }
    
    // youtube api için search kısımı
    // Bastığımız yerde 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        // deselect hiçbirini seçme, yada seçimi kaldır demek
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] results in
            switch results {
            case.success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {return}
                guard let strongSelf = self else {return}
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            
            case.failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    // Bir filme basılı tutunca indir butonu çıkartırıyoruz bu fonksiyon ile
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                // state kısımı downloadın yanında mixed dersen tik, off dersen boş falan yapıyor.
                
                self?.downloadTitleAt(indexPatso: indexPath) // yukarıda fonksiyon yaptık bunu için
                
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
}

