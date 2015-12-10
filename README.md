# ICSDrawerController-Swift-
根据著名侧滑框架ICSDrawerController的源代码,重新用Swift写了一遍,并且做了功能优化,方便用Swift的用户直接进行集成使用

主要使用的类是SCSDrawerViewController.swift
该类提供了close() 和 open()的方法,可以方便的在外界直接开启和关闭侧滑

具体用法可以在Appdelegate里面将控制器作为成员变量
var drawerVc:SCSDrawerViewController!

然后
let colorVc = SCSColorsViewController()
let planVc = SCSPlainColorViewController()
let nav = NavViewController(rootViewController:planVc)
drawerVc = SCSDrawerViewController(leftViewController: colorVc, centerViewController: nav)
window!.rootViewController = drawerVc

在需要关闭的类里面定义关闭按钮,按钮的点击事件里面调用关闭方法:

let appdelegate = UIApplication.sharedApplication().delegate as? AppDelegate
appdelegate!.drawerVc.close()

同时还提供了刷新当前主控制器的方法和替换当前主控制的方法
func reloadCenterViewControllerUsingBlock(reloadBlock:() -> ())
func replaceCenterViewControllerWithViewController(viewController:protocol<SCSDrawerControllerChild, SCSDrawerControllerPresenting>)
以及不带动画效果的替换当前主控制器的方法
func replaceCenterViewControllerWithViewControllerNoanimate(viewController:protocol<SCSDrawerControllerChild, SCSDrawerControllerPresenting>)

因为原作者的侧滑手势用的是pan手势,这样在主控制进行push动作的时候,会影响push控制器的edgePan手势,所以我在此基础上进行了修改
侧滑打开替换成UISrceenEdgePan手势,关闭还是使用Pan手势