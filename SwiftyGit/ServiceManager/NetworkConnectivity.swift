//
//  NetworkConnectivity.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation
import Alamofire

class NetworkConnectivity {
    static let shared = NetworkConnectivity()
    private let reachabilityManager = NetworkReachabilityManager()
    
    var isConnected: Bool {
        return reachabilityManager?.isReachable ?? false
    }
    
    func startListening() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the cellular connection")
            case .unknown:
                print("It is unknown whether the network is reachable")
            }
        }
    }
    
    func stopListening() {
        reachabilityManager?.stopListening()
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
