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
    
    var days: [String: String] = ["1":"0","2":"0","3":"0","4":"0","5":"0","6":"0","7":"0"]
    let date = Date()
    
    @IBOutlet weak var activityValue: UILabel!
    @IBOutlet weak var stepValue: UILabel!
    
    private let activityManager = CMMotionActivityManager()
    //That manages access to the motion data stored by the device.

    private let pedometer = CMPedometer()
    //For fetching the system-generated live walking data.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChart.delegate = self

        //the first day first seconds of the week app will be reset
        if date.get(.weekday) == 0 && date.get(.hour) == 0 && date.get(.second) == 0{
            for x in 1..<8 {
                days["\(x)"]! = "0"
            }
        }
        
        if CMMotionActivityManager.isActivityAvailable(){
            //if detect any activity
            self.activityManager.startActivityUpdates(to: OperationQueue.main){
                (data) in DispatchQueue.main.async {
                    if let activity = data {
                        if activity.walking == true {
                            self.activityValue?.text = "Walking"
                        }else if activity.running == true{
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
                            
                            // MARK: Data Save Section
                            self.userDefaults.set(Int(self.stepValue.text!), forKey: "currentStep")
                            // weekday starts at sunday it means if .weekday value equal 1 then day is sunday
                            self.days[String(self.date.get(.weekday) != 1 ? self.date.get(.weekday) - 1 : 1)] = String(self.stepValue.text!)
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
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // MARK: Graphic
    override func viewDidLayoutSubviews() {
        let width = view.frame.size.width
        super.viewDidLayoutSubviews()
        barChart.frame = CGRect(x: 0, y: width, width: width, height: width * 0.60)
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        
        for x in 1..<8 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(days["\(x)"]!) ?? 0 ))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        set.valueTextColor = .white
        let data = BarChartData(dataSet: set)
        barChart.data = data
        
    }


}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
