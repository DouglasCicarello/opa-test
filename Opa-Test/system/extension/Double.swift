import UIKit




extension Double {
    
    
    
    
    // Get String With Currency Symbol
    func moneyFormatWithCurrencySimbol() -> String {
        
        let formatter           = NumberFormatter.init();
        formatter.locale        = Locale.init(identifier: "pt_BR");
        formatter.numberStyle   = NumberFormatter.Style.currency;
        
        if let string = formatter.string(from: NSNumber.init(value: self)) {
            return string;
        }
        else {
            return "";
        }
        
    }
    
    
    
    
}
