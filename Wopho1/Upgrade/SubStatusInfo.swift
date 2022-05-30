//
//  SubStatusInfo.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 21.01.22.
//  Copyright © 2022 Sebastian Schmitt. All rights reserved.
//

import SwiftUI
import StoreKit

struct SubStatusInfo: View {
    var body: some View {
        Text(statusDescription())
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    let product: Product
    let status: Product.SubscriptionInfo.Status
    var subs: [Product] = []
    
    func statusDescription() -> String {
        guard case .verified(let renewalInfo) = status.renewalInfo,
              case .verified(let transaction) = status.transaction else {
                  return "The App Store could not verify your subscription status."
        }
        
        var description = ""
        
        switch status.state {
        case .subscribed:
            description = subscribedDescription()
        case .expired:
            if let expirationDate = transaction.expirationDate,
               let expirationReason = renewalInfo.expirationReason {
                description = expirationDescription(expirationReason, expirationDate: expirationDate)
            }
        case .revoked:
            if let revokedDate = transaction.revocationDate {
                description = "The App Store refunded your subscription to \(product.displayName) on \(revokedDate.formatted())."
            }
        case .inGracePeriod:
            description = gracePeriodDescription(renewalInfo)
            
        default:
            break
        }
        
        if let expirationDate = transaction.expirationDate {
            description += renewalDescription(renewalInfo, expirationDate)
        }
        return description
    }
    
    func subscribedDescription() -> String {
        return "Aktuelles Abo -> \(product.displayName)."
    }
    
    func expirationDescription(_ expirationReason: StoreKit.Product.SubscriptionInfo.RenewalInfo.ExpirationReason, expirationDate: Date) -> String {
        var description = ""
        
        switch expirationReason {
        case .autoRenewDisabled:
            if expirationDate > Date() {
                description += "Your subscription to \(product.displayName) will expire on \(expirationDate.formatted())."
            } else {
                description += "Your subscription to \(product.displayName) expired on \(expirationDate.formatted())."
            }
        case .billingError:
            description = "Your subscription to \(product.displayName) was not renewed due to a billing error."
        case .didNotConsentToPriceIncrease:
            description = "Your subscription to \(product.displayName) was not renewed due to a price increase that you disapproved."
        case .productUnavailable:
            description = "Your subscription to \(product.displayName) was not renewed because the product is no longer available."
        default:
            description = "Your subscription to \(product.displayName) was not renewed."
        }
        return description
    }
    
    func gracePeriodDescription(_ renewalInfo: StoreKit.Product.SubscriptionInfo.RenewalInfo) -> String {
        var description = "The App Store could not confirm your billing information for \(product.displayName)."
        if let untilDate = renewalInfo.gracePeriodExpirationDate {
            description += " Please verify your billing information to continue service after \(untilDate.formatted())"
        }

        return description
    }
    
    
    func renewalDescription(_ renewalInfo: StoreKit.Product.SubscriptionInfo.RenewalInfo, _ expirationDate: Date) -> String {
        var description = ""
        
        if let newProductID = renewalInfo.autoRenewPreference {
            if let newProduct = subs.first(where: { $0.id == newProductID }) {
                description += "\nYour subscription to \(newProduct.displayName)"
                description += " will begin when your current subscription expires on \(expirationDate.formatted())."
            }
        } else if renewalInfo.willAutoRenew {
            description += "\nNext billing date: \(expirationDate.formatted())."
        }
        
        return description
    }
    
    
    
    
}
