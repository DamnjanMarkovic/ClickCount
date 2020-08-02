//
//  ViewController.swift
//  Project1
//
//  Created by Damnjan Markovic on 22/07/2020.
//  Copyright © 2020 Damnjan Markovic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var numberOfClicks: Int!
    var pictures = [String]()
    var clickedMap: [String: Int] = [:]
    var clickedTimes: Int = 0
    var clickedImage: String = ""
    var clickedImages: [String] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        clickedTimes = defaults.integer(forKey: "clickedTimes")
        clickedImages = defaults.object(forKey: "clickedImages") as? [String] ?? [String]()
        clickedMap = defaults.object(forKey: "clickedMap") as? [String: Int] ?? [String: Int]()

        
        
        title = "Storm viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.importImages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("VIew will appear, Do sada kliknuto: \(clickedTimes) puta")
        print("Do sada kliknute slike: \(clickedImages)")
        print("Do sada kliknute slike u mapi: \(clickedMap)")
    }
    
    @objc func importImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nss") {
                pictures.append(item)
            }
        }
        pictures.sort()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }

    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        let picture = pictures[indexPath.row]
        let pict = picture.split(separator: ".")
        
        let brojkliktanja = clickedMap[pictures[indexPath.row]] ?? 0
        print("Broj kliktanja: \(brojkliktanja)")
        
        
        cell.textLabel?.text = "\(pict[0].capitalized) kliknuta je \(brojkliktanja) puta"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.numberOfImages = pictures.count
            vc.imagePosition = indexPath.row + 1
            clickedTimes += 1
            clickedImage = pictures[indexPath.row]
            clickedImages.append(clickedImage)
            
            if clickedMap.keys.contains(clickedImage) {
                clickedMap[clickedImage]! += 1
            } else {
                clickedMap[clickedImage] = 1
            }
            tableView.reloadData()

            save()
            
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        if let savedData = try? jsonEncoder.encode(clickedMap) {
            defaults.set(savedData, forKey: "selectedImages")
        
        } else if let savedClickedImages = try? jsonEncoder.encode(clickedImages) {
            defaults.set(savedClickedImages, forKey: "clickedImages")
        
        } else if let savedClickedTimes = try? jsonEncoder.encode(clickedTimes) {
            defaults.set(savedClickedTimes, forKey: "clickedTimes")
        
        } else if let savedClickedMap = try? jsonEncoder.encode(clickedMap) {
            defaults.set(savedClickedMap, forKey: "clickedMap")
        
        } else {
            print("Failed to save selected images")
        }
    }


}

