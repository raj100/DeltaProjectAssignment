//
//  HorizontalViewController.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/26/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
import UIKit
class HorizontalViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    var userDetailsArray:NSMutableArray = NSMutableArray.init()
    let dataController = DataController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
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
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userDetailsArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! UserDetailCollectionViewCell
        
        let userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath.row) as! UserDetailsModal
        cell.lblName.text = userDetailsModal.name
        cell.lblEmail.text = userDetailsModal.email
        cell.lblCreatedOn.text = "Created On " + userDetailsModal.createdAt
        cell.lblUpdatedOn.text = "Updated On " + userDetailsModal.updatedAt
        if userDetailsModal.image == nil {
            cell.imgDisplayImage.image = nil
            cell.lblId.text = "id "
            downloadCellImage(indexPath: indexPath)
        }else{
            cell.lblId.text = "id \(userDetailsModal.id)"
            cell.imgDisplayImage.image = userDetailsModal.image
        }
        return cell
    }
    
    func downloadCellImage(indexPath:IndexPath){
        var userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath.row) as! UserDetailsModal
        dataController.downloadImage(url: userDetailsModal.imageUrl,indexPath:indexPath, imageDataCallbackHandler: { (image,downloadIndexPath) in
            if (self.collectionView.indexPathsForVisibleItems.contains(indexPath)){
                userDetailsModal.image = image
                self.userDetailsArray.replaceObject(at: indexPath.row, with: userDetailsModal)
                let cell = self.collectionView.cellForItem(at: indexPath) as! UserDetailCollectionViewCell
                cell.imgDisplayImage.image = image
                cell.lblId.text = "id \(userDetailsModal.id)"
            }
        })
    }
}
