//
//  HomePageViewController.swift
//  DeltaAsignment
//
//  Created by A1P5KF3Z on 3/26/18.
//  Copyright © 2018 raj. All rights reserved.
//

import Foundation
import UIKit
class HomePageViewController:UIViewController{

    
    @IBAction func btnHorizontalViewClicked(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "carouselTest")
        self.navigationController?.pushViewController(vc, animated: true)
        
//        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnVerticalViewClicked(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "vertical")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
