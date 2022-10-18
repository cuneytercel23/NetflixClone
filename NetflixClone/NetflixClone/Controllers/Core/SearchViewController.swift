//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 21.09.2022.
//

import UIKit




class SearchViewController: UIViewController {
    
    private var titlesv : [Title] = [Title]()
    
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()
    
    // Search oluşturuyoruz.
    private let searchController : UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultsViewController()) // searchResultsController bunu
        controller.searchBar.placeholder = "Search for a Movie or TV Show"
        controller.searchBar.searchBarStyle = .minimal // stilini yapıyoruz
        return controller
        
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        navigationItem.searchController = searchController // yukarıda yaptığımız searchcontrollerı, navigationa atadık.
        navigationController?.navigationBar.tintColor = .white // serchbarın yanındaki cancel yazısını beyaz yapmak için
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
        fetchDiscoverMovies()
        
        // aşağıdaki extension bununla alakalı
        searchController.searchResultsUpdater = self
        
    }
    
    
    func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { results in
            switch results {
            case.success(let titlefordiscmv):
                self.titlesv = titlefordiscmv
                DispatchQueue.main.async {
                    self.discoverTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

  

}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        
        let titleipr = titlesv[indexPath.row]
        
        let model = TitleViewModel(titleName: titleipr.original_name ?? titleipr.original_title ?? "Unknown Name", posterURL: titleipr.poster_path ?? "")
        cell.configure(with: model) // TitleTableViewCellde olulturulan confgiure
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // tıklanınca youtube açılması
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titlesv[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] results in
            switch results {
            case.success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}

// arama sonucu güncellemesi, açıkcası pek anlayamadım., aslında anladım
extension SearchViewController : UISearchResultsUpdating, SearchResultsViewControllerDelegate { // ikinci yazdığım sonlara doğru olan protocol
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
        
        resultsController.delegate = self // bunu en sonlara doğru protocol için yapıyoruzç
        
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let titlessearch):
                    resultsController.titleforsearchbar = titlessearch
                    resultsController.searchResulsCollectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
          
        }
        
    }
    func searchResultsViewControllerDelegate(_ viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
