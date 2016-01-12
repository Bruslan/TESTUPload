//
//  VerbundenVC.swift
//  LufttachoAppIP
//
//  Created by Brus Lan on 11.01.16.
//  Copyright © 2016 Brus Lan. All rights reserved.
//


import UIKit
import CoreBluetooth
import Charts


class VerbundenVC: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, ChartViewDelegate, SideBarDelegate {

    @IBOutlet weak var Graph: LineChartView!
  var sideBar:SideBar = SideBar()

    
        override func viewDidLoad() {
        super.viewDidLoad()
            
            sideBar = SideBar(sourceView: self.view, menuItems: ["Eins", "Zwei", "Drei", "Usw"])
            sideBar.delegate = self
            
          
            
            
            
            
            
            
            
          // Beispiel Chart
            
            Graph.delegate = self
            Graph.noDataTextDescription = "Keine Daten"
           Graph.dragEnabled = true
           Graph.setScaleEnabled(true)
           Graph.pinchZoomEnabled = true
          Graph.drawGridBackgroundEnabled = true
            
            let xAxis : ChartXAxis = Graph.xAxis
            xAxis.drawGridLinesEnabled = false
            let yAxis : ChartYAxis = Graph.leftAxis
            yAxis.setLabelCount(6, force: true)
           yAxis.startAtZeroEnabled = false
            
            yAxis.drawGridLinesEnabled = false
            yAxis.axisLineColor = UIColor.whiteColor()
            
            Graph.rightAxis.enabled =  false
            Graph.legend.enabled = false
            
            let Xachse = ["1", "2", "3", "4", "5", "6"]
            let YAchse = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
            Graph.animate(xAxisDuration: 0.5, yAxisDuration: 0)
            setChart(Xachse, values: YAchse)


    }
    
    
    
    


    
    
    
    
    override func viewDidAppear(animated: Bool) {
        manager.delegate = self
      
        
        
    }
    
    
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Vebunden :D ")
          PeripheralGerät?.delegate = self
        if let PeripheralGerät = PeripheralGerät
        {
        
        PeripheralGerät.discoverServices(nil)
            
        }
        
    }
    
    
    
    
    
    @IBAction func Disconnect(sender: AnyObject) {
        
        if let Manager = manager
        {
        
            Manager.cancelPeripheralConnection(PeripheralGerät!)
            
            let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Suchen") as! SuchenViewController
            
            self.navigationController!.pushViewController(secondViewController, animated: true)
            
        }
        
    }
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let peripheralservices = peripheral.services
        {
            for i in peripheralservices{
        print("Services: \(i)")
                peripheral.discoverCharacteristics(nil, forService: i)
                
            }
        }
    }
    
    
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if let Characteristics = service.characteristics
        {
        for i in Characteristics
        {
            print("Characteristics gefunden: \(i)")
        
            
            
            
            
            
            // Comment: Hier habe ich festgelegt welche Daten beschrieben werden. Die Daten die auf dem Bluetooth gerät ankommen sind vom Typ NSDATA!!

            var value = NSInteger(1000000) //Hier sage ich wieviele Zahlen Ankommen dürfen, bzw. wieviel das Module versendet!
            
            let valueData : NSData = NSData(bytes: &value, length: 1)
            peripheral.writeValue(valueData, forCharacteristic: i, type: CBCharacteristicWriteType.WithResponse)

            peripheral.setNotifyValue(true, forCharacteristic: i)
            peripheral.setNotifyValue(true, forCharacteristic: i)
            
            }
        
        }
    }
    

    
   // Hier kommen die Daten schließlich an!! Sie kommen als NSDATA an!
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let Value = characteristic.value
        {
            if characteristic.UUID == CBUUID(string:"00000002-0000-1000-8000-008025000000")
            {
          //print(Value) //
                
                
                // verwandle sie hier in ein UINT 32 Hexa String
                let count = Value.length / sizeof(UInt32)
                var array = [UInt32](count: count, repeatedValue: 6)  // Array sieht ca. so aus 6023400231 0929347172 13234564564 131234134234 .....
                
                // copy bytes into array
                Value.getBytes(&array, length:count * sizeof(UInt32))
                
                
                //print(array)
                
                
                // ich gehe array durch: nun sieht sie so aus  i = 6023400231 (UINT32)
                for i in array
                {
                print(i)

                }
            
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "DAten")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        Graph.data = lineChartData
        
    }
    
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{
            //imageView.backgroundColor = UIColor.redColor()
            //imageView.image = nil
        } else if index == 1{
            //imageView.backgroundColor = UIColor.clearColor()
            //imageView.image = UIImage(named: "image2")
        }
    }


}
