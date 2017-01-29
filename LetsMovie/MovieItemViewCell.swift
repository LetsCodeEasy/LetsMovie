//
//  MovieItemViewCell.swift
//  LetsMovie
//
//  Created by Vishu on 25/12/16.
//  Copyright © 2016 LetsCodeEasy. All rights reserved.
//

import UIKit

class MovieItemViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewMoviePoster: UIImageView!
    @IBOutlet weak var lblMovieTitle: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addToFavorites(_ sender: Any) {
        
    }
}
