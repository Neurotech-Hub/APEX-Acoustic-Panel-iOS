//
//  CBUUID.swift
//  APEX Acoustic Panel
//
//  Created by Matt Gaidica on 3/8/24.
//

import Foundation
import CoreBluetooth

public struct BluetoothDeviceUUIDs {
    public struct Module {
        public static let serviceUUID = CBUUID(string: "AAA0")
        public static let nodeRxUUID = CBUUID(string: "AAA1")
        public static let nodeTxUUID = CBUUID(string: "AAA2")
    }
}

