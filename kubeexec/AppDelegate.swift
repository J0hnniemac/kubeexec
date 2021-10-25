//
//  AppDelegate.swift
//  kubeexec
//
//  Created by John McManus on 21/10/2021.
//

import SwiftUI
class AppDelegate: NSObject, NSApplicationDelegate,ObservableObject {
    var statusBarItem: NSStatusItem!
    var statusBar:NSStatusBar!
    var statusBarMenu:NSMenu!
    var runningPodsList: [String]!
    
    
    // TODO: Make this a configuration item
   // var namespace = "default"
    override init() {
        Swift.print("AppDelegate.init")
        super.init()
        Swift.print("AppDelegate.init2")
        
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        Swift.print("AppDelegate.applicationWillFinishLaunching")
        basicMenu()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Swift.print("AppDelegate.applicationDidFinishLaunching")
        
      
    }
    
    
    
    func basicMenu(){
        statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.title = GetKubeCurrent()
        statusBarMenu = NSMenu(title: "Kube Contexts")
        statusBarItem.menu = statusBarMenu
        statusBarMenu.addItem(
            withTitle: "Refresh",
            action: #selector(AppDelegate.refreshContext),
            keyEquivalent: "")
    }
    
    @objc func refreshContext() {
        statusBarItem.button?.title = GetKubeCurrent()
    }
    
    func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    func setupTopMenu(){
        statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        
        statusBarItem.button?.title = GetKubeCurrent()
        
        statusBarMenu = NSMenu(title: "Kube Contexts")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem(
            withTitle: "Refresh",
            action: #selector(AppDelegate.refreshContext),
            keyEquivalent: "")
        
        
        statusBarMenu.addItem(
            withTitle: "Refresh1",
            action: #selector(AppDelegate.refreshContext),
            keyEquivalent: "")
        
        
        statusBarMenu.addItem(
            withTitle: "Refresh2",
            action: #selector(AppDelegate.refreshContext),
            keyEquivalent: "")
        
        
        statusBarMenu.addItem(
            withTitle: "Refresh3",
            action: #selector(AppDelegate.refreshContext),
            keyEquivalent: "")
       // GetKubePods()
    }
    
    func runKubeExec(){
        print("runKubeExec")
        
    }
    
    
    func GetKubeCurrent() ->String{
        let current = shell("/usr/local/bin/kubectl config current-context")
        print(current)
        let trimmed = current.filter { !$0.isWhitespace }
        
        // let xx = shell("ls")
        // print(xx)
        return trimmed
    }
    @objc
    func execToPod(sender: Any)
    {
        let menuitem = sender as! NSMenuItem
        print(menuitem.title)
        let mt = menuitem.title
        let startIndex = mt.firstIndex(of:":")!
        let nextIndex = mt.index(startIndex, offsetBy: 1)
        let preIndex = mt.index(startIndex, offsetBy: -1)
        let podname = mt[nextIndex...] // fo
        let namespace = mt[...preIndex]
        
        //let openterm = "/usr/bin/osascript ~/.kube/launchexec.scpt \(menuitem.title) &"
        var stringPath = ""
        stringPath = Bundle.main.path(forResource: "launchexec", ofType: "scpt")!
        //print(stringPath)
        let openterm = "/usr/bin/osascript \(stringPath) \(podname) \(namespace)&"
        print(openterm)
        //let openterm = "ttab -w &"
        //let openterm = "open -a \"Terminal\" \"PWD\""
        let _ = shell(openterm)
        //let exec="/usr/local/bin/kubectl exec --namespace=audit --stdin --tty \(menuitem.title) -- /bin/bash"
        
        //print(exec)
    }
    
    
    func CreateMenus(contextNamespaces:[K8SContextNamespaces],selectedContext:String){
      /*
        let existingCount = statusBarMenu.items.count
        
        print("***")
        print("existing count \(existingCount)")
        if(existingCount>1){
            //delete old menu items
            for i in stride(from: existingCount-1, to: 0, by: -1) {
                print(i)
                statusBarMenu.removeItem(at: i)
            }
        
        }
        */
        statusBarMenu.removeAllItems()
        for CNS in contextNamespaces {
            if(CNS.context == selectedContext){
                //get all running pods for this namespace
               
                let shellcmd = "/usr/local/bin/kubectl get pods --namespace=\(CNS.namespace ?? "none") |grep Running | awk '{print $1}'"
                let runningPods = shell(shellcmd)
                
                
                
                let runningPodsList = runningPods.components(separatedBy: "\n")
                
                for pod in runningPodsList {
                    print(pod)
                    if(!pod.isEmpty && !pod.lowercased().contains("no resources")){
                        statusBarMenu.addItem(
                            withTitle: "\(CNS.namespace ?? ""):\(pod)",
                            action: #selector(AppDelegate.execToPod(sender:)),
                            keyEquivalent: "")
                    }
                    
                }
            }
        }
    }
    
    
}
