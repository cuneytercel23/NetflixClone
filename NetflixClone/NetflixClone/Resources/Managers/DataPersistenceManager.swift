//
//  DataPersistenceManager.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 15.10.2022.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DataBaseError : Error {
         case failedToSave
        case failedToFetch
        case failedtoDeleteData
    }
    
    
    
    static let shared = DataPersistenceManager()
        
    func downloadTitleWith (model : Title, completion: @escaping (Result<Void, Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        //depo yeri
        
        let item = TitleItem(context: context) // hey contextmanager titleitem yarattım, lütfen depoladığın verileri, item diye kurduğum değişkene not et diyoruz.
        
        // Coredata ile TitleModelimizi birleştiriyoruz. // Save Kısımı
        item.original_title = model.original_title // model yukarıda title diye verdiğimiz yer
        item.original_name = model.original_name
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(())) // void istiyor diye boş parantez bıraktık
                
        }catch{
            completion(.failure(DataBaseError.failedToSave))
        }
    }
     // Kaydedilen Verilerin Çekme Kısımı
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest() // fetchrequest otofonk
        
        do {
           let titles = try context.fetch(request) //  yukarıda Request diye oluşturduğum title itemden alınan veriler titles a aktarılır.
            completion(.success(titles))
            
        }catch{
            completion(.failure(DataBaseError.failedToFetch))
        }
        
    }
    
    
    
    func deleteDownloadedMovie (model : TitleItem, completion : @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // databaseye objeyi silmesini istiyoruz.
        
        do {
            try context.save() // burda da yeniliyoruz.
            completion(.success(()))
            
        }catch{
            completion(.failure(DataBaseError.failedtoDeleteData))
        }
        
    }
    
}
