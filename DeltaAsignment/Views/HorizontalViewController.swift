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
        print("cell Item\(indexPath.item) Row\(indexPath.row)")
        let userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath.item) as! UserDetailsModal
        cell.lblName.text = userDetailsModal.name
        cell.lblEmail.text = userDetailsModal.email
        cell.lblCreatedOn.text = "Created On " + userDetailsModal.createdAt
        cell.lblUpdatedOn.text = "Updated On " + userDetailsModal.updatedAt
        cell.lblId.text = "id \(userDetailsModal.id)"
        if userDetailsModal.image == nil {
            cell.imgDisplayImage.image = nil
            downloadCellImage(indexPath: indexPath)
        }else{
            cell.imgDisplayImage.image = userDetailsModal.image
        }
        return cell
    }
    
    func downloadCellImage(indexPath:IndexPath){
        var userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath.item) as! UserDetailsModal
        dataController.downloadImage(url: userDetailsModal.imageUrl,indexPath:indexPath, imageDataCallbackHandler: { (image,downloadIndexPath) in
            userDetailsModal.image = image
            print("on Downloaded Item\(indexPath.item) Row\(indexPath.row)")
            self.userDetailsArray.replaceObject(at: indexPath.item, with: userDetailsModal)
            if (self.collectionView.indexPathsForVisibleItems.contains(indexPath)){
                let cell = self.collectionView.cellForItem(at: indexPath) as! UserDetailCollectionViewCell
                cell.imgDisplayImage.image = image
            }
        })
    }
}
