//
//  MyPageViewController.swift
//  idus
//
//  Created by 이재용 on 2020/11/14.
//

import UIKit
import Kingfisher

extension UIView {

    // 원하는 view 둥글게 만들기
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

class MyPageViewController: UIViewController {
    var ProfileDataModel: Profile?

    // UIViewComponets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var bannerView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var floatingButton: UIButton!

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var levelImageView: UIImageView!
    
    // statics
    let titles: [String] = ["친구초대", "이벤트", "공지사항", "고객센터", "About idus"]
    let backgroundViewHeight: CGFloat = 249.0
    let backgroundViewMinHeight: CGFloat = 210.0

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTableViewHeight()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    func setProfile() {
        let ImgURL = String(ProfileDataModel!.profileImageURL)
        let badgeURL = String(ProfileDataModel!.badgeImageURL)
        levelLabel.text = ProfileDataModel?.level
        pointLabel.text = String(ProfileDataModel!.point) + "P"
        couponLabel.text = String(ProfileDataModel!.coupon)
       
        let imgUrl = URL(string: ProfileService.imgUrl)
        let badgeUrl = URL(string: ProfileService.badgeUrl)

        profileImageView.kf.setImage(with: imgUrl)
        levelImageView.kf.setImage(with: badgeUrl)

//            = UIImage.init(named: "mypageImgProfile")
        
        print("--------didididididi-------")
        print(ImgURL)
        print(badgeURL)
        print("--------didididididi-------")

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getProfile()
//        self.scrollView.contentInsetAdjustmentBehavior = .never
        layoutsubviews()
    }

    func layoutsubviews() {
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 50)

        backgroundView.image = UIImage(named: "mypageBgRed")
        bannerView.image = UIImage(named: "mypageImgAd")
  
        floatingButton.setImage(UIImage(named: "mainBtnCart"), for: .normal)

        highlightView.backgroundColor = UIColor(named: "paleSalmon")

        stackView.layer.cornerRadius = 30
        badgeView.layer.cornerRadius = 15
        profileView.layer.cornerRadius = profileView.frame.height / 2
        profileView.layer.borderWidth = 3
        profileView.layer.borderColor = UIColor.init(named: "paleSalmon")?.cgColor

    }

    func setTableViewHeight() {
        tableViewHeight?.constant = tableView.contentSize.height

    }

}

extension MyPageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusable", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
}

extension MyPageViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = self.scrollView.contentOffset.y
        if offset < 0.0 {
            // scrolling up
            backgroundImageViewHeight.constant = backgroundViewHeight - offset
        } else {
            // scrolling down
            var height = backgroundViewHeight - offset
            height = height > backgroundViewMinHeight ? height : backgroundViewHeight
            backgroundImageViewHeight.constant = height
        }

    }

}

extension MyPageViewController {
    
    func getProfile() {
//        ProfileService.shared.getProfile(craft: self)
        
        
        ProfileService.shared.getProfile() { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let response = data as? Profile {
                    self.ProfileDataModel = response
                    
                    self.setProfile()
                    
                    print("호우호우",self.ProfileDataModel)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
            
//        ProfileService.shared.getProfile()
//        {
//            (networkResult) -> (Void) in
//                switch networkResult {
//                case .success(let data):
//                    let response = data as? ProfileData
//                    self.ProfileDataModel = response
//                    self.viewWillAppear(true)
//                    print("========================================")
//                    print(self.ProfileDataModel?.data)
//
//                case .requestErr:
//                    print("requestErr")
//                case .pathErr:
//                    print("pathErr")
//                case .serverErr:
//                    print("serverErr")
//                case .networkFail:
//                    print("networkFail")
//                }
//                }
            }
    
  
        }
    




}
