import SwiftUI

struct ContentView: View {
    @State private var linearValue: Double = Double.random(in: 0...100)
    @State private var circularValues: [Double] = (0..<5).map { _ in Double.random(in: -5...5)
    }
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let minZValue: Double = -5
    let maxZValue: Double = 5
    
    var body: some View {
        VStack {
            Divider()

            // Linear gauge with a larger font and size
            VStack {
                Text("Attack Meter")
                    .font(.title)
                Gauge(value: linearValue, in: 0...100) {
                    EmptyView()
                } currentValueLabel: {
                    Text("\(Int(linearValue))%")
                        .font(.title)
                }
                .gaugeStyle(SpeedometerGaugeStyle())
                .scaleEffect(1)
            }
            .padding()
            
            Spacer()
            
            VStack {
                Text("Delta Rhythm")
                Gauge(value: circularValues[0], in: -5...5) {
                    EmptyView()
                } currentValueLabel: {
                    Text(String(format: "%.1f", circularValues[0]))
                }
                minimumValueLabel: {
                    Text("\(Int(minZValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxZValue))")
                }
                .gaugeStyle(.accessoryLinear)
                
                Text("Theta Rhythm")
                Gauge(value: circularValues[1], in: -5...5) {
                    EmptyView()
                } currentValueLabel: {
                    Text(String(format: "%.1f", circularValues[1]))
                }
                minimumValueLabel: {
                    Text("\(Int(minZValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxZValue))")
                }
                .gaugeStyle(.accessoryLinear)
                
                Text("Alpha Rhythm")
                Gauge(value: circularValues[1], in: -5...5) {
                    EmptyView()
                } currentValueLabel: {
                    Text(String(format: "%.1f", circularValues[1]))
                }
                minimumValueLabel: {
                    Text("\(Int(minZValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxZValue))")
                }
                .gaugeStyle(.accessoryLinear)
                
                Text("Beta Rhythm")
                Gauge(value: circularValues[1], in: -5...5) {
                    EmptyView()
                } currentValueLabel: {
                    Text(String(format: "%.1f", circularValues[1]))
                }
                minimumValueLabel: {
                    Text("\(Int(minZValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxZValue))")
                }
                .gaugeStyle(.accessoryLinear)
                
                Text("Gamma Rhythm")
                Gauge(value: circularValues[1], in: -5...5) {
                    EmptyView()
                } currentValueLabel: {
                    Text(String(format: "%.1f", circularValues[1]))
                }
                minimumValueLabel: {
                    Text("\(Int(minZValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxZValue))")
                }
                .gaugeStyle(.accessoryLinear)
                
                Text("Movement")
                Gauge(value: circularValues[1], in: -5...5) {
                    EmptyView()
                } currentValueLabel: {
                    Text(String(format: "%.1f", circularValues[1]))
                }
                minimumValueLabel: {
                    Text("\(Int(minZValue))")
                } maximumValueLabel: {
                    Text("\(Int(maxZValue))")
                }
                .gaugeStyle(.accessoryLinear)
    
            }
            .padding()
        }
        .onReceive(timer) { _ in
            linearValue = Double.random(in: 0...100)
            circularValues = (0..<5).map { _ in Double.random(in: -5...5) }
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
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                Text("KILL")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.gray)
            }
            
        }
//        .frame(width: 300, height: 300)
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
            
        }
        .gaugeStyle(SpeedometerGaugeStyle())
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
