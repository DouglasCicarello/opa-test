import UIKit;





extension String {
    
    
    
    
    // Prepare for Cache
    func prepareForCache() -> String {
        
        var url = self.replacingOccurrences(of: ":", with: "_2p_");
        url     = url.replacingOccurrences(of: "/", with: "_b_");
        url     = url.replacingOccurrences(of: "&", with: "_e_");
        url     = url.replacingOccurrences(of: "?", with: "");
        url     = url.replacingOccurrences(of: "%", with: "");
        
        return url;
    }



}
