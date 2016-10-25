//
//  Parser.swift
//  TravelPlanner
//
//  Created by Adriana Elizondo on 10/23/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import ObjectMapper

class Parser{
    static func parseJsonArray(jsonArray: [Any]?, completion:@escaping ([Any]?) -> Void){
        guard jsonArray != nil else {return}
        
        var trips = [Trip]()
        for trip in jsonArray!{
            if let current = trip as? [String : Any],
                let currentTrip = Trip(JSON: current) {
                trips.append(currentTrip)
            }
        }
        
        completion(trips)
    }
    
    static func timingwithTrip(trip: Trip) -> String{
        if let departure = trip.departure,
            let arrival = trip.arrival{
            return departure  + " - " + arrival
        }
        
        return "don't knot the time ):"
    }
    
    static func priceWithTrip(trip: Trip) -> String{
        if let stringPrice = trip.price as? String{
            return "€ " + stringPrice
        }else if let doublePrice = trip.price as? Double{
            return "€ " + String(doublePrice)
        }
        
        return "FREE :D"
    }
    
    static func priceNumberValueWithTrip(trip: Trip) -> Double{
        if let price = trip.price as? Double{
            return price
        }else if let price = trip.price as? NSString{
            return price.doubleValue
        }
        
        return 0
    }
    
    static func durationWithTrip(trip: Trip) -> String{
        
        if let difference = timeDiferenceWithTrip(trip: trip),
            let stops = trip.numberOfStops{
            
            let stopsString = stops > 0 ? String(stops) + " stops" : "Direct"
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            
            return stopsString + "  " + (formatter.string(from: difference) ?? "") + " h"
            
        }
        
        return "Eternity"
    }
    
    static func timeDiferenceWithTrip(trip: Trip) -> TimeInterval?{
        if let startDate = dateFromString(string: trip.departure),
            let endDate = dateFromString(string: trip.arrival){
            return endDate.timeIntervalSince(startDate)
        }
        return nil
    }
    
    
    static func dateFromString(string: String?) -> Date?{
        guard string != nil else {return nil}
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: string!)
    }
    
    static func mergeDeparture(departure: String, arrival: String) -> String{
        return departure + " - " + arrival
    }
}

//Sorting methods
extension Parser{
    static func sortByPrice(trips: [Any]?) -> [Any]?{
        guard trips != nil else {return [Any]()}
        
        return trips?.sorted(by: { (element1, element2) -> Bool in
            if let trip1 = element1 as? Trip,
                let trip2 = element2 as? Trip{
                return Parser.priceWithTrip(trip: trip1) < priceWithTrip(trip: trip2)
            }else{
                return false
            }
        })
    }
    
    static func sortByDuration(trips: [Any]?) -> [Any]?{
        guard trips != nil else {return [Any]()}
        
        return trips?.sorted(by: { (element1, element2) -> Bool in
            if let trip1 = element1 as? Trip,
                let trip2 = element2 as? Trip{
                return Double(Parser.timeDiferenceWithTrip(trip: trip1) ?? 0) < Double(Parser.timeDiferenceWithTrip(trip: trip2) ?? 0)
            }else{
                return false
            }
        })
    }
    
    static func sortByNumberOfStops(trips: [Any]?) -> [Any]?{
        guard trips != nil else {return [Any]()}
        
        return trips?.sorted(by: { (element1, element2) -> Bool in
            if let trip1 = element1 as? Trip,
                let trip2 = element2 as? Trip{
                return trip1.numberOfStops ?? 0 < trip2.numberOfStops ?? 0
            }else{
                return false
            }
        })
    }
}
