//
//  Healthkit.swift
//  HeartLogger
//
//  Created by Simone Boscaglia on 07/02/25.
//

import HealthKit
import SwiftUI

class HeartRateMonitor : ObservableObject {
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder : HKLiveWorkoutBuilder?
    @Published var heartRate : Double?
    @Published var hasAuthorization = false
    
    init() {
            checkAuthorizationStatus()
        }
    // MARK: - Request Authorization
    func requestAuthorization(/*completion: @escaping (Bool) -> Void*/) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Type is unavailable.")
//            completion(false)
            return
        }

        let typesToRead: Set<HKObjectType> = [heartRateType]

        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if let error = error {
                print("Authorization failed: \(error.localizedDescription)")
            }
//            completion(success)
        }
    }
        
    func checkAuthorizationStatus() -> HKAuthorizationStatus{
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let status = healthStore.authorizationStatus(for: heartRateType)
            DispatchQueue.main.async {
                self.hasAuthorization = (status == .sharingAuthorized)
            }
        return status
        }
    // MARK: - Start Workout and Heart Rate Query
    func startWorkout() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Heart Rate Type is unavailable.")
            return
        }

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .other
        configuration.locationType = .indoor
        
        // Creo una sessione di workout per far accendere il sensore del battito cardiaco
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        } catch {
            print("Could not create workout session.")
            return
        }
        // Se la sessione viene creata, inizio la raccolta dei dati
        workoutBuilder?.beginCollection(withStart: Date()) { success, error in
            if let error = error {
                print("Error starting workout collection: \(error.localizedDescription)")
                return
            }
            print("Workout collection started.")
        }

        startHeartRateQuery(heartRateType: heartRateType)
    }

    // In questa funzione viene creata una query che raccoglie tutti i nuovi dati presi dal sensore
    private func startHeartRateQuery(heartRateType: HKQuantityType) {
        let query = HKAnchoredObjectQuery(type: heartRateType, predicate: nil, anchor: nil, limit: HKObjectQueryNoLimit) { query, samples, _, _, error in
            if let error = error {
                print("Error querying heart rate: \(error.localizedDescription)")
                return
            }
            self.handleHeartRateSamples(samples: samples)
        }

        query.updateHandler = {query, samples, _, _, error in
            if let error = error {
                print("Error updating heart rate query: \(error.localizedDescription)")
                return
            }
            self.handleHeartRateSamples(samples: samples)
        }

        healthStore.execute(query)
    }

    // MARK: - Handle Heart Rate Data
    private func handleHeartRateSamples(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return}

        for sample in heartRateSamples {
            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
            let timestamp = sample.startDate

            //Needed to update the label on the main thread
            DispatchQueue.main.async {
                print("Heart Rate: \(heartRate) BPM at \(timestamp)")
                self.heartRate = heartRate
            }
            
        }
    }

    // MARK: - Stop Workout
    func stopWorkout() {
        workoutBuilder?.endCollection(withEnd: Date()) { success, error in
            if let error = error {
                print("Error ending workout collection: \(error.localizedDescription)")
                return
            }

            self.workoutBuilder?.finishWorkout { workout, error in
                if let error = error {
                    print("Error finishing workout: \(error.localizedDescription)")
                    return
                }
                print("Workout finished successfully: \(String(describing: workout))")
            }
        }
    }
}

