//
//  ContentView.swift
//  Matrix Scanner
//
//  Created by Public Works on 5/26/22.
//

import SwiftUI
import AVFoundation
import CarBode


let MONITOR = "Monitor"
let COMPUTER = "Computer or Laptop"
let PHONE = "Phone"
let ALERT = "Export Inventory File?"

struct MapView: View{
    var body: some View{
        
        Text("Map should be here")
    }
}

struct ContentView: View {
    
    @State var isPresentingScanner = false
    @State var scannedCode: String = "code text"
    @State var locationLabel: String = "Location"
    @State var deviceLabel: String = "Device"
    @State var flashLight: Bool = false
    @State var enableScan: Bool = true
    @State var codeScanned: Bool = false
    @State var computerList: [String] = []
    @State var phoneList: [String] = []
    @State var monitorList: [String] = []
    @State var showAlert: Bool = false
    
    
    var scannerSheet: some View{
        
        VStack{
            ZStack{
                Text("Scan Code")
                    .padding()
                HStack{
                    Button(action: {
                        self.codeScanned = false
                        self.isPresentingScanner = false
                    }, label: {
                        Text("Cancel")
                            .padding()
                    })
                    Spacer()
                }
            }
            Text(scannedCode)
                .padding()
            CBScanner(supportBarcode: .constant([.qr, .dataMatrix, .code128, .codabar, .microQR, .catBody, .gs1DataBar, .ean13, .ean8, .aztec, .catBody, .dogBody, .microQR, .pdf417]),
                torchLightIsOn: $flashLight,
                scanInterval: .constant(5.0)){
                if (enableScan == true && scannedCode != $0.value){
                        scannedCode = $0.value
                        enableScan = false
                        codeScanned = true
                }
                print($0.type.rawValue, "\n \n \n", $0.value, "\n\n\n")
            }
            onDraw: {
                if(enableScan == false){
                    let lineWidth = 2
                    let lineColor = UIColor.red
                    let fillColor = UIColor(red: 1, green: 0, blue: 0.2, alpha: 0.4)
                    $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
                } else {
                    let lineWidth = 2
                    let lineColor = UIColor.green
                    let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)
                    $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
                }
            }
            HStack{
                Button(action: {
                    self.flashLight.toggle()
                }, label: {
                    if(flashLight) {
                        Image(systemName: "lightbulb.fill")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 50, height: 60)
                    } else {
                        Image(systemName: "lightbulb")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 50, height: 60)
                    }
                })
                .padding()
                Button {
                    self.enableScan = true
                } label: {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 60, height: 60)
                }
                .padding()
                .disabled(enableScan == true)
                Button(action: {
                    self.codeScanned = true
                    self.isPresentingScanner = false
                    flashLight = false
                    enableScan = true
                }, label: {
                    Image(systemName: "checkmark.circle")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 60, height: 60)
                })
                .padding()
                .disabled(scannedCode == "code data")
            }
        }
        
    }
    
    var body: some View {
        
        ZStack{
            VStack {
                
                Menu(content: {
                    Button("Government Center", action: {
                        locationLabel = "Government Center"
                    })
                    Button("Vector Control", action: {
                        locationLabel = "Vector Control"
                        
                    })
                    Button("Field Operations", action: {
                        locationLabel = "Field Operations"
                        
                    })
                    Button("Roads", action: {
                        locationLabel = "Roads"
                    })
                }, label: {
                    HStack{
                        Text(locationLabel)
                            .font(.system(size: 25))
                            .padding(.bottom,50)
                        Image(systemName: "arrowtriangle.down.square.fill")
                            .padding(.bottom,50)
                    }
                })
                
                Image("Clark_County")
                    .resizable(resizingMode: .stretch)
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 30)
                Text("Scan Code")
                    .font(.system(size: 20))
                Button{
                    self.isPresentingScanner = true
                } label: {
                    Image(systemName: "viewfinder.circle")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 40, height: 40)
                }
                .sheet(isPresented: $isPresentingScanner){
                    self.scannerSheet
                }
                Spacer().frame(height: 30)
                Menu(content: {
                    Button{
                        deviceLabel = "Monitor"
                    } label: {
                        HStack{
                            Text("Monitor")
                            Image(systemName: "desktopcomputer")
                                .resizable(resizingMode: .stretch)
                                .frame(width: 30, height:30)
                        }
                        
                    }
                    Button{
                        deviceLabel = "Phone"
                    } label: {
                        HStack{
                            Text("Phone")
                            Image(systemName: "phone.fill")
                                .resizable(resizingMode: .stretch)
                                .frame(width: 30, height: 30)
                        }
                    }
                    Button{
                        deviceLabel = "Computer or Laptop"
                    } label: {
                        HStack{
                            Text("Computer or Laptop")
                            Image(systemName: "airport.extreme.tower")
                                .resizable(resizingMode: .stretch)
                                .frame(width: 30, height: 30)
                        }
                        
                    }
                }, label: {
                    HStack{
                        Text(deviceLabel)
                            .font(.system(size: 20))
                        Image(systemName: "arrowtriangle.down.square.fill")
                    }
                })
                .padding(.bottom, 80)
                Spacer().frame(height:15)

                
                Text(scannedCode)
                    .font(.system(size: 15))
                Button(action: {
                    if(deviceLabel == MONITOR){
                        monitorList.append(scannedCode)
                    }
                    else if(deviceLabel == COMPUTER){
                        computerList.append(scannedCode)
                    }
                    else if(deviceLabel == PHONE){
                        phoneList.append(scannedCode)
                    }
                    scannedCode = "code text"
                }, label: {
                  Text("Add")
                        .font(.system(size: 20))
                        .padding(.top, 15)
                })
                .disabled(scannedCode == "code text")
            }
            .frame(alignment: .center)
            
            HStack{
                Spacer()
                VStack{
                    Button(action: {
                        
                        showAlert = true
                        
                    }, label:{
                        Text("Done")
                    })
                    .alert(ALERT, isPresented: $showAlert) {
                        Button("Ok"){
                            let file = deviceLabel + ".txt"
                            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                            
                            let directory = locationLabel
                            
                            let dirURL = dir.appendingPathComponent(directory)
                            
                            do{
                                try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                print("\(error)")
                            }
                            let fileURL = dirURL.appendingPathComponent(file)
                            
                            if(deviceLabel == MONITOR){
                                do{
                                    var monitorFile: String = ""
                                    for i in monitorList{
                                        monitorFile += i + "\n"
                                    }
                                    print(monitorFile)
                                    try monitorFile.write(to: fileURL, atomically: false, encoding: .utf8)
                                } catch {
                                    print("Error \(error)")
                                }
                            } else if(deviceLabel == COMPUTER) {
                                do{
                                    var computerFile: String = ""
                                    for i in computerList{
                                        computerFile += i + "\n"
                                    }
                                    print(computerFile)
                                    try computerFile.write(to: fileURL, atomically: false, encoding: .utf8)
                                } catch {
                                    print("Error \(error)")
                                }
                            } else if(deviceLabel == PHONE){
                                do{
                                    var phoneFile: String = ""
                                    for i in phoneList{
                                        phoneFile += i + "\n"
                                    }
                                    print(phoneFile)
                                    try phoneFile.write(to: fileURL, atomically: false, encoding: .utf8)
                                } catch {
                                    print("Error \(error)")
                                }
                            }
                        }
                        Button{
                            
                        } label: {
                            Text("Cancel")
                        }
                    }
                    .padding(.trailing, 10)
                    .padding(.horizontal, 12)
                    .font(.system(size: 22))
                    Spacer()
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
                
    }
}
