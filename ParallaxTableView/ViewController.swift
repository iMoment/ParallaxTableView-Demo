//
//  ViewController.swift
//  ParallaxTableView
//
//  Created by Stanley Pan on 23/11/2016.
//  Copyright © 2016 Stanley Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titles: [String] = [
        "Lake View",
        "Movie Night",
        "City Skyline",
        "Lunch Time",
        "Friday Party",
        "Weekend Festival",
        "Surprise Gift",
        "Hobby Workshop"
    ]
    
    var images: [UIImage] = [
        #imageLiteral(resourceName: "image1"),
        #imageLiteral(resourceName: "image2"),
        #imageLiteral(resourceName: "image3"),
        #imageLiteral(resourceName: "image4"),
        #imageLiteral(resourceName: "image5"),
        #imageLiteral(resourceName: "image6"),
        #imageLiteral(resourceName: "image7"),
        #imageLiteral(resourceName: "image8")
    ]
    
    var parallaxOffsetSpeed: CGFloat = 75
    var cellHeight: CGFloat = 250

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Use modified version of Quadratic Formula to scale the image's height
    var parallaxImageHeight: CGFloat {
        let maxOffset = sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * self.tableView.frame.height - cellHeight) / 2
        
        return maxOffset + cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell") as? ImageCell {
            
            cell.configureCell(title: titles[indexPath.row], image: images[indexPath.row])
            cell.parallaxImageHeight.constant = self.parallaxImageHeight
            cell.parallaxTopConstraint.constant = parallaxOffset(newOffsetY: tableView.contentOffset.y, cell: cell)
            
            return cell
            
        } else {
            return ImageCell()
        }
    }
    
    // Find top constraint as you are scrolling through
    func parallaxOffset(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return (newOffsetY - cell.frame.origin.y) / parallaxImageHeight * parallaxOffsetSpeed
    }

    // Update top constraint of image while the user is scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        for cell in tableView.visibleCells as! [ImageCell] {
            DispatchQueue.main.async {
                cell.parallaxTopConstraint.constant = self.parallaxOffset(newOffsetY: offsetY, cell: cell)
            }
        }
    }
}
