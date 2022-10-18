//
//  APICaller.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 26.09.2022.
//

import Foundation

//Burayı yaptıktan sonra Home gidip apicaller ile cağırcaz.

struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseUrl = "https://api.themoviedb.org"
    static let YoutubeAPI_Key = "AIzaSyBQgbMvoYGSgtCBDqwxOy_Sp_DfHHN9CKI"
    static let YoutubeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError : Error { // bunu neden yaptık anlamadım.
    case failedToGetData
}



class APICaller {
    
    static let shared = APICaller()
    
    
    // (Result< [Movie], Error>) Kısımı Generic Enumarationdur. Succes ve Failure verir. Succesimiz movie, failuremiz de error dedik. Ve bunu decode sonrası completion olarak kullanacağız.
    func getTrendingMovies(completion: @escaping (Result< [Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in // completion error olunca başka yerlerde de kullanbiliyoruz.
            
            guard let data = data, error == nil else {return}
            
            do {
                let sonuclar = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(sonuclar.results))
                // sonuçlar benim verdiğim isim, results da api da (modeldeTrendingmoviresponsedaki yani) olan isim.
                
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        
        }
        
        task.resume()
        
}
    
    
    
    func getTrendingTvs(completion: @escaping (Result< [Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in // completion error olunca başka yerlerde de kullanbiliyoruz.
            
            guard let data = data, error == nil else {return}
            
            do { // sonuclar tv değil hepsini sonuclar versemde olur ama anlayayım diye :)
                let sonuclartv = try  JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(sonuclartv.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
        
        }
        
        task.resume()
        
    }
    
    
    
    
    
    func getUpComingMovies(completion : @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        
            guard let data = data , error == nil else {return}
            do {
                let sonuclarupcomingmovie = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                
                completion(.success(sonuclarupcomingmovie.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
            
        }
        
        task.resume()
    }
    
    func getPopular (completion : @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        
            guard let data = data , error == nil else {return}
            do {
                let sonuclarupcomingmovie = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                
                completion(.success(sonuclarupcomingmovie.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
            
        }
        
        task.resume()
    }
    
    
    
    func getTopRated (completion : @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        
            guard let data = data , error == nil else {return}
            do {
                let sonuclarupcomingmovie = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                
                completion(.success(sonuclarupcomingmovie.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
            
        }
        
        task.resume()
    }
    
    
    // Discoverdatayı searchview control için yapıyoruz.
    
    func getDiscoverMovies (completion : @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        
            guard let data = data , error == nil else {return}
            do {
                let sonuclarupcomingmovie = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                
                completion(.success(sonuclarupcomingmovie.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
            
        }
        
        task.resume()
        
        
    }
    
    // SEARCH KISIMI ()
    
    //  Search kısımı için yaptık, gene fotoğraf verileri alıyoruz, searchviewde devam edicez
    
    func search(with query : String, completion : @escaping (Result<[Title], Error>) -> Void) {
        
        // bu kısımı anlamadım.
        guard let queryke = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.baseUrl)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(queryke)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        
            guard let data = data , error == nil else {return}
            do {
                let sonuclar = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                
                completion(.success(sonuclar.results))
                
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
            
            
        }
        
        task.resume()
        
        
    
    }
    // youtubeapi
    // query(sorgu) indexpathe göre query vercez oda queryke cevirecek daha sonra, url kısmınA querykeyi yazıyourz.
    // videoelement de array yok çünkü sadece id.
    func getMovie(with query : String, completion : @escaping (Result<VideoElement, Error>) -> Void) {
        
        guard let queryke = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "\(Constants.YoutubeBaseUrl)q=\(queryke)&key=\(Constants.YoutubeAPI_Key)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
        
            guard let data = data , error == nil else {return}
            do {
                let sonuclar = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)

                completion(.success(sonuclar.items[0]))
                
    
            }catch{
                completion(.failure(APIError.failedToGetData))
            }
    
        }
        task.resume()
        
    }
    
    
    
    
    
    
}



