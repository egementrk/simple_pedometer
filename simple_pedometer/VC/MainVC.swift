//
//  MainVC.swift
//  simple_pedometer
//
//  Created by Egemen on 5.12.2021.
//

import UIKit
import CoreMotion
//Core Motion reports motion- and environment-related data
//from the onboard hardware of iOS devices

class MainVC: UIViewController {
    
    @IBOutlet weak var activityValue: UILabel!
    
    private let activityManager = CMMotionActivityManager()
    //That manages access to the motion data stored by the device.

    private let pedometer = CMPedometer()
    //For fetching the system-generated live walking data.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        activityValue.self.text = "Welcome!"
        
        if CMMotionActivityManager.isActivityAvailable(){
            //if detect any activity
            self.activityManager.startActivityUpdates(to: OperationQueue.main){
                (data) in DispatchQueue.main.async {
                    if let activity = data {
                        if activity.walking == true {
                            print("Walking")
                            self.activityValue?.text = "Walking"
                        }else if activity.running == true{
                            print("Running")
                            self.activityValue?.text = "Running"
                        }
                    }
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    */

}
