//
//  DownloadViewController.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 21.09.2022.
//

import UIKit

class DownloadViewController: UIViewController {
    
    private var titles : [TitleItem] = [TitleItem]() // Normalde İntertten çektiğimiz Titledı, burada Coredataya kaydettiğimiz Titleİtem kullanıyoruz.
    
    private let downloadTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloaded"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemBackground
        view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
        
    }
    
    
    // DATA ÇEKME
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] resultsforfetchingdata in
            switch resultsforfetchingdata {
                
            case.success(let titlesfetch):
                self?.titles = titlesfetch
                self?.downloadTable.reloadData()
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
   

}

extension DownloadViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        
        let titleipr = titles[indexPath.row]
        
        cell.configure(with: TitleViewModel(titleName: (titleipr.original_title ?? titleipr.original_name) ?? "unkwon name title", posterURL: titleipr.poster_path ?? ""))
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    // TABLEVİEWDAN VE DATABASEDEN SİLME İŞLEMİ
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteDownloadedMovie(model: titles[indexPath.row]) { results in
                switch results {
                case.success():
                    print("Sildik databaseden")
                case.failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
            self.titles.remove(at: indexPath.row) // titlesdan kaldırdım
            tableView.deleteRows(at: [indexPath], with: .fade) // tableviewdan sildik
            
        default :
            break;
            
        }
    }
    
    // bastığımızda trailer açılması
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
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
