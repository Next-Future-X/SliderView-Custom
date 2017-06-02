//
//  ViewController.swift
//  自定义sliderView
//
//  Created by 袁向阳 on 17/5/22.
//  Copyright © 2017年 YXY.cn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        tableView.backgroundColor = UIColor.lightGrayColor()
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        let headerView = YXYCustomSliderView(frame: CGRectMake(0, 0, kScreenWidth, 60 * kScaleOn375Width), MaxValue: 20000, MinValue: 0)
        tableView.tableFooterView = headerView
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("dd")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "dd")
        }
        cell?.backgroundColor = UIColor.orangeColor()
        return cell!
    }
}
