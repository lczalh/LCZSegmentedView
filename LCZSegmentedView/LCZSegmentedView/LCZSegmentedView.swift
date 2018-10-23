//
//  LCZSegmentedControl.swift
//  XiMaLaYa
//
//  Created by 刘超正 on 2018/10/12.
//  Copyright © 2018年 刘超正. All rights reserved.
//

import UIKit

class LCZSegmentedView: UIView {
    
    var zoomRatio: CGFloat = 0.3 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    /// 标题数组
    public var titles: Array<String> = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 控制器数组
    public var viewControllers: [UIViewController] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 首尾间距
    public var foreAndAftSpacing: CGFloat = 15.0
    
    /// 按钮间距
    private var buttonSpacing: CGFloat = 15.0
    
    /// 当前索引
    public var currentIndex:Int = 0
    
    /// 选中颜色
    public var selectedColor:UIColor = UIColor.red {
        didSet {
            for button in buttons {
                button.setTitleColor(selectedColor, for: .selected)
            }
        }
    }
    
    /// 未选中颜色
    public var normalColor:UIColor = UIColor.black {
        didSet {
            for button in buttons {
                button.setTitleColor(normalColor, for: .normal)
            }
        }
    }
    
    /// 字体大小
    public var fontSize: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            for button in buttons {
                button.titleLabel?.font = fontSize
            }
        }
    }
    
    /// 下标视图
    public lazy var subscriptView = UIView()
    
    /// 下标高度
    public var subscriptHeight:CGFloat = 2 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 下标距离底部距离
    public var subscriptBottomPadding:CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// 储存所有button
    private var buttons: Array<UIButton> = []
    
    /// 菜单视图
    public lazy var menuScrollView: UIScrollView = {
        let menuScrollView = UIScrollView()
        menuScrollView.showsVerticalScrollIndicator = false
        menuScrollView.showsHorizontalScrollIndicator = false
        return menuScrollView
    }()
    
    /// 内容视图
    public lazy var contentScrollView: UIScrollView = {
        let contentScrollView = UIScrollView(frame: self.bounds)
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.delegate = self
        return contentScrollView
    }()
    
    /// 记录滚动时的左右索引
    private var leftIndex:Int = 0
    private var rightIndex:Int = 0
    
    /// 初始化视图
    ///
    /// - Parameters:
    ///   - frame: 视图总大小
    ///   - titles: 标题数组
    ///   - menuScrollViewFrame: 菜单Frame
    ///   - foreAndAftSpacing: 首尾间距
    ///   - buttonSpacing: 按钮间距
    init(frame: CGRect, titles: Array<String>, menuScrollViewFrame: CGRect, foreAndAftSpacing: CGFloat, buttonSpacing: CGFloat) {
        self.foreAndAftSpacing = foreAndAftSpacing
        self.buttonSpacing = buttonSpacing
        self.titles = titles
        super.init(frame: frame)
        menuScrollView.frame = menuScrollViewFrame
        self.addSubview(contentScrollView)
        self.addSubview(menuScrollView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 每次调用 先移除原有按钮并清空按钮数组
        if buttons.count > 0 {
            for (_,button) in buttons.enumerated() {
                button.removeFromSuperview()
            }
            currentIndex = 0
        }
        buttons.removeAll()
        
        setupMenuScrollView()
        setupIndicatorView()
       // setupViewController()
        lazyViewController(index: currentIndex)
    }
    
    /// 配置菜单
    private func setupMenuScrollView() {
        // 记录
        let spacing = foreAndAftSpacing
        
        // 循环创建按钮
        for (index,title) in titles.enumerated() {
            let button = UIButton.init()
            button.setTitleColor(selectedColor, for: .selected)
            button.setTitleColor(normalColor, for: .normal)
            button.reversesTitleShadowWhenHighlighted = true
            button.titleLabel?.font = fontSize
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            menuScrollView.addSubview(button)
            
            // 获取文字宽度
            let size = (title as NSString).size(withAttributes: [NSAttributedString.Key.font:fontSize])
            button.frame = CGRect(x: foreAndAftSpacing, y: 0, width: size.width, height: self.menuScrollView.frame.size.height)
            
            foreAndAftSpacing += size.width + buttonSpacing
        
            // 默认选中第一个
            if currentIndex == index {
                button.isSelected = true
                button.transform = CGAffineTransform.init(scaleX: 1 + self.zoomRatio, y: 1 + self.zoomRatio)
            }
            // 存入数组
            buttons.append(button)
            // 添加下标视图
            menuScrollView.addSubview(subscriptView)
            subscriptView.backgroundColor = selectedColor
            // 设置菜单视图的总偏移
            menuScrollView.contentSize = CGSize(width: foreAndAftSpacing + buttonSpacing, height: menuScrollView.frame.size.height)
        }
        foreAndAftSpacing = spacing
    }
    
    /// 配置下标
    private func setupIndicatorView() {
        var frame = buttons[currentIndex].frame
        frame.origin.y = menuScrollView.frame.height - subscriptBottomPadding - subscriptHeight
        frame.size.height = subscriptHeight
        let text = titles[currentIndex]
        let size = (text as NSString).size(withAttributes: [NSAttributedString.Key.font:fontSize])
        frame.origin.x = frame.midX - size.width/2
        frame.size.width = size.width
        subscriptView.frame = frame
    }
    
//    /// 配置控制器
//    private func setupViewController() -> () {
//        for (index, viewController) in viewControllers.enumerated() {
//            viewController.view.frame = CGRect(x: CGFloat(index) * self.frame.size.width, y: 0, width: self.frame.size.width, height: contentScrollView.frame.size.height)
//
//            contentScrollView.addSubview(viewController.view)
//        }
//        // 设置滚动视图的总偏移
//        contentScrollView.contentSize = CGSize(width: self.frame.size.width * CGFloat(viewControllers.count), height: 0)
//    }
    
    
    /// 懒加载控制器
    ///
    /// - Parameter index: 当前索引
    private func lazyViewController(index: Int) -> () {
        let viewController = viewControllers[index]
        
        if !viewController.isViewLoaded {
            viewController.view.frame = CGRect(x: CGFloat(index) * self.frame.size.width, y: 0, width: self.frame.size.width, height: contentScrollView.frame.size.height)
            contentScrollView.addSubview(viewController.view)
            // 设置滚动视图的总偏移
            contentScrollView.contentSize = CGSize(width: self.frame.size.width * CGFloat(viewControllers.count), height: 0)
        }
    }
    
    /// 点击按钮响应方法
    ///
    /// - Parameter sender: butotn
    @objc private func buttonClicked(sender: UIButton) -> () {
        // 选中状态则跳出
        if sender.isSelected {
            return
        }
        
        // 修正按钮位置
        correctButtonOffsetPosition(sender: sender)
        
        // 记录上一个按钮索引
        let beforeIndex = currentIndex
        print(buttons.count)
        print(buttons.index(of: sender)!)
        // 获取当前按钮索引
        currentIndex = buttons.index(of: sender)!
        
        // 偏移内容视图
        contentScrollView.contentOffset = CGPoint(x: CGFloat(currentIndex) * self.frame.size.width, y: 0)
        // 更新按钮
        updateButton(beforeIndex: beforeIndex, currentIndex: currentIndex)
        
        // 更新下标
        updateSubscriptView(beforeIndex: beforeIndex, currentIndex: currentIndex)
    }
    
    /// 修正按钮偏移位置
    ///
    /// - Parameter sender: button
    func correctButtonOffsetPosition(sender: UIButton) -> () {
        // 修正偏移位置
        var offsetPoint = menuScrollView.contentOffset;
        offsetPoint.x = sender.center.x - self.frame.size.width / 2;
        //左边超出处理
        if (offsetPoint.x < 0) {
            offsetPoint.x = 0;
        }
        
        let maxX = menuScrollView.contentSize.width - self.frame.size.width - self.buttonSpacing
        
        //右边超出处理
        if (offsetPoint.x > maxX) {
            offsetPoint.x = maxX;
        }
        //设置滚动视图偏移量
        menuScrollView.setContentOffset(offsetPoint, animated: true)
    }
    
    
    /// 更新按钮
    ///
    /// - Parameters:
    ///   - beforeIndex: 上一个按钮索引
    ///   - currentIndex: 当前索引
    private func updateButton(beforeIndex:Int ,currentIndex:Int) {
        self.buttons[beforeIndex].isSelected = false
        self.buttons[currentIndex].isSelected = true
        UIView.animate(withDuration: 0.25, animations: {
            self.buttons[currentIndex].transform = CGAffineTransform.init(scaleX: 1 + self.zoomRatio, y: 1 + self.zoomRatio)
            self.buttons[beforeIndex].transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    /// 更新下标视图
    ///
    /// - Parameters:
    ///   - beforeIndex: 上一个按钮索引
    ///   - currentIndex: 当前索引
    private func updateSubscriptView(beforeIndex:Int ,currentIndex:Int) {
        let beforeButton = buttons[beforeIndex]
        let currentButton = buttons[currentIndex]
        
        // 获取下标视图的frame
        var frame = subscriptView.frame
        // 获取标题大小
        let size = (buttons[currentIndex].titleLabel?.text as NSString?)!.size(withAttributes: [NSAttributedString.Key.font:fontSize])
        frame.size.width = size.width
        
        let finnalFrame = frame
        
        // 获取总距离 前一个按钮宽 + 当前按钮宽 + 间距
        let max = (beforeButton.titleLabel?.text as NSString?)!.size(withAttributes: [NSAttributedString.Key.font:fontSize]).width + (currentButton.titleLabel?.text as NSString?)!.size(withAttributes: [NSAttributedString.Key.font:fontSize]).width +  self.buttonSpacing
        frame.size.width = max
        
        let x = (currentButton.frame.maxX - beforeButton.frame.minX)/2 + beforeButton.frame.minX
        
        // 设置动画
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: .calculationModePaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime:0, relativeDuration: 0.15, animations: {
                self.subscriptView.frame = frame
                self.subscriptView.center = CGPoint(x: x, y: self.subscriptView.center.y)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.15, animations: {
                self.subscriptView.frame = finnalFrame
                self.subscriptView.center = CGPoint(x: currentButton.center.x, y: self.subscriptView.center.y)
            })
            
        }, completion: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate
extension LCZSegmentedView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 计算当前索引
        currentIndex = Int(CGFloat(offset.x) / self.frame.width)
        // 懒加载控制器
        lazyViewController(index: currentIndex)
        
        if buttons.count > 0 {
            // 偏移菜单视图
            correctButtonOffsetPosition(sender: buttons[currentIndex])
        }
        
        if offset.x <= 0 {
            // 左边界
            leftIndex = 0
            rightIndex = leftIndex
        }
        else if (offset.x >= scrollView.contentSize.width - scrollView.frame.width) {
            //右边界
            leftIndex = buttons.count - 1
            rightIndex = leftIndex
        }
        else{
            leftIndex = Int(offset.x / scrollView.frame.width)
            rightIndex = leftIndex + 1
        }
        
        //计算偏移的相对位移
        let relativeLacation = contentScrollView.contentOffset.x / contentScrollView.frame.width - CGFloat(leftIndex)
     
        if relativeLacation == 0 {
            return
        }
        
        updateTitleStyle(relativeLacation, offset)
        updateSubscriptViewStyle(relativeLacation)
    }
    
    /// 更新标题的UI效果
    ///
    /// - Parameters:
    ///   - relativeLacation: 滑动的相对距离
    ///   - offset: 偏移量
    func updateTitleStyle(_ relativeLacation:CGFloat, _ offset: CGPoint) {
        let beforeButton = buttons[leftIndex]
        let currentButton = buttons[rightIndex]
        
        beforeButton.isSelected = relativeLacation <= 0.5
        currentButton.isSelected = relativeLacation > 0.5
        
        let percent = relativeLacation <= 0.5 ? (1-relativeLacation) : relativeLacation
     
        beforeButton.setTitleColor(self.averageColor(fromColor: normalColor, toColor: selectedColor, percent: percent), for: .selected)
        beforeButton.setTitleColor(self.averageColor(fromColor: selectedColor, toColor: normalColor, percent: percent), for: .normal)
        
        currentButton.setTitleColor(self.averageColor(fromColor: normalColor, toColor: selectedColor, percent: percent), for: .selected)
        currentButton.setTitleColor(self.averageColor(fromColor: selectedColor, toColor: normalColor, percent: percent), for: .normal)
        
        // 计算滑动比例
        let ratio =  (offset.x / self.frame.size.width) * self.zoomRatio
        // 判断滑动位移是否大于屏幕。 大于重新计算比例
        if offset.x > self.frame.size.width {
            let tatioTwo = ratio - self.zoomRatio * CGFloat(leftIndex)
            currentButton.transform = CGAffineTransform.init(scaleX:  1 + tatioTwo, y: 1 + tatioTwo)
            beforeButton.transform = CGAffineTransform.init(scaleX:  1 + self.zoomRatio - tatioTwo, y: 1 + self.zoomRatio - tatioTwo)
        } else {
            currentButton.transform = CGAffineTransform.init(scaleX:  1 + ratio, y: 1 + ratio)
            beforeButton.transform = CGAffineTransform.init(scaleX:  1 + self.zoomRatio - ratio, y: 1 + self.zoomRatio - ratio)
        }
    }
    
    /// 更新下标的UI效果
    ///
    /// - Parameter relativeLacation: 滑动的相对距离
    func updateSubscriptViewStyle(_ relativeLacation:CGFloat) {
        let beforeButton = buttons[leftIndex]
        let currentButton = buttons[rightIndex]
       
        //仔细观察位移效果，分析出如下计算公式
        var frame = self.subscriptView.frame
        
        // 获取按钮文字宽度
        let beforeTextWidth = (beforeButton.titleLabel?.text as NSString?)!.size(withAttributes: [NSAttributedString.Key.font:fontSize]).width
        let currentTextWidth = (currentButton.titleLabel?.text as NSString?)!.size(withAttributes: [NSAttributedString.Key.font:fontSize]).width

        // 计算末两点位置
        let endLastPosition = currentButton.center.x + currentTextWidth / 2
        // 计算初始两点位置
        let initialFirstPosition = beforeButton.center.x - beforeTextWidth / 2
        // 需要偏移的总距离
        let maxWidth = endLastPosition - initialFirstPosition

        if relativeLacation <= 0.5 {
            frame.size.width = beforeTextWidth + (maxWidth - beforeTextWidth) * (relativeLacation/0.5)
            frame.origin.x = initialFirstPosition + (relativeLacation / 0.5)
        }
        else{
            frame.size.width = currentTextWidth + (maxWidth - currentTextWidth) * ((1 - relativeLacation) / 0.5)
            frame.origin.x = endLastPosition - frame.size.width - ((1 - relativeLacation) / 0.5)
        }
       
        self.subscriptView.frame = frame
    }
    
    // 渐变颜色
    fileprivate func averageColor(fromColor:UIColor , toColor:UIColor , percent:CGFloat) -> UIColor {
        var fromRed:CGFloat = 0.0
        var fromGreen:CGFloat = 0.0
        var fromBlue:CGFloat = 0.0
        var fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed:CGFloat = 0.0
        var toGreen:CGFloat = 0.0
        var toBlue:CGFloat = 0.0
        var toAlpha:CGFloat = 0.0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed)*percent
        let nowGreen = fromGreen + (toGreen - fromGreen)*percent
        let nowBlue = fromBlue + (toBlue - fromBlue)*percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha)*percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
    
}
