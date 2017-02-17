//
//  AHMineViewController.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit
import YYWebImage

class AHMineViewController: BaseViewController {
    
    // MARK: - property
    // 收藏的文章的个数
    fileprivate var collectedCount: Int?
    
    fileprivate var titlesArray = [[""], ["我的收藏"], ["分享应用", "意见反馈"], ["设置"]]
    
    // MARK: - control
    fileprivate lazy var tableView: UITableView = {
        let tabelView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreen_W, height: kScreen_H - kNavBarHeight), style: .grouped)
        tabelView.backgroundColor = UIColorMainBG
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.contentInset.bottom = kBottomBarHeight
        return tabelView
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        sendRequest()
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - event && methods
    fileprivate func setupUI() {
        view.addSubview(tableView)
        
        setNavigationBarStyle(BarColor: UIColor.white, backItemColor: .blue)
    }
    
    func settingAction() {
        let settingVC = AHSettingViewController()
        settingVC.logoutClouse = {
            let loginVC = AHLoginViewController()
            let nav = UINavigationController.init(rootViewController: loginVC)
            // 不要用self去present, 不然会报下面的警告
            // Presenting view controllers on detached view controllers is discouraged
            self.navigationController!.present(nav, animated: true, completion: nil)
        }
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    // 网络请求
    fileprivate func sendRequest() {
        if User.info == nil {
            self.collectedCount = 0
            self.tableView.reloadData()
            return
        }
        
        let query: BmobQuery = BmobQuery(className: "Collect")
        query.whereKey("userId", equalTo: User.info?.objectId)
        query.countObjectsInBackground { (count, error) in
            if error != nil { AHLog(error!); return }
            self.collectedCount = (Int)(count)
            self.tableView.reloadData()
        }
    }
    
    // 编辑个人主页
    fileprivate func showPersonalPage() {
        if User.info == nil {
            let loginVC = AHLoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            present(nav, animated: true, completion: nil)
            return
        }
        
        let vc = AHPersonalPageViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 我的收藏
    fileprivate func pushMyViewCollection() {
        if User.info == nil {
            let loginVC = AHLoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            present(nav, animated: true, completion: nil)
            return
        }
        
        let vc = AHCollectViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 分享应用
    fileprivate func shareApp() {
        
    }
    
    // 意见反馈
    fileprivate func pushFeedbackViewCollection() {
        let vc = AHFeedbackViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AHMineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if User.info == nil { // 未登录
                let cell = AHNoLoginCell.cellWithTableView(tableView)
                cell.selectionStyle = .none
                return cell
            } else { // 已登录
                let cell = AHUserCell.cellWithTableView(tableView)
                cell.accessoryType = .disclosureIndicator
                cell.userInfo = User.info
                return cell
            }
        } else { // 我的收藏
            let cell = cellForValue1(WithIndex: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 { // 个人主页
            showPersonalPage()
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: // 我的收藏
                pushMyViewCollection()
            default: break
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0: // 分享应用
                shareApp()
            case 1: // 意见反馈
                pushFeedbackViewCollection()
            default: break
            }
        } else if indexPath.section == 3 { // 设置
            settingAction()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return User.info == nil ? 100 : 90
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        default:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    fileprivate func cellForValue1(WithIndex indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mineCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "mineCell")
            cell!.accessoryType = .disclosureIndicator
            cell!.textLabel?.textColor = UIColorTextBlock
        }
        
        cell!.textLabel?.text = titlesArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 1 && indexPath.row == 0 { // 我的收藏
            if let count = collectedCount {
                if count == 0 {
                    cell!.detailTextLabel?.text = ""
                } else {
                    cell!.detailTextLabel?.text = "\(count) "
                }
            }
        }
        return cell!
    }
    
}
