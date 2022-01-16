//
//  MainVC.swift
//  simple_pedometer
//
//  Created by Egemen on 5.12.2021.
//

import UIKit
import CoreMotion
import CoreData
import Charts

class MainVC: UIViewController, ChartViewDelegate{
    
    var barChart = BarChartView()
    
    //for store data
    let userDefaults = UserDefaults.standard
    
    
    @IBOutlet weak var activityValue: UILabel!
    @IBOutlet weak var stepValue: UILabel!
    
    private let activityManager = CMMotionActivityManager()
    //That manages access to the motion data stored by the device.

    private let pedometer = CMPedometer()
    //For fetching the system-generated live walking data.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self
        
        
        
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
        
        
        let currentStep = userDefaults.integer(forKey: "currentStep")
        
        if CMPedometer.isStepCountingAvailable(){
            self.pedometer.startUpdates(from: Date()){(data ,error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            self.stepValue.text = "\(currentStep + Int(response.numberOfSteps))"
                                self.userDefaults.set(Int(self.stepValue.text!), forKey: "currentStep")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Data Read Section
    override func viewWillAppear(_ animated: Bool){
        stepValue.text = String(userDefaults.integer(forKey: "currentStep"))
    }
    
    // MARK: Data Save Section
    //bir kaç kaydetme sıkıntısı daha ayrıca
    override func viewWillDisappear(_ animated: Bool) {
        //userDefaults.set(Int(stepValue.text!), forKey: "currentStep")
    }
    
    // MARK: Graphic
    // TODO: Gün değerleri 
    override func viewDidLayoutSubviews() {
        let width = view.frame.size.width
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: width, width: width, height: width * 0.60)
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        
        for x in 0..<8 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: set)
        barChart.data = data
        
    }


}
