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
import Charts

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext


class MainVC: UIViewController, ChartViewDelegate{
    
    var barChart = BarChartView()
    var pieChart = PieChartView()
    
    let stepData = Step(context: context)
    
    @IBOutlet weak var activityValue: UILabel!
    @IBOutlet weak var stepValue: UILabel!
    
    private let activityManager = CMMotionActivityManager()
    //That manages access to the motion data stored by the device.

    private let pedometer = CMPedometer()
    //For fetching the system-generated live walking data.
    //let testWalking = CMMotionActivity()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.delegate = self
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
                            //self.stepData.current_step = self.stepValue.text
                            //appDelegate.saveContext()
                        }
                    }
                }
            }
        }
    }
    var stepValues = [Step]()
    
    override func viewWillAppear(_ animated: Bool){
        
        do {
            stepValues = try context.fetch(Step.fetchRequest())
        } catch  {
            print("")
        }
        print(stepValues)
        
        if stepData.current_step == nil {
                stepValue.text = "None"
            }else{
                stepValue.text = stepData.current_step
                }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        stepData.current_step = "15"
        appDelegate.saveContext()
    }
    
    // MARK: Graphic
    override func viewDidLayoutSubviews() {
        let width = view.frame.size.width
        //let height = view.frame.size.height
        super.viewDidLayoutSubviews()
        /*barChart.frame = CGRect(x: 0, y: width, width: width, height: width)
        //barChart.center = view.center
        view.addSubview(barChart)
        
        var entries = [BarChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: set)
        barChart.data = data*/
        
        
        
        pieChart.frame = CGRect(x: 0, y: width, width: width, height: width * 0.75)
        
        view.addSubview(pieChart)
        
        var entries = [BarChartDataEntry]()
        for x in 0..<7 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double(x)))
        }
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        
    }


}
