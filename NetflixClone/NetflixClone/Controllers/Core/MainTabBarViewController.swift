//
//  ViewController.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 21.09.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemYellow
        
        // Diğer ViewControllerı Tabbara tanıma - setViewController ile tamamlamış olacağız.
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpComingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vc1.title = "Home"
        vc2.title = "Coming"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
        
        tabBar.tintColor = .label // bunu darkmodda renklerin anlaşması için yapıyoruz.
        
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true) // bununla controllerları tabbara setledik. yani bunu yaparak addledik gibi bişimsel.
        
        
        
        
        
        
        
        
    }


}

