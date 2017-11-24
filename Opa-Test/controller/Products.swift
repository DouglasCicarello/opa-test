import UIKit




class Products : UIViewController, WsDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    // Var's
    @IBOutlet var table:UITableView!
    @IBOutlet var loading:UIActivityIndicatorView!
    private var list        = [ProductUi]()
    private var isLoading   = false
    private var refresh:UIRefreshControl?
    
    
    
    // Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Var's
        self.table.delegate     = self
        self.table.dataSource   = self
        
        self.refresh = UIRefreshControl()
        self.refresh?.addTarget(self, action: #selector(loadProducts), for: .valueChanged)
        self.table.addSubview(self.refresh!)
        
        self.refresh?.beginRefreshing()
        self.loadProducts()
    }

    
    
    
    // Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Produtos"
    }

    
    
    
    // Load Products
    func loadProducts() {
        
        self.isLoading = true
        
        let productsWs      = ProductWs();
        productsWs.delegate = self;
        productsWs.list();
        
    }
    
    
    
    
    /* ----------------------------------------------------------------------------------------------------------------------------------- *
     * WS DELEGATE                                                                                                                         *
     * ----------------------------------------------------------------------------------------------------------------------------------- */
    func wsPercentageUpdate(identifer: String, percentage: Int) {
        
    }
    func wsFinishedWithError(identifier: String, error: String, status: WsStatus) {
        
        self.isLoading          = false
        self.loading.isHidden   = true
        self.refresh?.endRefreshing()
        
        if identifier == "ProductsWs.List" {
            
        }
        
    }
    func wsFinishedWithSuccess(identifier: String, sender: NSDictionary, status: WsStatus) {
        
        self.isLoading          = false
        self.loading.isHidden   = true
        self.refresh?.endRefreshing()
        
        if identifier == "ProductWs.List" {
            self.list.removeAll()
            
            if status == .Ok {
                if let result = sender.value(forKey: "result") as? NSArray {
                    for object in result {
                        if let dict = object as? NSDictionary {
                            let productUi = ProductUi.init(dict: dict)
                            if productUi.isValid() {
                                self.list.append(productUi)
                            }
                        }
                    }
                }
            }
            self.table.reloadData()
        }
        
    }

    
    
    
    /* ------------------------------------------------------------------------------------------------------------------------------------ *
     * Table View Delegate                                                                                                                  *
     * ------------------------------------------------------------------------------------------------------------------------------------ */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isLoading ? 0 : self.list.count > 0 ? self.list.count : 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.list.count > 0 {
            let productUi = self.list[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell") as! ProductCell
            cell.configure(productUi: productUi)
            
            return cell;
        }
        else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoContentCell") {
                return cell;
            }
        }
        
        return UITableViewCell.init();
    }
    
    
    

}


