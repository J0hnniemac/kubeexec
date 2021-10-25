//
//  kubeExecModel.swift
//  kubeexec
//
//  Created by John McManus on 25/10/2021.
//

import Foundation
import SwiftUI
final class kubeExecModel : ObservableObject {
  //  @Published var nameSpaces: [String]?
   // @Published var k8SContextNamespaces: [K8SContextNamespaces]?
   // @Published var k8SContext: [String]?
 //   @Published var selectedContext = ""
    var statusBarItem: NSStatusItem!
    var statusBar:NSStatusBar!
    var statusBarMenu:NSMenu!
    var runningPodsList: [String]!
    
    @Published var data = kubeExecModelStruct()
    
    init(){
        getContexts()
    }
    
    
    func getContexts(){
        let contexts = shell("/usr/local/bin/kubectl config get-contexts | awk 'NR!=1 {print $2}'")
        print(contexts)
        data.k8SContext = contexts.components(separatedBy: "\n")
    }
    
    func saveData(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedDara")
        }
    }
    func restoreData(){
        let defaults = UserDefaults.standard
        if let savedData = defaults.object(forKey: "SavedDara") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode(kubeExecModelStruct.self, from: savedData) {
                
                data = loadedData
            }
        }
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
    
    
    
    
    
    
}
struct K8SContextNamespaces : Hashable,Codable {
    var context : String!
    var namespace: String!
    
}

struct kubeExecModelStruct : Codable{
   var nameSpaces: [String]?
   var k8SContextNamespaces: [K8SContextNamespaces]?
   var k8SContext: [String]?
   var selectedContext = ""
}