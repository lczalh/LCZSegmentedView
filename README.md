# LCZSegmentedView
滚动菜单
![Image text](https://github.com/824092805/LCZSegmentedView/blob/master/LCZSegmentedView/ShowPicture/lanmu.png)

使用方法
  ```
  // 配置栏目
  let titles: Array<String> = ["推荐","VIP","小说","直播","儿童","广播","精品","相声","人文","历史","段子","音乐"]
  // 创建LCZSegmentedView      
  let homeEntryView = LCZSegmentedView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), titles: titles, menuScrollViewFrame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 40), foreAndAftSpacing: 15, buttonSpacing: 20)
  self.view.addSubview(homeEntryView)
  homeEntryView.selectedColor = UIColor.red
  homeEntryView.fontSize = UIFont.systemFont(ofSize: 12)
  // 配置控制器      
  var arr: Array<UIViewController> = []
  for _ in 0 ..< titles.count {
      let vc = UIViewController()
      self.addChild(vc)
      arr.append(vc)
  }
        
  homeEntryView.viewControllers = arr
  ```
