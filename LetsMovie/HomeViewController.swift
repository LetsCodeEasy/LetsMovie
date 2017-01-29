//
//  ViewController.swift
//  LetsMovie
//
//  Created by Vishu on 18/12/16.
//  Copyright © 2016 LetsCodeEasy. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apiKey : String!
    let serviceUrl = "https://api.themoviedb.org/3"
    var baseUrl : String!
    var moviesResult = MovieResult()
    
    let movieCellIdentifier = "MovieCellIdentifier"
    
    @IBOutlet weak var tableViewMovieList: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let movieItemNib = UINib(nibName: "MovieItemViewCell", bundle: nil)
        
        self.tableViewMovieList.register(movieItemNib, forCellReuseIdentifier: movieCellIdentifier)
        
        guard let path = Bundle.main.path(forResource: "MovieConfig", ofType: "plist"), let movieConfigDict = NSDictionary.init(contentsOfFile: path) else {
            print("Path or Movie configuation dictionary does not exist!")
            return
        }
        
        apiKey = movieConfigDict.value(forKey: "ApiKey") as! String
        
        print("Api key: \(apiKey)")
        
        fetchConfigurations(onComplete: { (message) in
            print(message)
            
            self.fetchUpcomingMovies(onComplete: { (moviesJsonResult) in
                self.moviesResult.pageNum = moviesJsonResult.value(forKey: "page") as! Int
                self.moviesResult.totalPages = moviesJsonResult.value(forKey: "total_pages") as! Int
                self.moviesResult.totalResults = moviesJsonResult.value(forKey: "total_results") as! Int
                
                let moviesJsonArray = moviesJsonResult.value(forKey: "results") as! NSArray
                
                moviesJsonArray.forEach({ (movieJsonItem) in
                    
                    let movieJsonDict = movieJsonItem as! NSDictionary
                    
                    let movieItem = MovieItem()
                    
                    movieItem.movieTitle = movieJsonDict.value(forKey: "original_title") as! String
                    
                    movieItem.movieId = movieJsonDict.value(forKey: "id") as! Int
                    
                    movieItem.posterPath = movieJsonDict.value(forKey: "poster_path") as! String
                    
                    movieItem.releaseDate = movieJsonDict.value(forKey: "release_date") as! String
                    
                    self.moviesResult.moviesArray.append(movieItem)
                })
                
                print("\(self.moviesResult.pageNum)")
                
                self.tableViewMovieList.reloadData()
                
            }, onFailure: { (message) in
                print(message)
            })
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchConfigurations(onComplete: @escaping (_ message: String)->()) -> (Void) {
        let configurationsUrl = "\(serviceUrl)/configuration?api_key=\(apiKey!)"
        
        print(configurationsUrl)
        
        var request = URLRequest.init(url: URL.init(string: configurationsUrl)!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if(error != nil) {
                onComplete("Error: \(error)")
            } else {
                let configurationsJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                let imagesDict = configurationsJson.value(forKey: "images") as! NSDictionary
                
                self.baseUrl = imagesDict.value(forKey: "secure_base_url") as! String
                
                onComplete("Base url: \(self.baseUrl!)")
            }
        }).resume()
    }
    
    func fetchUpcomingMovies(onComplete: @escaping (_ moviesResult: NSDictionary)->(), onFailure: @escaping (_ message: String)->()) -> (Void) {
        let moviesUrl = "\(serviceUrl)/movie/upcoming?api_key=\(apiKey!)&language=en-US&page=1"
        
        print(moviesUrl)
        
        var request = URLRequest.init(url: URL.init(string: moviesUrl)!)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if(error != nil) {
                onFailure("Error: \(error)")
            } else {
                let moviesResultJson = try! JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                onComplete(moviesResultJson)
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieItemViewCell
        
        let movieItem = moviesResult.moviesArray[indexPath.row]
        
        cell.lblMovieTitle.text = movieItem.movieTitle
        
        cell.lblReleaseDate.text = "Release Date: \(movieItem.releaseDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesResult.moviesArray.count
    }
}

