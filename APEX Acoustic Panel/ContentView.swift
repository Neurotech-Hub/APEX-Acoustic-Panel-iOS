//
//  ContentView.swift
//  APEX Acoustic Panel
//
//  Created by Matt Gaidica on 3/8/24.
//

import SwiftUI
import BLEAppHelpers

struct ContentView: View {
    @State private var debug = false
    @ObservedObject var bluetoothManager = BluetoothManager(
        serviceUUID: BluetoothDeviceUUIDs.Module.serviceUUID,
        nodeRxUUID: BluetoothDeviceUUIDs.Module.nodeRxUUID,
        nodeTxUUID: BluetoothDeviceUUIDs.Module.nodeTxUUID
    )
    @ObservedObject var terminalManager = TerminalManager.shared
    @State private var attackValue: Double = Double.random(in: 0...100)
    @State private var modemValues: [Double] = (0..<6).map { _ in Double.random(in: -5...5)
    }
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let minZValue: Double = -5
    let maxZValue: Double = 5
    
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
                // Code is running in the Simulator
                return true
        #else
                // Code is running on an actual device
                return false
        #endif
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: handleBluetoothAction) {
                    Text(bluetoothManager.isConnected ? "Disconnect" : "Connect to Modem")
                        .foregroundColor(.white)
                        .padding()
                        .background(bluetoothManager.isConnected ? Color.red : Color.blue)
                        .cornerRadius(8)
                }
                Spacer()
                Button(action: {
                    self.debug.toggle() // Toggle the debug state
                }) {
                    Text("debug")
                        .foregroundColor(.gray)
                }
            }
            .padding([.leading,.trailing],40)
            
            if bluetoothManager.isConnecting {
                Text("Connecting...")
                    .foregroundColor(.gray)
                    .font(.caption)
            }

            Divider()
            
            Spacer()
            
            if (bluetoothManager.isConnected || isSimulator || debug) {
                // Linear gauge with a larger font and size
                VStack {
                    Gauge(value: attackValue, in: 0...100) {
                        EmptyView()
                    } currentValueLabel: {
                        Text("\(Int(attackValue))%")
                            .font(.title)
                    }
                    .gaugeStyle(SpeedometerGaugeStyle())
                    .scaleEffect(1)
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Text("Delta Rhythm")
                    Gauge(value: modemValues[0], in: -5...5) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(String(format: "%.1f", modemValues[0]))
                    }
                    minimumValueLabel: {
                        Text("\(Int(minZValue))")
                    } maximumValueLabel: {
                        Text("\(Int(maxZValue))")
                    }
                    .gaugeStyle(.accessoryLinear)
                    
                    Text("Theta Rhythm")
                    Gauge(value: modemValues[1], in: -5...5) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(String(format: "%.1f", modemValues[1]))
                    }
                    minimumValueLabel: {
                        Text("\(Int(minZValue))")
                    } maximumValueLabel: {
                        Text("\(Int(maxZValue))")
                    }
                    .gaugeStyle(.accessoryLinear)
                    
                    Text("Alpha Rhythm")
                    Gauge(value: modemValues[2], in: -5...5) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(String(format: "%.1f", modemValues[1]))
                    }
                    minimumValueLabel: {
                        Text("\(Int(minZValue))")
                    } maximumValueLabel: {
                        Text("\(Int(maxZValue))")
                    }
                    .gaugeStyle(.accessoryLinear)
                    
                    Text("Beta Rhythm")
                    Gauge(value: modemValues[3], in: -5...5) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(String(format: "%.1f", modemValues[1]))
                    }
                    minimumValueLabel: {
                        Text("\(Int(minZValue))")
                    } maximumValueLabel: {
                        Text("\(Int(maxZValue))")
                    }
                    .gaugeStyle(.accessoryLinear)
                    
                    Text("Gamma Rhythm")
                    Gauge(value: modemValues[4], in: -5...5) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(String(format: "%.1f", modemValues[1]))
                    }
                    minimumValueLabel: {
                        Text("\(Int(minZValue))")
                    } maximumValueLabel: {
                        Text("\(Int(maxZValue))")
                    }
                    .gaugeStyle(.accessoryLinear)
                    
                    Text("Movement")
                    Gauge(value: modemValues[5], in: -5...5) {
                        EmptyView()
                    } currentValueLabel: {
                        Text(String(format: "%.1f", modemValues[1]))
                    }
                    minimumValueLabel: {
                        Text("\(Int(minZValue))")
                    } maximumValueLabel: {
                        Text("\(Int(maxZValue))")
                    }
                    .gaugeStyle(.accessoryLinear)
                }
                .padding()
                .onAppear {
                    bluetoothManager.onDisconnect = {
                        resetAllViewVars()
                    }
                    bluetoothManager.onNodeTxValueUpdated = { dataString in
                        parseNode(from: dataString)
                    }
                }
            }
            
            Spacer()
            
            // terminal
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(terminalManager.receivedMessages, id: \.self) { message in
                        Text(message)
                            .foregroundColor(Color.green)
                            .font(.system(size: 11, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    }
                }
                .padding(5)
            }
            .frame(maxWidth: .infinity, maxHeight: 100) // Full width and fixed height
            .background(Color.black)
            .cornerRadius(5)
            .padding()
        }
        .onReceive(timer) { _ in
            if (debug || isSimulator) {
                attackValue = Double.random(in: 0...100)
                modemValues = (0..<6).map { _ in Double.random(in: -5...5) }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func resetAllViewVars() {
    }
    
    func parseNode(from dataString: String) {
        let values = dataString.split(separator: ",")
        for (index, value) in values.enumerated() {
            if let doubleValue = Double(value) {
                if index < modemValues.count {
                    modemValues[index] = doubleValue
                }
            }
        }

        let modemValuesString = modemValues.map { String($0) }.joined(separator: ", ")
        terminalManager.addMessage(modemValuesString)
        
        let sum = modemValues[4] + modemValues[5]
        attackValue = sum * 20
        attackValue = max(0, min(attackValue, 100)) // Ensure attackValue is between 0 and 100
    }
    
    func handleBluetoothAction() {
        if bluetoothManager.isConnected || bluetoothManager.isConnecting {
            bluetoothManager.disconnect()
        } else {
            bluetoothManager.startScanning()
        }
    }
}

struct LinearGaugeStyle: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Capsule().fill(Color.gray.opacity(0.3))
            GeometryReader { geo in
                Capsule().fill(Color.blue)
                    .frame(width: geo.size.width * CGFloat(configuration.value / 100))
            }
        }
    }
}

struct CircularGaugeStyle: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle().stroke(lineWidth: 10).opacity(0.3).foregroundColor(Color.gray)
            Circle().trim(from: 0, to: CGFloat((configuration.value + 5) / 10))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(color(for: configuration.value))
                .rotationEffect(Angle(degrees: -90))
            Text(String(format: "%.1f", configuration.value))
        }
    }
    
    private func color(for value: Double) -> Color {
        switch value {
        case let x where x < 0:
            return .red
        case 0:
            return .green
        case let x where x > 0:
            return .red
        default:
            return .gray
        }
    }
}

struct SpeedometerGaugeStyle: GaugeStyle {
    private var gradient = LinearGradient(gradient: Gradient(colors: [ Color(red: 0/255, green: 255/255, blue: 0/255), Color(red: 255/255, green: 0/255, blue: 0/255) ]), startPoint: .trailing, endPoint: .leading)
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            
            Circle()
                .foregroundColor(Color(.systemGray6))
            
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(gradient, lineWidth: 20)
                .rotationEffect(.degrees(135))
            
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
            
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 200, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                Text("Attack Meter")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
            }
            
        }
    }
    
}

struct CustomGaugeView: View {
    @State private var currentSpeed = 140.0
    
    var body: some View {
        Gauge(value: currentSpeed, in: 0...200) {
            Image(systemName: "gauge.medium")
                .font(.system(size: 50.0))
        } currentValueLabel: {
            Text("\(currentSpeed.formatted(.number))")
                .font(.system(size: 200, weight: .bold, design: .rounded))
        }
        .gaugeStyle(SpeedometerGaugeStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
