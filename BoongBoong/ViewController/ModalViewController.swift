//
//  ModalViewController.swift
//  BoongBoong
//
//  Created by 한수빈 on 4/15/24.
//

//
//  ModalViewController.swift
//  BoongBoong
//
//  Created by 한수빈 on 4/13/24.
//

import UIKit

class ModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        lblTitle?.text = "강서구 화곡동"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func oilBankNameBtnTapped(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoOilBank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("델리겟호출")
        let cell = tableView.dequeueReusableCell(withIdentifier: "oilbank", for: indexPath)
        let oilBank = infoOilBank[indexPath.row]
        
        print(oilBank)
        
        let logo = cell.viewWithTag(11) as? UIImageView

        let oilBankName = cell.viewWithTag(21) as? UIButton
        let addr = cell.viewWithTag(22) as? UILabel
        let gasoline = cell.viewWithTag(23) as? UILabel
        let diesel = cell.viewWithTag(24) as? UILabel
        let high = cell.viewWithTag(25) as? UILabel
        
        let dieselTitle = cell.viewWithTag(2) as? UILabel
        let gasolineTitle = cell.viewWithTag(1) as? UILabel
        let highTitle = cell.viewWithTag(3) as? UILabel
        
        let imgName = oilBank.pollDivCo
        logo!.image = UIImage(named: imgName)
        
        oilBankName?.setTitle(oilBank.osNm, for: .normal)
        addr?.text = oilBank.newAdr
        diesel?.text = "\(oilBank.oilPrice[0].price)원"
        gasoline?.text = "\(oilBank.oilPrice[1].price)원"
        high?.text = "-원"
        if oilBank.oilPrice.last?.prodcd == "B034" {
            high?.text = "\(oilBank.oilPrice[2].price)원"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let currentIndex = tableView.indexPathForSelectedRow?.row else { return }
        
        
        let selectedOilBank = infoOilBank[currentIndex]
        
        if let target = segue.destination as? OilBankDetailViewController {
            target.oilBankInfo = selectedOilBank
        }
        
    }
    

}


