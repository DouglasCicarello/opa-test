import Foundation
import UIKit




extension UIImageView {
    
    
    
    
    // Load image from URL or CACHE FILE
    func loadFromUrl(url:String, contentMode:UIViewContentMode?, blankImage:Bool=true) {
        if url != "" {
            
            let name = url.prepareForCache()
            
            // Check local file
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!;
            let fileManager = FileManager.default;
            let imagePath   = "\(path)/\(PATH_CACHE_IMAGE)\(name)";
            if fileManager.fileExists(atPath: imagePath) {
                self.image = UIImage(contentsOfFile: imagePath)
                
                if let contentMode = contentMode {
                    self.contentMode = contentMode;
                }
            }
            else {
                
                if blankImage {
                    self.image = UIImage.init(named: "");
                }
                
                let session = URLSession.shared;
                let conn = session.dataTask(with: URL.init(string: url)!, completionHandler: { (data, response, error) in
                    
                    if error == nil {
                        
                        if let data = data {
                            let downloaded = UIImage.init(data: data);
                            
                            // Save in cache
                            fileManager.createFile(atPath: imagePath, contents: data, attributes: nil);
                            
                            // Show
                            DispatchQueue.main.async {
                                self.image = downloaded;
                                if let contentMode = contentMode {
                                    self.contentMode = contentMode;
                                }
                            }
                        }
                    }
                });
                
                conn.resume();
            }
        }
        else {
            if blankImage {
                self.image = UIImage.init(named: "");
            }
        }
    }
    
    
    
    
}
