//
//  HeartRateReader.swift
//  OpusIOS
//
//  Created by Andrea Iannaccone on 05/03/25.
//
import Foundation
import HealthKit


class HeartRateReader : NSObject, ObservableObject {
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder : HKWorkoutBuilder?
    @Published var heartRate : Double?
    
    var anchor: HKQueryAnchor? = nil
    var results: HKAnchoredObjectQueryDescriptor<HKQuantitySample>.Result?
    let heartRateType = HKQuantityType(.heartRate)


    
    func requestAuthorization() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Type is unavailable.")
            return
        }
        
        let typesToRead: Set<HKObjectType> = [heartRateType]
        
        healthStore.requestAuthorization(toShare: [heartRateType], read: typesToRead){ success, error in
            if let error = error {
                print("Authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
     func startHeartRateQuery(heartRateType: HKQuantityType) {
         
         // Create a query descriptor.
         let anchorDescriptor =
         HKAnchoredObjectQueryDescriptor(
             predicates: [.quantitySample(type: heartRateType)],
             anchor: anchor
         )

         let updateQueue = anchorDescriptor.results(for: healthStore)
         let updateTask = Task {
             for try await update in updateQueue {
                 // Process the update here.
                 print(update)
             }
         }
         
//        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { query, samples, _, _, error in
//            if let error = error {
//                print("Error querying heart rate: \(error.localizedDescription)")
//                return
//            }
//            self.handleHeartRateSamples(samples: samples)
//        }
//
//        query.updateHandler = {query, samples, _, _, error in
//            print("test")
//
//            if let error = error {
//                print("Error updating heart rate query: \(error.localizedDescription)")
//                return
//            }
//            self.handleHeartRateSamples(samples: samples)
//        }
//
//        healthStore.execute(query)
    }
    
    // MARK: - Handle Heart Rate Data
    private func handleHeartRateSamples(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        for sample in heartRateSamples {
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
            let timestamp = sample.startDate
            
            //Needed to update the label on the main thread
            DispatchQueue.main.async {
                self.heartRate = heartRate
                print("Heart Rate: \(heartRate) BPM at \(timestamp)")
            }
            
        }
    }
}
