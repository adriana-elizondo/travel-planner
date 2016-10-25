//
//  HomeViewController.swift
//  TravelPlanner
//
//  Created by Adriana Elizondo on 10/23/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import UIKit
import WebImage

class HomeViewController : UIViewController{
    @IBOutlet weak var segmentedControl: TripSegmentedControl!{
        didSet{
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            dateLabel.text = formatter.string(from: Date())
        }
    }
    
    
    lazy var indicatorLayer : CALayer = {
        var layer = CALayer()
        let yPosition = self.segmentedControl.frame.height + self.segmentedControl.frame.origin.x
        let buttonWidth = self.segmentedControl.bounds.width / 3
        layer.frame = CGRect.init(x: (buttonWidth/2) - 20, y: yPosition - 3.0, width: 40.0, height: 3.0)
        layer.backgroundColor = UIColor.orange.cgColor
        return layer
    }()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var sortPriceButton: UIButton!
    @IBOutlet weak var sortDurationButton: UIButton!
    @IBOutlet weak var sortStopsButton: UIButton!
    
    var tripsAvailable : [Any]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataForIndex(index: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.layer.addSublayer(indicatorLayer)
    }
    
    //Button actions
    @IBAction func sortPrice(_ sender: AnyObject) {
        if let currentTrips = tripsAvailable{
            self.tripsAvailable = Parser.sortByPrice(trips: currentTrips)
            resetTitles()
            self.sortPriceButton.setTitle("Price  ↓", for: .normal)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sortDuration(_ sender: AnyObject) {
        if let currentTrips = tripsAvailable{
            self.tripsAvailable = Parser.sortByDuration(trips: currentTrips)
            resetTitles()
            self.sortDurationButton.setTitle("Duration  ↓", for: .normal)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func sortStops(_ sender: AnyObject) {
        if let currentTrips = tripsAvailable{
            self.tripsAvailable = Parser.sortByNumberOfStops(trips: currentTrips)
            resetTitles()
            self.sortStopsButton.setTitle("Stops  ↓", for: .normal)
            self.tableView.reloadData()
        }
    }
    
}

extension HomeViewController{
    //UI
    func resetTitles(){
        self.sortPriceButton.setTitle("Sort by Price", for: .normal)
        self.sortDurationButton.setTitle("Sort by Duration", for: .normal)
        self.sortStopsButton.setTitle("Sort by Stops", for: .normal)
    }
    
    func animateLayerWithIndex(index: Int){
        let buttonWidth = segmentedControl.bounds.width / 3
        let newXValue = (buttonWidth * CGFloat(index + 1)) - (buttonWidth / 2) - (indicatorLayer.bounds.width / 2)
        var frame = indicatorLayer.frame
        frame.origin.x = newXValue
        
        UIView.animate(withDuration: 0.5) {
            self.indicatorLayer.frame = frame
            
        }
    }
    
    func getDomainWithIndex(index: Int) -> String{
        switch index {
        case 0:
            return "w60i"
        case 1:
            return "3zmcy"
        case 2:
            return "37yzm"
        default:
            return ""
        }
    }
    
    //Network request
    func getDataForIndex(index: Int){
        resetTitles()
        RequestHelper.getDataWithDomain(domain: getDomainWithIndex(index: index)) { (success, response, error) in
            guard success == true else {return} // handle error here
            if let tripsArray = response as? [Any]?{
                Parser.parseJsonArray(jsonArray: tripsArray, completion: { (trips) in
                    self.tripsAvailable = trips
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
            
        }
    }
    
    func didChangeSegment(){
        tripsAvailable = nil
        tableView.reloadData()
        animateLayerWithIndex(index: segmentedControl.selectedSegmentIndex)
        getDataForIndex(index: segmentedControl.selectedSegmentIndex)
    }
}


extension HomeViewController : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count \(tripsAvailable?.count)")
        return tripsAvailable?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell") as? TripTableViewCell
        if let trip = tripsAvailable?[indexPath.row] as? Trip{
            cell?.price.text = Parser.priceWithTrip(trip: trip)
            cell?.departureArrival.text = Parser.timingwithTrip(trip: trip)
            cell?.stopsDuration.text = Parser.durationWithTrip(trip: trip)
            cell?.logo.sd_setImage(with: URL.init(string: trip.providerLogo!))
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
