//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 21.09.2022.
//

import UIKit

enum Sections : Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4   
}



class HomeViewController: UIViewController {
    
    private var randomTrendingMovies : Title?
    private var headerView : HeroHeaderUIView?

    
    let sectionTitles : [String] = ["Trending Movies","Trending TV", "Popular",  "Upcoming Movies", "Top Rated"]
    
    // tableview oluşturulması kod ile
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped) // gropued bir stil , onun dışunda plain ve insec.. diye bir şey dökümantasyon da yazıyor ne oldukları. grupued = scroll yapınca bilgiler kaymaz aşağı demek. ve ayrıca bunu yaparak tableview daki yukarıdan 40 düş olayını sağlamış oluyoruz. 
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier) // tableview içine özel hücre kaydetme
        return table
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable) // tableview
        
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        configureNavbar()
        configureHeroHeaderView()
        
        
        // Üst Görünümü eklentisi(Anasayfadaki ilk büyük reklamı yapılan video yeri.) // bunu views kısmında ayrı yapıyoz
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView 
        
        
    }
    
    
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case.success(let titles):
                let selectedTitle = titles.randomElement()
                self.randomTrendingMovies = selectedTitle
                self.headerView?.configurehhuview(with:TitleViewModel(titleName: selectedTitle?.original_name ?? "" , posterURL: selectedTitle?.poster_path ?? ""))
                
            case.failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    
    
  
    
    private func configureNavbar() { // Navbar kısmının ayarlanması
    
        var image = UIImage(named:"netflixlogo")
        image = image?.withRenderingMode(.alwaysOriginal) // bunu yapmayınca netflix fotosu orjinal durmuyor saçma sapan duruyor.
      navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil) // netflix logosu tam sola geçirtemedim araştırdım ama olmadı daha sonra tekrar bakacağım.
        
        navigationItem.rightBarButtonItems = [ UIBarButtonItem(image: UIImage(systemName:"person" ), style: .done, target: self, action: nil),
                                               UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds // feedtableın çevresi viewın sınırları olsun.
        
            }



}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // bir bölümde 1 tane olsun.
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for : indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()}
        
        cell.delegate = self
        
        switch indexPath.section  { // row değil bölüm.
        case Sections.TrendingMovies.rawValue :
            APICaller.shared.getTrendingMovies { resultsForTM in
                
                switch resultsForTM {
                case.success(let titlefortm): // titlefortm apicallerde yaptığımız işlemle tüm verileri almış oluyor, aşağıdaki configure işlemiyle beraber baslıkla eşitlemiş oluyoruz.
                    cell.configure(with: titlefortm) // Collection viewda yaptığımız fonksiyon, burdaki verdiğimiz title'ı arkadaki başlığa eşitliyor. YAAAANİİ BURDA TİTLEFORTM, baslik diye yazdığım şeyin yerine geçiyor.
                    
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue :
            APICaller.shared.getTrendingTvs{ resultsForTT in
                switch resultsForTT {
                case.success(let titlefortt):
                    cell.configure(with: titlefortt)
                case.failure(let error) :
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue :
            APICaller.shared.getPopular{ resultsForPop in
                switch resultsForPop {
                case.success(let titleforpop):
                    cell.configure(with: titleforpop)
                    case.failure(let error):
                    print(error.localizedDescription)
            
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpComingMovies { resultsForUc in
                switch resultsForUc {
                    case.success(let titleforupcoming):
                    cell.configure(with: titleforupcoming)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sections.TopRated.rawValue :
            APICaller.shared.getTopRated { resultsforTR in
                switch resultsforTR {
                case.success(let titlefortr):
                    cell.configure(with: titlefortr)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40  // burasını denedim pek değişen bir şey olmuyor.
        
        
    }
    
    // Her bir section için başlık seçme olayı
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section] // indexpath.row yapmıyoruz, yukarıda section: ınt yazdığı için section yazdık.
    }
    
    
    // Section başlıklarını ayarlamak için yaptık.
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        
        
    }
    
    
    
    
    // Bu özelliği yaparak, aşağı kaydırdığımızda sayfayı navigationbar da normalde bizimle birlikte geliyordu yani logolar butonlar duruyordu. Bunu yapınca durmuyor. Bence durması daha iyi ama neyse(yani ağır ezber fakat cok kullanılır)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
        
    }

}

//  CollectionViewa basınca yapacağımız şeyler.
extension HomeViewController : collectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in// protocol
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
