//
//  TMStoreManager.swift
//  Timer
//
//  Created by yangqingren on 2024/3/3.
//

import UIKit

//class TMStoreManager: NSObject {
//    
//    static let share = TMStoreManager()
//    
//    override init() {
//        super.init()
//        
//        
//    }
//    
//    func pay() {
//        let identities = []
//        let products = try await Product.products(for: identities)
//        let result = try await products.first?.purchase()
//        switch result {
//        case .success(let verificationResult):
//            
//        case .userCancelled:
//            <#code#>
//        case .pending:
//            <#code#>
//        }
//    }
//    
//    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {    //Check if the transaction passes StoreKit verification.
//        switch result {    case .unverified:      //StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
//          throw StoreError.failedVerification
//        case .verified(let safe):      //If the transaction is verified, unwrap and return it.
//          return safe
//        }
//      }
//}
