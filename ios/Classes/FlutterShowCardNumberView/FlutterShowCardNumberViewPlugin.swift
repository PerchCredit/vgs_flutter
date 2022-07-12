//
//  FlutterShowCardNumberViewPlugin.swift
//  Runner
//

import Foundation
import Flutter

/// Flutter plugin for bridging VGSShow.
public class FlutterShowCardNumberViewPlugin {
    class func register(with registrar: FlutterPluginRegistrar) {
        let viewFactory = FlutterShowCardNumberViewFactory(messenger: registrar.messenger())
        registrar.register(viewFactory, withId: "card-show-card-number-view")
    }
}
