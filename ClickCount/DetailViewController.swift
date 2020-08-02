//
//  DetailViewController.swift
//  Project1
//
//  Created by Damnjan Markovic on 23/07/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var numberOfImages: Int?
    var imagePosition: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imagePos = imagePosition, let numOfImages = numberOfImages {
            title = "Picture \(imagePos) of \(numOfImages)"
        }
        navigationItem.largeTitleDisplayMode = .never
        
                
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }


}
