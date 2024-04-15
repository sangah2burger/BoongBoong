//
//  OilBankDetailViewController.swift
//  BoongBoong
//
//  Created by 한수빈 on 4/12/24.
//

import UIKit
import MapKit
import KakaoMapsSDK

class OilBankDetailViewController: UIViewController, MapControllerDelegate {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblYNInfo: UILabel!
    @IBOutlet weak var squreView1: UIView!
    @IBOutlet weak var squreView2: UIView!
    @IBOutlet weak var squreView3: UIView!
    @IBOutlet weak var lblGasPrice: UILabel!
    @IBOutlet weak var lblGapOfGasPrice: UILabel!
    @IBOutlet weak var lblDieselPrice: UILabel!
    @IBOutlet weak var lblGapOfDieselPrice: UILabel!
    @IBOutlet weak var lblHighPrice: UILabel!
    @IBOutlet weak var lblGapOfHighPrice: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblAddr: UILabel!
    @IBOutlet weak var lblTel: UILabel!
    
    var oilBankInfo : InfoOilBankList? = InfoOilBankList(uniID: "A0000520", pollDivCo: "SOL", gpollDivCo: "", osNm: "하이웨이주유소", vanAdr: "서울특별시 강서구 화곡동 1125", newAdr: "서울특별시 강서구 공항대로 432(화곡동)", tel: "02-2605-4000", siguncd: "0115", lpgYn: "N", maintYn: "N", carWashYn: "N", kpetroYn: "N", cvsYn: "Y", gisXCoor: 299017.76990, gisYCoor: 550893.57210,oilPrice: [OilPriceOfOilBank(prodcd: "B027", price: 1796, tradeDt: "20240412", tradeTm: "105931"),OilPriceOfOilBank(prodcd: "D047", price: 1681, tradeDt: "20240412", tradeTm: "105843"),OilPriceOfOilBank(prodcd: "B034", price: 1896, tradeDt: "20240412", tradeTm: "105940")])
    var oilAvgPrice : OilAvgPriceModel? = OilAvgPriceModel(oilAvgresult: OilAvgResult(oilPrice: [
        OilPrice(tradeDt: "20240414", prodcd: "B027", prodnm: "휘발유", avgPrice: "1687.73", diff: "+2.35"),
        OilPrice(tradeDt: "20240414", prodcd: "D047", prodnm: "자동차용경유", avgPrice: "1558.47", diff: "+1.10"),
        OilPrice(tradeDt: "20240414", prodcd: "B034", prodnm: "고급휘발유", avgPrice: "1930.84", diff: "+1.08")]))
    
    var mapContainer: KMViewContainer?
    var mapController: KMController?
    var selectedLong : Double = 126.8461
    var selectedLat : Double = 37.5358
    let infoYN = ["세차장", "편의점", "경정비", "품질인증"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: View 모서리 둥글게 만들기
        squreView1.layer.cornerRadius = 10
        squreView2.layer.cornerRadius = 10
        squreView3.layer.cornerRadius = 10
        
        if let oilBank = oilBankInfo {
            lblName.text = oilBank.osNm
            lblAddr.text = oilBank.newAdr
            lblTel.text = oilBank.tel
            lblGapOfGasPrice.text = "-원"
            lblGapOfDieselPrice.text = "-원"
            lblGapOfHighPrice.text = "-원"
            setLogoImg(for: oilBank)
            
            //MARK: 유가 정보, 현 시세 대비 GAP
            var gasGap : String?
            var dieselGap : String?
            var highGap : String?
            for oilPrice in oilBank.oilPrice {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                print(formatter)
                switch oilPrice.prodcd {
                case "B027" :
                    lblGasPrice.text = "\(formatter.string(from: NSNumber(value: oilPrice.price)) ?? "")원"
                    gasGap = calcPriceGap(currentPrice: oilPrice.price, avgPrice: oilAvgPrice?.oilAvgresult.oilPrice.first { $0.prodcd == "B027" }?.avgPrice)
                case "D047" :
                    lblDieselPrice.text = "\(formatter.string(from: NSNumber(value: oilPrice.price)) ?? "")원"
                    dieselGap = calcPriceGap(currentPrice: oilPrice.price, avgPrice: oilAvgPrice?.oilAvgresult.oilPrice.first { $0.prodcd == "D047" }?.avgPrice)
                case "B034" :
                    lblHighPrice.text = "\(formatter.string(from: NSNumber(value: oilPrice.price)) ?? "")원"
                    highGap = calcPriceGap(currentPrice: oilPrice.price, avgPrice: oilAvgPrice?.oilAvgresult.oilPrice.first { $0.prodcd == "B034" }?.avgPrice)
                default :
                    break
                }
            }
            if let gasGap = gasGap {
                lblGapOfGasPrice.text = "\(gasGap)원"
                gapColor(label: lblGapOfGasPrice, gap: gasGap)
            } else {
                lblGapOfGasPrice.text = "-원"
            }
            
            if let dieselGap = dieselGap {
                lblGapOfDieselPrice.text = "\(dieselGap)원"
                gapColor(label: lblGapOfDieselPrice, gap: dieselGap)
            } else {
                lblGapOfDieselPrice.text = "-원"
            }
            
            if let highGap = highGap {
                lblGapOfHighPrice.text = "\(highGap)원"
                gapColor(label: lblGapOfHighPrice, gap: highGap)
            } else {
                lblGapOfHighPrice.text = "-원"
            }
        }
        
        //MARK: infoYNLabel
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal // 수평 스택뷰로 설정
        stackView.spacing = 5
        view.addSubview(stackView)
        
        var previousLabel: UILabel?
        let color = UIColor(red: 55/255, green: 202/255, blue: 236/255, alpha: 1.0)
        let colors : [UIColor] = [color,color,color,color]
        
        for (index, text) in infoYN.enumerated() {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = text
            label.font = lblYNInfo.font
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.backgroundColor = colors[index % colors.count]
            view.addSubview(label)
            
            // 첫 번째 라벨의 경우 이전 라벨이 없으므로 스택뷰에 직접 추가
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: lblYNInfo.topAnchor),
                label.heightAnchor.constraint(equalToConstant: 20),
                label.widthAnchor.constraint(equalToConstant: 50)
            ])

            if let previousLabel = previousLabel {
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: previousLabel.trailingAnchor, constant: stackView.spacing),
                    label.widthAnchor.constraint(equalTo: previousLabel.widthAnchor), // 이전 라벨의 너비와 동일하게 설정
                    label.heightAnchor.constraint(equalTo: previousLabel.heightAnchor) // 이전 라벨의 높이와 동일하게 설정
                ])
            }
            // 스택뷰에 라벨 추가
            stackView.addArrangedSubview(label)
            previousLabel = label
        }
        
        // 스택뷰의 레이아웃 설정
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: lblYNInfo.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: lblYNInfo.leadingAnchor)
        ])
    }
    
    func configureLabels() {
        let attributes: [(String,Bool)] = [("세차장"), oil]
    }
    
    func calcPriceGap(currentPrice: Double?, avgPrice: String?) -> String? {
        guard let currentPrice = currentPrice, let avgPrice = Double(avgPrice ?? "") else { return nil
        }
        let gap = Int(currentPrice - avgPrice)
        return gap >= 0 ? "+\(gap)" : "\(gap)"
    }
    
    func gapColor(label: UILabel, gap: String?) {
        guard let gapString = gap, let gapInt = Int(gapString) else { return }
        let gap = "\(gapString)"
        let unitTxT = "원"
        if gapInt > 0 {
            label.textColor = .red
        } else if gapInt < 0 {
            label.textColor = .blue
        } else {
            label.textColor = .black
        }
        let attributedText = NSMutableAttributedString(string: gap + unitTxT)
        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: gap.count, length: unitTxT.count))
        label.attributedText = attributedText
    }
    
    //MARK: 주유소 로고
    func setLogoImg(for oilBankInfo: InfoOilBankList) {
        let imgName = oilBankInfo.pollDivCo
        imgLogo.image = UIImage(named: imgName)
    }
    
    //MARK: 지도 넣기 개큰시도
    func addViews() {
        let selectedPosition : MapPoint = MapPoint(longitude: selectedLong, latitude: selectedLat)
        let mapviewInfo : MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: selectedPosition, defaultLevel: 15, enabled: true)
        mapController?.addView(mapviewInfo)
    }
}
