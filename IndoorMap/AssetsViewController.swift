//
//  AssetsViewController.swift
//  IndoorMap
//
//  Created by Alok Ranjan on 9/26/17.
//  Copyright © 2017 Estimote, Inc. All rights reserved.
//

import UIKit

class AssetsViewController: UIViewController, CLLocationManagerDelegate {

    let clLocationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString:"00000000-0000-0000-0000-000000001111")! as UUID, identifier:"estimote")

    @IBOutlet var assetTableView: UITableView!
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("beacons detected")
        if(beacons.count>0){
            let sortedBeacons = beacons.sorted { $0.rssi > $1.rssi }
            assetTableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clLocationManager.startRangingBeacons(in: region)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
