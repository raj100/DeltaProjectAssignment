//
//  ViewController.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/20/18.
//  Copyright © 2018 raj. All rights reserved.
//

import UIKit

class VerticalViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tblUserDetails: UITableView!
    var userDetailsArray:NSMutableArray = NSMutableArray.init()
    let dataController = DataController.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Reachability.isConnectedToNetwork()){
            self.navigationItem.title = "Vertical List"
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
                self.tblUserDetails.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        let count = userDetailsArray.count
        //        guard count != 0 else{
        //            return 4
        //        }
        return userDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdent", for: indexPath) as! UserDetailTableViewCell
        
        let userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath.row) as! UserDetailsModal
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
        var userDetailsModal:UserDetailsModal = userDetailsArray.object(at: indexPath.row) as! UserDetailsModal
        dataController.downloadImage(url: userDetailsModal.imageUrl,indexPath:indexPath.item, imageDataCallbackHandler: { (image,downloadIndexPath) in
            userDetailsModal.image = image
            self.userDetailsArray.replaceObject(at: indexPath.row, with: userDetailsModal)
            if (self.tblUserDetails .indexPathsForVisibleRows?.contains(indexPath))!{
                let cell = self.tblUserDetails.cellForRow(at: indexPath) as! UserDetailTableViewCell
                cell.imgDisplayImage.image = image
            }
        })
    }
}

