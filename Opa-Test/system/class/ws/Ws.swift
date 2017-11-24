import Foundation;




// Status Code
enum WsStatus {
    case Ok
    case Created
    case Accepted
    case NoContent
    case NotModified
    case BadRequest
    case Unauthorized
    case Forbidden
    case NotFound
    case MethodNotAllowed
    case RequestTimeOut
    case InternalServerError
    case Undefined
    case NoInternet
    case Conflict
}





// Delegate
protocol WsDelegate {
    func wsFinishedWithSuccess(identifier: String, sender: NSDictionary, status: WsStatus);
    func wsFinishedWithError(identifier: String, error: String, status: WsStatus);
    func wsPercentageUpdate(identifer: String, percentage: Int);
}





class Ws : NSObject, URLSessionDelegate {
    
    
    
    
    // Var's
    let _timeout              = WS_TIME_OUT;
    var identifier: String    = "";
    private var _params       = [String]();
    private var _values       = [String]();
    private var _data         = [String]();
    private var _data_value   = [NSData]();
    private var _data_format  = [String]();
    private var _status       = -1;
    private var _header       = [String]();
    private var _header_value = [String]();
    var delegate: WsDelegate?;
    var json:NSDictionary?;
    
    
    
    
    
    // Constructor
    override init() {
        super.init();
    }
    
    
    
    
    
    // Start
    private func start(httpMethod:String, url:String) {
        
        var request             = URLRequest.init(url: URL.init(string: "\(WS_BASE_URL)\(WS_PATH_URL)\(url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")!);
        request.httpMethod      = httpMethod;
        request.timeoutInterval = _timeout;
        
        
        if self._header.count > 0 {
            for i in 0 ..< self._header.count {
                print("\(self._header[i]):\(self._header_value[i])");
                request.addValue(self._header_value[i], forHTTPHeaderField: self._header[i]);
            }
        }
        
        
        // Json
        if httpMethod == "JSON" {
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type");
            request.httpMethod = "POST";
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: self.json!, options: .prettyPrinted);
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
        // Post
        if (httpMethod=="POST") {
            
            let body     = NSMutableData();
            let boundary = "---------------------------14737809831466499882746641449";
            
            let headers = [
                "content-type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ];
            request.allHTTPHeaderFields = headers;
            
            
            // Files
            for i in 0 ..< _data.count {
                
                let timestamp = Date.init().timeIntervalSince1970;
                
                body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Disposition: attachment; name=\"\(_data[i])\"; filename=\"\(timestamp).\(_data_format[i])\"\r\n".data(using: String.Encoding.utf8)!);
                body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!);
                body.append(_data_value[i] as Data);
                body.append("\r\n".data(using: String.Encoding.utf8)!);
            }
            
            // Params
            if _params.count > 0 {
                for i in 0 ..< _params.count {
                    print("\(_params[i]):\(_values[i])");
                    body.append("\(i == 0 ? "" : "&")\(_params[i])=\(_values[i])".data(using: String.Encoding.utf8)!);
                }
            }
            
            request.httpBody = body as Data;
        }
        
        
        
        let configuration = URLSessionConfiguration.default;
        let session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: nil);
        let conn = session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                self._status = response.statusCode;
            }

            if error == nil {
                do {
                    if let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        DispatchQueue.main.async {
                            self.delegate?.wsFinishedWithSuccess(identifier: self.identifier, sender: jsonResult, status: self.getStatus());
                         }
                    }
                    else {
                        if let jsonResult: NSMutableArray = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableArray {
                            let dict = NSMutableDictionary.init();
                            dict.setValue(jsonResult, forKey: "result");
         
                            DispatchQueue.main.async {
                                self.delegate?.wsFinishedWithSuccess(identifier: self.identifier, sender: dict, status: self.getStatus());
                            }
                        }
                    }
                }
                catch let error as NSError {
                    DispatchQueue.main.async {
                        if error.code == NSURLErrorNotConnectedToInternet {
                            self.delegate?.wsFinishedWithError(identifier: self.identifier, error: "Sem conexão com a internet", status: WsStatus.NoInternet);
                        }
                        else {
                            self.delegate?.wsFinishedWithError(identifier: self.identifier, error: error.localizedDescription, status: self.getStatus());
                        }
                    }
                }
            }
        }
        conn.resume();
        
    }
    func get(url:String) {
        self.start(httpMethod: "GET", url: url);
    }
    func post(url:String) {
        self.start(httpMethod: "POST", url: url);
    }
    func json(url:String) {
        self.start(httpMethod: "JSON", url: url);
    }
    func _delete(url:String) {
        self.start(httpMethod: "DELETE", url: url);
    }
    func patch(url:String) {
        self.start(httpMethod: "PATCH", url: url);
    }
    
    
    
    
    
    // Get WsStatus fo code
    private func getStatus() -> WsStatus {
        
        if self._status == 200 { return .Ok; }
        if self._status == 201 { return .Created; }
        if self._status == 202 { return .Accepted; }
        if self._status == 204 { return .NoContent; }
        if self._status == 304 { return .NotModified; }
        if self._status == 400 { return .BadRequest; }
        if self._status == 401 { return .Unauthorized; }
        if self._status == 403 { return .Forbidden; }
        if self._status == 404 { return .NotFound; }
        if self._status == 405 { return .MethodNotAllowed; }
        if self._status == 408 { return .RequestTimeOut; }
        if self._status == 500 { return .InternalServerError; }
        if self._status == 409 { return .Conflict; }
        
        return .Undefined;
    }
    
    
    
    
    
    // Add's
    func addParam(name:String, value:String) {
        _params.append(name);
        _values.append(value);
    }
    func addData(name:String, data:NSData, format:String) {
        _data.append(name);
        _data_value.append(data);
        _data_format.append(format);
    }
    func addHeader(name:String, value:String) {
        self._header.append(name);
        self._header_value.append(value);
    }
    


}
