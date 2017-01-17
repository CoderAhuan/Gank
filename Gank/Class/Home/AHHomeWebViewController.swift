//
//  AHHomeWebViewController.swift
//  Gank
//
//  Created by AHuaner on 2017/1/7.
//  Copyright © 2017年 CoderAhuan. All rights reserved.
//

import UIKit

class AHHomeWebViewController: BaseWebViewController {
    
    var homeGankModel: AHHomeGankModel?
    
    // 弹窗
    fileprivate lazy var moreView: AHMoreView = {
        let moreView = AHMoreView.moreView()
        let W = kScreen_W / 2
        moreView.frame = CGRect(x: kScreen_W - W - 3, y: 50, width: W, height: 147)
        return moreView
    }()
    
    // 蒙版
    fileprivate var maskBtnView: UIButton = {
        let maskBtnView = UIButton()
        maskBtnView.frame = kScreen_BOUNDS
        maskBtnView.backgroundColor = UIColor.clear
        return maskBtnView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        self.title = "详细内容"
        
        let oriImage = UIImage(named: "icon_more")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: oriImage, style: .plain, target: self, action: #selector(AHClassWebViewController.moreClick))
        
        maskBtnView.addTarget(self, action: #selector(AHClassWebViewController.dismissMoreView), for: .touchUpInside)
        
        moreView.tableViewdidSelectClouse = { [unowned self] (indexPath) in
            switch indexPath.row {
            case 0: // 收藏
                ToolKit.showSuccess(withStatus: "收藏成功")
            case 1: // 分享
                ToolKit.showSuccess(withStatus: "收藏成功")
            case 2: // Safari打开
                guard let urlString = self.urlString else { return }
                guard let url = URL(string: urlString) else { return }
                UIApplication.shared.openURL(url)
            default: break
            }
        }
    }
    
    func moreClick() {
        kWindow?.addSubview(maskBtnView)
        kWindow?.addSubview(moreView)
    }
    
    func dismissMoreView() {
        maskBtnView.removeFromSuperview()
        moreView.removeFromSuperview()
    }
}
