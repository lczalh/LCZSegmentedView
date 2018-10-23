//
//  ViewController.swift
//  LCZSegmentedView
//
//  Created by 刘超正 on 2018/10/23.
//  Copyright © 2018 刘超正. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles: Array<String> = ["推荐","VIP","小说","直播","儿童","广播","精品","相声","人文","历史","段子","音乐"]
        
        let homeEntryView = LCZSegmentedView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), titles: titles, menuScrollViewFrame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40), foreAndAftSpacing: 15, buttonSpacing: 20)
        self.view.addSubview(homeEntryView)
        homeEntryView.selectedColor = UIColor.white
        homeEntryView.fontSize = UIFont.systemFont(ofSize: 12)
        
        var arr: Array<UIViewController> = []
        for _ in 0 ..< titles.count {
            let vc = UIViewController()
            self.addChild(vc)
            arr.append(vc)
        }
        
        homeEntryView.viewControllers = arr
        
        
    }


}

