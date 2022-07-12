//
//  FlutterShowCVVNumberView.swift
//  Runner
//

import Foundation
import Flutter
import UIKit
import VGSShowSDK

/// FlutterPlatformView wrapper for VGSShowCVVNumberView.
class FlutterShowCVVNumberView: NSObject, FlutterPlatformView {
    
    // MARK: - Vars
    
    var vgsShowCVVNumber = VGSShow(id: "tntazhyknp1", environment: .sandbox)

    let showCVVNumberView: ShowCVVNumberView
    let messenger: FlutterBinaryMessenger
    let channel: FlutterMethodChannel
    let viewId: Int64
    
    // MARK: - Initialization
    
    init(messenger: FlutterBinaryMessenger,
         frame: CGRect,
         viewId: Int64,
         args: Any?) {
        
        self.messenger = messenger
        self.viewId = viewId
        self.showCVVNumberView = ShowCVVNumberView()
        
        channel = FlutterMethodChannel(name: "card-show-cvv-view/\(viewId)", binaryMessenger: messenger)
        
        super.init()
        self.showCVVNumberView.subscribeViewsToShow(self.vgsShowCVVNumber)
        
        channel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "revealCVV":
                self.revealCVV(with: call, result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    // MARK: - FlutterPlatformView
    
    public func view() -> UIView {
        return self.showCVVNumberView
    }
    
    // MARK: - Helpers
    
    private func revealCVV(with flutterMethodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        var errorInfo: [String : Any] = [:]
		guard let args = flutterMethodCall.arguments as? [Any],
					let vaultId = args.first as? String, 
                    let sandbox = args[1] as? Bool,
                    let customerToken = args[2] as? String,
                    let cardId = args[3] as? String
		else {
			errorInfo["show_error_code"] = 999
			errorInfo["show_error_message"] = "No payload to reveal. Collect some data first!"
			
            result(errorInfo)
			return
		}
        self.vgsShowCVVNumber = VGSShow(id: vaultId, environment: sandbox ?  .sandbox: .live)
        self.showCVVNumberView.subscribeViewsToShow(self.vgsShowCVVNumber)
        
        self.vgsShowCVVNumber.customHeaders = [
            "Authorization": "Bearer " + customerToken,
            "htmlWrapper": "text",
            "jsonPathSelector": "data.attributes.cvv2"
        ]
        
        self.vgsShowCVVNumber.request(path: "/cards/\(cardId)/secure-data/cvv2", method: .get) { (response) in
            switch response {
            case .success(let code):
                var successInfo: [String : Any] = [:]
                successInfo["show_status_code"] = code
                result(successInfo)
            case .failure(let code, let error):
                errorInfo["show_error_code"] = code
                if let message = error?.localizedDescription {
                    errorInfo["show_error_message"] = message
                }
                result(errorInfo)
            }
        }
        
    }
    
}
