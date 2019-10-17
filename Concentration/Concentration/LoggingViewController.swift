//
//  LoggingViewController.swift
//  Concentration
//
//  Created by QDSG on 2019/10/17.
//  Copyright © 2019 tao Tao. All rights reserved.
//

import UIKit

class LoggingViewController: UIViewController {
    
    private struct LogGlobals {
        var prefix = ""
        var instanceCounts = [String: Int]()
        var lastLogTime = Date()
        var indentationInterval: TimeInterval = 1
        var indentationString = "__"
    }
    
    private static var logGlobals = LogGlobals()
    
    private static func logPrefix(for loggingName: String) -> String {
        if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval {
            logGlobals.prefix += logGlobals.indentationString
            print("")
        }
        logGlobals.lastLogTime = Date()
        return logGlobals.prefix + loggingName
    }
    
    private static func bumpInstanceCount(for loggingName: String) -> Int {
        logGlobals.instanceCounts[loggingName] = (logGlobals.instanceCounts[loggingName] ?? 0) + 1
        return logGlobals.instanceCounts[loggingName]!
    }
    
    private var instanceCount: Int!
    
    var loggingName: String {
        return String(describing: type(of: self))
    }
    
    private func log(_ msg: String) {
        if instanceCount == nil {
            instanceCount = LoggingViewController.bumpInstanceCount(for: loggingName)
        }
        print("\(LoggingViewController.logPrefix(for: loggingName))(\(instanceCount!)) \(msg)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        log("init(coder:) - created via InterfaceBuilder")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        log("init(nibName:bundle:) - create in code")
    }
    
    deinit {
        log("left the heap")
    }
    
    override func awakeFromNib() {
        log("awakeFromNib()")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        log("viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        log("viewWillAppear(animated = \(animated))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        log("viewDidAppear(animated = \(animated))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        log("viewWillDisappear(animated = \(animated))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        log("viewDidDisappear(animated = \(animated))")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        log("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        log("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        log("viewWillTransition(to: \(size), with: coordinator)")
        coordinator.animate(alongsideTransition: { (_) in
            self.log("begin animate(alongsideTransition:completion:)")
        }) { (_) in
            self.log("end animate(alongsideTransition:completion:)")
        }
    }
}
