//
//  BMPopOverOptionsVC.swift
//  BilliyoClinicalPDN
//
//  Created by Billiyo Health on 10/01/23.
//

import UIKit

class BMPopOverImageOptionsVC:  UIViewController, BMPopOverUsable, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblOptionList: UITableView!
    
    var size: CGSize = {
        return CGSize(width: 60.0, height: 60.0)
    }()
    
    var contentSize: CGSize {
        return size
    }
    
    var popOverBackgroundColor: UIColor? {
        return .clear
    }

    var arrImgOptions = [UIImage]()
    var OnCmpletionHandler : ((_ success : Bool, _ selectedIndex : Int) -> Void)?
    var OnCancel : (()->Void)?
}


// MARK:
// MARK: View Controller Life Cycle Methods
// MARK:

extension BMPopOverImageOptionsVC{
    override func viewDidLoad() {
        self.basicSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //webView.frame = view.bounds
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: Basic View Setup
extension BMPopOverImageOptionsVC{
    
    private func basicSetup(){
        self.registerViewsAndDelegate()
        self.setTheme()
    }
    
    private func registerViewsAndDelegate(){
        self.tblOptionList.register(UINib.init(nibName: "BMImageOptionCell", bundle: nil), forCellReuseIdentifier: "BMImageOptionCell")
        
        self.tblOptionList.delegate = self
        self.tblOptionList.dataSource = self
        
        self.tblOptionList.estimatedRowHeight = 60.0
    }

    private func setTheme(){
        self.view.backgroundColor = MessageTheme.Color.white
    }
}

// MARK: Table View Delegate and Data Source Methods
// MARK:

extension BMPopOverImageOptionsVC {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageConstant.is_Device._iPhone ? 60.0 : 75.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrImgOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BMImageOptionCell", for: indexPath) as! BMImageOptionCell
        cell.imgOption.image = self.arrImgOptions[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissPopover(animated: true, completion: {
            self.OnCmpletionHandler?(false, indexPath.row)
        })
    }
}


