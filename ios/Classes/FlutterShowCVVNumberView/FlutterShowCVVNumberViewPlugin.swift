//
//  FlutterShowCVVNumberViewPlugin.swift
//  Runner
//

import Foundation
import Flutter

/// Flutter plugin for bridging VGSShow.
public class FlutterShowCVVNumberViewPlugin {
    class func register(with registrar: FlutterPluginRegistrar) {
        let viewFactory = FlutterShowCVVNumberViewFactory(messenger: registrar.messenger())
        registrar.register(viewFactory, withId: "card-show-cvv-view")
    }
}
