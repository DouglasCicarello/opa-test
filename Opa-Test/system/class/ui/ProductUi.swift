import Foundation



class ProductUi {
    
    
    
    
    // Var's
    private var id:Int
    private var name:String
    private var price:Double
    private var image:String
    
    
    
    
    // Construct
    init() {
        self.id     = -1
        self.name   = ""
        self.price  = 0.0
        self.image  = ""
    }
    convenience init(dict:NSDictionary) {
        self.init()
        
        if let _id = dict.value(forKey: "Id") as? Int {
            self.id = _id
        }
        if let _name = dict.value(forKey: "Name") as? String {
            self.name = _name
        }
        if let _price = dict.value(forKey: "Price") as? Double {
            self.price = _price
        }
        if let _image = dict.value(forKey: "Image") as? String {
            self.image = _image
        }
    }
    
    
    
    
    // Validate
    func isValid() -> Bool {
        
        if self.id <= 0 {
            return false
        }
        if self.name == "" {
            return false
        }
        
        return true;
    }
    
    
    
    
    // Get's
    func getId() -> Int {
        return self.id
    }
    func getName() -> String {
        return self.name
    }
    func getPrice() -> Double {
        return self.price
    }
    func getPriceWithMoneyFormat() -> String {
        return self.price.moneyFormatWithCurrencySimbol()
    }
    func getImage() -> String {
        return self.image
    }
    
    
    
    
}
