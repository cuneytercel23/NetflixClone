//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 6.10.2022.
//

import UIKit
// Arama yaptıktan sonra gelen ekran



protocol SearchResultsViewControllerDelegate : AnyObject {
    
    func searchResultsViewControllerDelegate(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var titleforsearchbar : [Title] = [Title]()
    
    public weak var delegate : SearchResultsViewControllerDelegate?
    
    
    public let searchResulsCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0	// bunun pek etkisi olmadı
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
        
        
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(searchResulsCollectionView)
        searchResulsCollectionView.delegate = self
        searchResulsCollectionView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResulsCollectionView.frame = view.bounds
    }


}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleforsearchbar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        
        let title = titleforsearchbar[indexPath.row]
        
        cell.configure(with: title.poster_path ?? "") // resim çektiğimiz title collectionviewcelldeki conf
        
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titleforsearchbar[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] results in
            switch results {
            case.success(let videoElement):
                self?.delegate?.searchResultsViewControllerDelegate(TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
            case.failure(let error):
                print(error.localizedDescription)
                
    }
    
    
}
    }
}
