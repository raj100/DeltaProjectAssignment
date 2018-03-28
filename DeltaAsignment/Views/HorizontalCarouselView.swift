//
//  HorizontalCarouselView.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/28/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
class HorizontalCarouselView:UIViewController,iCarouselDelegate,iCarouselDataSource{
    
    var userDetailsArray:NSMutableArray = NSMutableArray.init()
    let dataController = DataController.init()
    
    override func viewDidLoad() {
        if(Reachability.isConnectedToNetwork()){
            self.navigationItem.title = "Horizontal List"
        }else{
            self.navigationItem.title = "Offline Mode"
        }
        // Do any additional setup after loading the view, typically from a nib.
        let activityIndicatorView =  UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicatorView.color = UIColor.black
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        self.view.addSubview(activityIndicatorView)
        
        dataController.makeRequest { (status, userDetails) in
            activityIndicatorView.stopAnimating()
            if status {
                self.userDetailsArray = userDetails!
//                self.collectionView.reloadData()
            }
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
//        let cell = CarouselViewContainer.init(frame: self.view.frame)
//
//        let userDetailsModal:UserDetailsModal = userDetailsArray.object(at: index) as! UserDetailsModal
//        cell.lblName.text = userDetailsModal.name
//        cell.lblEmail.text = userDetailsModal.email
//        cell.lblCreatedOn.text = "Created On " + userDetailsModal.createdAt
//        cell.lblUpdatedOn.text = "Updated On " + userDetailsModal.updatedAt
//        cell.lblId.text = "id \(userDetailsModal.id)"
//        if userDetailsModal.image == nil {
//            cell.imgDisplayImage.image = nil
//            downloadCellImage(indexPath: index)
//        }else{
//            cell.imgDisplayImage.image = userDetailsModal.image
//        }
        
        let tempView = UIView.init(frame: CGRect.init(x: 10, y: 10, width: 100, height: 100))
        let imageView = UIImageView.init(frame: CGRect.init(x: 20, y: 20, width: 50, height: 50))
        tempView.addSubview(imageView)
        
        dataController.downloadImage(url: "https://lorempixel.com/600/1000/?98453",indexPath:index, imageDataCallbackHandler: { (image,downloadIndexPath) in
            imageView.image = image
        })
            
        
        return tempView
    }
    
    
    
    func downloadCellImage(indexPath:Int){
        var userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath) as! UserDetailsModal
        dataController.downloadImage(url: userDetailsModal.imageUrl,indexPath:indexPath, imageDataCallbackHandler: { (image,downloadIndexPath) in
            userDetailsModal.image = image
            print("on Downloaded Item\(indexPath) Row\(indexPath)")
            self.userDetailsArray.replaceObject(at: indexPath, with: userDetailsModal)
            
//            if (self.collectionView.indexPathsForVisibleItems.contains(indexPath)){
//                let cell = self.collectionView.cellForItem(at: indexPath) as! UserDetailCollectionViewCell
//                cell.imgDisplayImage.image = image
//            }
        })
    }
    
    
}
