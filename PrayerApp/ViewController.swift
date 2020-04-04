//
//  ViewController.swift
//  PrayerApp
//
//  Created by mac on 4/4/20.
//  Copyright © 2020 mac. All rights reserved.
//

extension Date {
    func compareTimeOnly(to: Date) -> Int {
        let calendar = Calendar.current
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
        let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!

        let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
        return seconds
    }
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var prayerTableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var remainingTimeLbl: UILabel!
    @IBOutlet weak var upcomingPrayerLbl: UILabel!
    
    private var prayerNames = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"]
    private var prayerData = NSDictionary()
    
    private var showHijri = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDates()
        getPrayerDataFromAPI()
    }
    
    // MARK:- Namaz time
    func setupRemaininTime(){

        let (namazName, timeRemaining) = getTimeBetweenPrayers()
        
        upcomingPrayerLbl.text = namazName
        
        if timeRemaining < 0{ // after isha and before new date
            remainingTimeLbl.text = "--"
        }else{
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
                let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: timeRemaining)
                self.remainingTimeLbl.text = "\(h):\(m):\(s)"
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getTimeBetweenPrayers() -> (namaz: String, timeInSec: Int){
        
        let timingsDict = prayerData["timings"] as! NSDictionary
        
        let fajar = timingsDict["Fajr"] as! String
        let sunrise = timingsDict["Sunrise"] as! String
        let dhuhr = timingsDict["Dhuhr"] as! String
        let asr = timingsDict["Asr"] as! String
        let maghrib = timingsDict["Maghrib"] as! String
        let isha = timingsDict["Isha"] as! String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let newFajrDate = formatter.date(from: fajar)
        let newSunriseDate = formatter.date(from: sunrise)
        let newDhuhrDate = formatter.date(from: dhuhr)
        let newAsrDate = formatter.date(from: asr)
        let newMaghribDate = formatter.date(from: maghrib)
        let newIshaDate = formatter.date(from: isha)
       
        let currentDate = Date()
        
        let fajarTime = currentDate.compareTimeOnly(to: newFajrDate!)
        if fajarTime >= 0{
            let cell = self.prayerTableView.visibleCells[0] as! PrayerCell
            cell.backgroundColor = .green
            return (prayerNames[0],fajarTime)
        }
        
        let sunriseTime = currentDate.compareTimeOnly(to: newSunriseDate!)
        if sunriseTime >= 0{
            let cell = self.prayerTableView.visibleCells[1] as! PrayerCell
            cell.backgroundColor = .green
            return (prayerNames[1],sunriseTime)
        }
        
        let dhuhrTime = currentDate.compareTimeOnly(to: newDhuhrDate!)
        if dhuhrTime >= 0{
            let cell = self.prayerTableView.visibleCells[2] as! PrayerCell
            cell.backgroundColor = .green
            return (prayerNames[2],dhuhrTime)
        }
        
        let asrTime = currentDate.compareTimeOnly(to: newAsrDate!)
        if asrTime >= 0{
            let cell = self.prayerTableView.visibleCells[3] as! PrayerCell
            cell.backgroundColor = .green
            return (prayerNames[3],asrTime)
        }
        
        let maghribTime = currentDate.compareTimeOnly(to: newMaghribDate!)
        if maghribTime >= 0{
            let cell = self.prayerTableView.visibleCells[4] as! PrayerCell
            cell.backgroundColor = .green
            return (prayerNames[4],maghribTime)
        }
        
        let ishaTime = currentDate.compareTimeOnly(to: newIshaDate!)
        if ishaTime >= 0{
            let cell = self.prayerTableView.visibleCells[5] as! PrayerCell
            cell.backgroundColor = .green
            return (prayerNames[5],ishaTime)
        }
        
        let cell = self.prayerTableView.visibleCells[5] as! PrayerCell
        cell.backgroundColor = .green
        /// isha to new date
        /// i.e isha 19:30, then from 19:31 to 23:59
        return (prayerNames[0], -1)
    }
    
    // MARK:- Dates
    func setupDates(){
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (_) in
            self.showHijri = !self.showHijri
            UIView.animate(withDuration: 1.0) {
                if self.showHijri{
                    self.dateLbl.text = self.getHijriDate()
                }else{
                    self.dateLbl.text = self.getCurrentDate()
                }
            }
        }
    }
    
    func getCurrentDate() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d\nMMMM\nYYYY"
        let strDate = formatter.string(from: currentDate)
        return strDate
    }
    
    func getHijriDate() -> String{
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "d\nMMMM\nYYYY"
        formatter.calendar = Calendar(identifier: .islamic)
        let strDate = formatter.string(from: currentDate)
        return strDate
    }
    
    //MARK:- API

    func getPrayerDataFromAPI(){
        let headers = [
            "x-rapidapi-host": "aladhan.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]

        let urlStr = "https://aladhan.p.rapidapi.com/timingsByCity?"
        let params = ["city": "wah",
                      "country":"pakistan"]
        
        AppUtils.sharedUtils.getRestAPIResponse(urlString: urlStr, headers: headers as NSDictionary, parameters: params as NSDictionary, method: .get) { (data) in
            if (data["code"] as! Int64) == 200{
                print(data)
                self.prayerData = data["data"] as! NSDictionary
                self.setupRemaininTime()
                self.prayerTableView.reloadData()
            }
        }
    }
    
}

// MARK:- UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if prayerData.count>0{
            return 6
        }
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = prayerTableView.dequeueReusableCell(withIdentifier: "PrayerCell") as! PrayerCell
        
        cell.nameLbl.text = prayerNames[indexPath.row]
        
        let timings = prayerData["timings"] as? NSDictionary ?? NSDictionary()
        if indexPath.row == 0{
            cell.timeLbl.text = timings["Fajr"] as? String
        }else if indexPath.row == 1{
            cell.timeLbl.text = timings["Sunrise"] as? String
        }else if indexPath.row == 2{
            cell.timeLbl.text = timings["Dhuhr"] as? String
        }else if indexPath.row == 3{
            cell.timeLbl.text = timings["Asr"] as? String
        }else if indexPath.row == 4{
            cell.timeLbl.text = timings["Maghrib"] as? String
        }else if indexPath.row == 5{
            cell.timeLbl.text = timings["Isha"] as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let dateLbl = UILabel(frame: headerView.frame)
        dateLbl.textAlignment = .center
        dateLbl.text = "Selected City"
        headerView.addSubview(dateLbl)

        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

