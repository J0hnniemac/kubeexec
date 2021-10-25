//
//  ContentView.swift
//  kubeexec
//
//  Created by John McManus on 21/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var kubeexecmodel = kubeExecModel()

    
    var body: some View {
        VStack() {
            
            headerView(k8SContextNamespaces: $kubeexecmodel.data.k8SContextNamespaces,xxkubeExecModel: kubeexecmodel)
            if(kubeexecmodel.data.k8SContextNamespaces != nil){
                k8sListView(k8SContextNamespaces: $kubeexecmodel.data.k8SContextNamespaces)
            }
            HStack() {
                Button("Restore Previous", action: {
                    print("Restore Previous")
                
                })
                Button("Save", action: {
                    print("Save")
                
                })
            }
            
        }
        
    }
}


struct headerView :  View {
    @Binding var k8SContextNamespaces: [K8SContextNamespaces]?
    @StateObject var xxkubeExecModel :kubeExecModel
    @State private var nameSpace: String = "default"
    var body: some View {
        HStack(){
            selectContextView(kubeExecModel: xxkubeExecModel)
            TextField("Enter Namespace", text: $nameSpace)
            Button("+", action: {
                print("Add")
                if(xxkubeExecModel.data.selectedContext.isEmpty == false) {
                    if(xxkubeExecModel.data.k8SContextNamespaces != nil){
                        xxkubeExecModel.data.k8SContextNamespaces?.append(K8SContextNamespaces(context: xxkubeExecModel.data.selectedContext, namespace: nameSpace))
                    } else {
                        xxkubeExecModel.data.k8SContextNamespaces = [K8SContextNamespaces(context: xxkubeExecModel.data.selectedContext, namespace: nameSpace)]
                    }
                }
                    
                    
                /*
                if(k8SContextNamespaces != nil){
                    k8SContextNamespaces!.append(K8SContextNamespaces(context: "docker-desktop", namespace: "default"))
                }else {
                    k8SContextNamespaces = [K8SContextNamespaces(context: "docker-desktop", namespace: "k8s")]
                }
                */
            })
        }
    }
}

struct selectContextView : View{
    @StateObject var kubeExecModel :kubeExecModel
    //var k8scontext = ["docker-desktop", "dev", "qa", "prod"]
    
       
    var body: some View {
        VStack {
            Picker("", selection: $kubeExecModel.data.selectedContext) {
                ForEach(kubeExecModel.data.k8SContext ?? ["no context available"], id: \.self) {
                            Text($0)
                        }
                    }
           // Text("You selected: \(kubeExecModel.selectedContext)")
                }
    
        
        
        
    }
}




struct k8sListView :  View {
    @Binding var k8SContextNamespaces: [K8SContextNamespaces]?
    var body: some View {
        ForEach(k8SContextNamespaces!, id: \.self) { k8snc in
            HStack{
                Text(k8snc.context)
                Text(k8snc.namespace)
                Button("-", action: {
                    print("Remove")
                })
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


