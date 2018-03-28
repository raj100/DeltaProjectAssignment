//
//  CarouselTestController.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/28/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
class CarouselTestController:UIViewController,iCarouselDataSource,iCarouselDelegate{
    
    let dataController = DataController.init()
    var userDetailsArray:NSMutableArray = NSMutableArray.init()
    @IBOutlet var carouselVew: iCarousel!
    
    override func viewDidLoad() {
        carouselVew.type = iCarouselType.coverFlow
        if(Reachability.isConnectedToNetwork()){
            self.navigationItem.title = "Horizontal List"
        }else{
            self.navigationItem.title = "Offline Mode"
        }
        
        let activityIndicatorView =  UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicatorView.color = UIColor.black
        activityIndicatorView.center = self.view.center
        activityIndicatorView.startAnimating()
        self.view.addSubview(activityIndicatorView)
        
        dataController.makeRequest { (status, userDetails) in
            activityIndicatorView.stopAnimating()
            if status {
                self.userDetailsArray = userDetails!
                self.carouselVew.reloadData()
            }
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return userDetailsArray.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let cell = Bundle.main.loadNibNamed("CarouselViewContainer", owner: self, options: nil)?.first as! CarouselViewContainer
        
        let userDetailsModal:UserDetailsModal = userDetailsArray.object(at: index) as! UserDetailsModal
        cell.lblName.text = userDetailsModal.name
        cell.lblEmail.text = userDetailsModal.email
        cell.lblCreatedOn.text = "Created On " + userDetailsModal.createdAt
        cell.lblUpdatedOn.text = "Updated On " + userDetailsModal.updatedAt
        cell.lblId.text = "id \(userDetailsModal.id)"
        if userDetailsModal.image == nil {
            cell.imgDisplayImage.image = nil
            downloadCellImage(indexPath: index)
        }else{
            cell.imgDisplayImage.image = userDetailsModal.image
        }
        
        return cell
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing{
            return value * 1.2
        }
        return value
    }
    
    func downloadCellImage(indexPath:Int){
        var userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath) as! UserDetailsModal
        dataController.downloadImage(url: userDetailsModal.imageUrl,indexPath:indexPath, imageDataCallbackHandler: { (image,downloadIndexPath) in
            userDetailsModal.image = image
            self.userDetailsArray.replaceObject(at: indexPath, with: userDetailsModal)
            print(self.carouselVew.indexesForVisibleItems)
            let isContained = self.carouselVew.indexesForVisibleItems.contains(where: { element -> Bool in
                return ((element as? Int) == indexPath)
            })
            print("iscontained \(isContained) for index\(indexPath)")
            if isContained {
                let cell = self.carouselVew.itemView(at: indexPath) as! CarouselViewContainer
                cell.imgDisplayImage.image = image
            }
        })
    }
    
}
