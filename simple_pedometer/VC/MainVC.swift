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
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext


class MainVC: UIViewController {
    
    let stepData = Step(context: context)
    var step = [Step]()
    
    @IBOutlet weak var activityValue: UILabel!
    @IBOutlet weak var stepValue: UILabel!
    
    private let activityManager = CMMotionActivityManager()
    //That manages access to the motion data stored by the device.

    private let pedometer = CMPedometer()
    //For fetching the system-generated live walking data.
    //let testWalking = CMMotionActivity()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //stepData.current_step = "15"
        
        // Do any additional setup after loading the view.
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
        
        
        if CMPedometer.isStepCountingAvailable(){
            self.pedometer.startUpdates(from: Date()){(data ,error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            self.stepValue.text = "\(response.numberOfSteps)"
                            self.stepData.current_step = self.stepValue.text
                            //appDelegate.saveContext()
                        }
                    }
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool){
            if stepData.current_step == nil {
                stepValue.text = "None"
            }else{
                stepValue.text = stepData.current_step!
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stepData.current_step = "15"
        do {
            print("Başarılı")
            try context.save()
        } catch  {
            print("error")
        }
    }



}
