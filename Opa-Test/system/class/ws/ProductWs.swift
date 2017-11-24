import Foundation





class ProductWs : Ws {
    
    
    
    
    
    // Construct
    override init() {
        super.init();
        
        self.identifier = "ProductWs";
    }
    
    
    
    
    
    // List
    func list() {
        
        super.identifier += ".List";
        super.get(url: "Product/Get");
        
    }
    
    
    
    
}
