//
//  MainVC.swift
//  simple_pedometer
//
//  Created by Egemen on 5.12.2021.
//

import UIKit
import CoreMotion

class MainVC: UIViewController {
    
    @IBOutlet weak var activityValue: UILabel!
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        activityValue.self.text = "Hello World"
        if CMMotionActivityManager.isActivityAvailable(){
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
