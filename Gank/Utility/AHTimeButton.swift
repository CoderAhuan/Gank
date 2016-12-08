//
//  AHTimeButton.swift
//  Gank
//
//  Created by CoderAhuan on 2016/12/8.
//  Copyright © 2016年 CoderAhuan. All rights reserved.
//

import UIKit

class AHTimeButton: UIButton {
    var time: Int?
    var clickClouse: (() -> Void)?
    var timer: Timer?
    
    init(frame: CGRect, time: Int, clickAction: @escaping () -> Void) {
        super.init(frame: frame)
        self.frame = frame
        self.time = time
        self.clickClouse = clickAction
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setTitle("\(self.time!)s跳过", for: .normal)
        titleLabel?.font = FontSize(size: 12)
        backgroundColor = UIColor.orange
        layer.cornerRadius = self.Height * 0.4
        addTarget(self, action: #selector(AHLaunchViewController.skipAction), for: .touchUpInside)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AHTimeButton.timerAction), userInfo: nil, repeats: true)
    }
    
    func skipAction() {
        timer?.invalidate()
        timer = nil
        if clickClouse != nil {
            clickClouse!()
        }
    }
    
    func timerAction() {
        time = time! - 1
        setTitle("\(self.time!)s跳过", for: .normal)
        if time! <= 0 {
            skipAction()
        }
    }
}
