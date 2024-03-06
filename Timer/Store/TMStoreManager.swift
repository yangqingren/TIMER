//
//  TMStoreManager.swift
//  Timer
//
//  Created by yangqingren on 2024/3/3.
//

import UIKit
import StoreKit

let kTip_TiiMiiPro = "kTip_TiiMiiPro"
let kTiiMiiPurchaseList = "kTiiMiiPurchaseList"

extension Notification.Name {
    public static let kPurchseSuccess = Notification.Name(rawValue: "kPurchseSuccess")
}

enum TMPurchaseError: Error {
    case noProduct
    case purchaseFail
    case verifyFail
}

enum TMPurchaseState {
    case success
    case cancel
    case pending
    case fail
}

class TMProduct: NSObject {
    
    let product: Product
    init(product: Product) {
        self.product = product
        super.init()
    }
}

class TMStoreManager: NSObject {
    
    static let share = TMStoreManager()
    
    var pruductList = [TMProduct]()
    
    lazy var identities: [String] = {
        return [kTip_TiiMiiPro]
    }()
    
    var listener: Task<Void, Error>? = nil // 支付事件监听
    
    var isPro: Bool {
        get {
            return TMStoreManager.getPurchaseSuccess(kTip_TiiMiiPro)
        }
    }
    
    static func getDisplayPrice(_ tip: String) -> String? {
        var item: TMProduct? = nil
        for obj in TMStoreManager.share.pruductList {
            if obj.product.id == tip {
                item = obj
                break
            }
        }
        if let item = item {
            return item.product.displayPrice
        }
        else {
            return nil
        }
    }
        
    override init() {
        super.init()
        
        Task {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    TMStoreManager.setupPurchaseSuccess(transaction.productID)
                    await transaction.finish()
                }
            }
        }
        
        Task {
            self.listener = Task.detached {
                for await verificationResult in Transaction.updates {
                    if case .verified(let transaction) = verificationResult {
                        TMStoreManager.setupPurchaseSuccess(transaction.productID)
                        await transaction.finish()
                    }
                }
            }
        }
        
        Task {
            try await self.request(nil)
        }
    }
    
    static func setupPurchaseSuccess(_ tip: String) {
        DispatchQueue.main.async {
            var list = UserDefaults.standard.object(forKey: kTiiMiiPurchaseList) as? [String]
            if list == nil {
                list = [String]()
            }
            list?.append(tip)
            UserDefaults.standard.set(list, forKey: kTiiMiiPurchaseList)
            NotificationCenter.default.post(name: Notification.Name.kPurchseSuccess, object: tip)
        }
    }
    
    static func getPurchaseSuccess(_ tip: String) -> Bool {
        if let list = UserDefaults.standard.object(forKey: kTiiMiiPurchaseList) as? [String] {
            if list.contains(tip) {
                return true
            }
        }
        return false
    }
    
    func request(_ tip: String?) async throws {
        var identities = [String]()
        if let tip = tip {
            identities = [tip]
        }
        else {
            identities = self.identities
        }
        do {
            let products = try await Product.products(for: identities)
            debugPrint("products=\(products)")
            for item1 in products {
                var has = false
                for item2 in self.pruductList {
                    if item1.id == item2.product.id {
                        has = true
                        break
                    }
                }
                if !has {
                    let pruduct = TMProduct(product: item1)
                    self.pruductList.append(pruduct)
                }
            }
            return
        }
        catch {
            throw error
        }
    }
    
    static func purchaseVip() {
        TMLoading.showInView(TMGetTopController()?.view)
        Task {
            do {
                let result = try await TMStoreManager.share.purchase(kTip_TiiMiiPro)
                DispatchQueue.main.async {
                    // dismiss
                    switch result {
                    case .success:
                        TMStoreManager.setupPurchaseSuccess(kTip_TiiMiiPro)
                        break
                    case .cancel:
                        break
                    case .pending:
                        break
                    case .fail:
                        break
                    }
                    TMLoading.dismiss()
                }
            }
            catch {
                debugPrint("error=\(error)")
                DispatchQueue.main.async {
                    // dismiss
                    TMLoading.dismiss()
                }
            }
        }
    }
    
    func restore() {
        // loading
        Task {
            try await AppStore.sync()
            DispatchQueue.main.async {
                // dismiss
               
            }
        }
    }
    
    func purchase(_ tip: String) async throws -> (TMPurchaseState) {
        var product: Product?
        for item in self.pruductList {
            if item.product.id == tip {
                product = item.product
                break
            }
        }
        if product == nil {
            do {
                try await self.request(tip)
                for item in self.pruductList {
                    if item.product.id == tip {
                        product = item.product
                        break
                    }
                }
            }
            catch {
                debugPrint("支持模块，products error=\(error)")
                throw TMPurchaseError.noProduct
            }
        }
        if let product = product {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verificationResult):
                    if case .verified(let transaction) = verificationResult {
                        await transaction.finish()
                        return .success
                    }
                    else {
                        throw TMPurchaseError.verifyFail
                    }
                case .userCancelled:
                    return .cancel
                case .pending:
                    return .pending
                default:
                    return .fail
                }
            }
            catch {
                debugPrint("支持模块，purchase error=\(error)")
                throw TMPurchaseError.purchaseFail
            }
        }
        else {
            throw TMPurchaseError.noProduct
        }
    }
}
