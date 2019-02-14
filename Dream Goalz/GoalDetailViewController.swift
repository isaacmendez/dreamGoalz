//
//  GoalDetailViewController.swift
//  Dream Goalz
//
//  Created by Laurie Gray on 13/02/2019.
//  Copyright © 2019 Code Disciple. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController {
    
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var bgImageView: UIImageView!
    
    // Optional Quote
    var quote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Safely unwraps the quote
        if let ourQuote = quote {
            quoteLabel.text = ourQuote.quote
            authorLabel.text = ourQuote.author
            getImage(from: ourQuote.imageURL)
        }
    }
    
    func getImage(from url: String) {
        
        let imageURL = URL(string: url)!
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: imageURL) { [weak self] (data, _, _) in
            
            if let imageData = data {
                // Go onto main thread
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self?.bgImageView.alpha = 0
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        self?.bgImageView.image = image
                        self?.bgImageView.alpha = 0.4
                    })
                    
                    
                }
                
            }
        }
        
        dataTask.resume()
    }
}
