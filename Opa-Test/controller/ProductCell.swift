import Foundation
import UIKit




class ProductCell : UITableViewCell {
    
    
    
    
    // Var's 
    @IBOutlet var productImage:UIImageView!
    @IBOutlet var productName:UILabel!
    @IBOutlet var productPrice:UILabel!
    
    
    
    
    // Layout subview
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.productImage.layer.cornerRadius    = self.productImage.bounds.width/2
        self.productImage.layer.masksToBounds   = true
    }
    
    
    
    
    // Configure
    func configure(productUi:ProductUi) {
        
        self.productImage.loadFromUrl(url: productUi.getImage(), contentMode: .scaleAspectFill)
        self.productName.text   = productUi.getName()
        self.productPrice.text  = productUi.getPriceWithMoneyFormat()
        
    }
    
    
    
    
    
}
