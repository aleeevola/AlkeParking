import UIKit
import Foundation

protocol Parkable {
    var plate: String { get }
    var type: VehicleType {get}
    var checkInTime : Date {get}
    var discountCard: String? { get }
    var parkedTime : Int{get}
}

struct Parking {
    let maxVehicles = 20
    var vehicles: Set<Vehicle> = []
    
    var resume : (totalVehicle:Int,totalFee:Int) = (0,0)

    var listVehicles : [String] {
        var result : [String] = []
        vehicles.forEach { vehicle in
            result.append(vehicle.plate)
        }
        return result
    }
}

extension Parking {
    
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        guard vehicles.count < maxVehicles else{
            print("Sorry, the check-in failed")
            return onFinish(false)
        }
        let result : (Bool,_) = vehicles.insert(vehicle)
        
        result.0 ? print("Welcome to AlkeParking!") : print("Sorry, the check-in failed")
        
        return onFinish(result.0)
    }
    
    mutating func checkOutVehicle(_ plate: String, onSuccess: (Int) -> Void, onError: () -> Void) {
        
        if let vehicle = vehicles.first(where: { $0.plate == plate }){
            vehicles.remove(vehicle)
            let fee = calculateFee(vehicle.parkedTime, vehicle.type, vehicle.hasDiscountCard)
            print("Your fee is $\(fee). Come back soon")
            resume = (resume.totalVehicle + 1,resume.totalFee + fee)
            return onSuccess(fee)
        }
        else {
            print("Sorry, the check-out failed")
            return onError()
        }
    }
    
    private func calculateFee(_ parkedTime:Int , _ type:VehicleType,_ hasDiscountCard:Bool) -> Int{
        var fee : Int = 0
        if(parkedTime/60 <= 2){
            fee = type.tarifa
        }
        else{
            let bloks = Int((Double(parkedTime - 120)/15.0).rounded(.up))
            fee = (bloks * 5 + type.tarifa)
        }
        
        if hasDiscountCard {
            fee = Int((Double(fee)*0.85)) //.rounded(.up)
        }
        return fee
    }
    
    func getResume(){
        print("\(resume.totalVehicle) vehicles have checked out and have earnings of $\(resume.totalFee)")
    }
}



struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date = Date()
    let discountCard: String?
    
    var hasDiscountCard : Bool{
        return discountCard != nil
    }
    
    var parkedTime : Int {
        get{
            return Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

enum VehicleType{
    case car
    case miniBus
    case bus
    case moto
    
    var tarifa: Int {
      switch self {
      case .car: return 20
      case .moto: return 15
      case .miniBus: return 25
      case .bus: return 30
      }
    }
}


///

var alkeParking = Parking()

var vehiclesTemp : [Vehicle] = []
vehiclesTemp.append(Vehicle(plate: "AA111AA", type: VehicleType.car, discountCard: "DISCOUNT_CARD_001"))
vehiclesTemp.append(Vehicle(plate: "B222BBB", type: VehicleType.moto, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "CC333CC", type: VehicleType.miniBus, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "DD444DD", type: VehicleType.bus, discountCard: "DISCOUNT_CARD_002"))
vehiclesTemp.append(Vehicle(plate: "AA111AA1", type: VehicleType.car, discountCard: "DISCOUNT_CARD_001"))
vehiclesTemp.append(Vehicle(plate: "B222BBB1", type: VehicleType.moto, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "CC333CC1", type: VehicleType.miniBus, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "DD444DD1", type: VehicleType.bus, discountCard: "DISCOUNT_CARD_002"))
vehiclesTemp.append(Vehicle(plate: "AA111AA2", type: VehicleType.car, discountCard: "DISCOUNT_CARD_001"))
vehiclesTemp.append(Vehicle(plate: "B222BBB2", type: VehicleType.moto, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "CC333CC2", type: VehicleType.miniBus, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "DD444DD2", type: VehicleType.bus, discountCard: "DISCOUNT_CARD_002"))
vehiclesTemp.append(Vehicle(plate: "AA111AA3", type: VehicleType.car, discountCard: "DISCOUNT_CARD_001"))
vehiclesTemp.append(Vehicle(plate: "B222BBB3", type: VehicleType.moto, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "CC333CC3", type: VehicleType.miniBus, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "DD444DD3", type: VehicleType.bus, discountCard: "DISCOUNT_CARD_002"))
vehiclesTemp.append(Vehicle(plate: "AA111AA4", type: VehicleType.car, discountCard: "DISCOUNT_CARD_001"))
vehiclesTemp.append(Vehicle(plate: "B222BBB4", type: VehicleType.moto, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "CC333CC4", type: VehicleType.miniBus, discountCard: nil))
vehiclesTemp.append(Vehicle(plate: "DD444DD4", type: VehicleType.bus, discountCard: "DISCOUNT_CARD_002"))
vehiclesTemp.append(Vehicle(plate: "EXTRA21", type: VehicleType.bus, discountCard: "DISCOUNT_CARD_002"))


vehiclesTemp.forEach{
    alkeParking.checkInVehicle($0) { result in
        print(result)
    }
}

alkeParking.checkOutVehicle("DD444DD4") { tarifa in
    print("I paid \(tarifa)")
} onError: {
    print("ERROR")
}

alkeParking.getResume()
alkeParking.listVehicles
