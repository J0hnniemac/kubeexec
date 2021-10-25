//
//  ContentView.swift
//  kubeexec
//
//  Created by John McManus on 21/10/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    
    @StateObject private  var kubeexecmodel = kubeExecModel()
   
    func CreateMenus(){
        appDelegate.CreateMenus(contextNamespaces: kubeexecmodel.data.k8SContextNamespaces ?? [K8SContextNamespaces(context: "none", namespace: "none")], selectedContext: kubeexecmodel.data.selectedContext)
    }
   
    var body: some View {
        
        VStack() {
            headerView(kubeExecModel: kubeexecmodel)
            if(kubeexecmodel.data.k8SContextNamespaces != nil){
                k8sListView(k8SContextNamespaces: $kubeexecmodel.data.k8SContextNamespaces)
            }
            HStack() {
                
                Button("Restore Previous", action: {
                    print("Restore Previous")
                    kubeexecmodel.restoreData()
                })
                Button("Save", action: {
                    print("Save")
                    kubeexecmodel.saveData()
                    //Send Data to build menut
                    
                    CreateMenus()
                })
                Button("Refresh", action: {
                    print("Refresh")
                    kubeexecmodel.saveData()
                    //Send Data to build menut
                    
                    CreateMenus()
                })
                
            }
        }
        .onAppear() {
            kubeexecmodel.restoreData()
            CreateMenus() 
          //  appDelegate.CreateMenus(contextNamespaces: kubeexecmodel.data.k8SContextNamespaces ?? [K8SContextNamespaces(context: "none", namespace: "none")], selectedContext: kubeexecmodel.data.selectedContext)
                            
        }
    }
}


struct headerView :  View {
    @StateObject var kubeExecModel :kubeExecModel
    @State private var nameSpace: String = "default"
    var body: some View {
        HStack(){
            selectContextView(kubeExecModel: kubeExecModel)
            TextField("Enter Namespace", text: $nameSpace)
            Button("+", action: {
                print("Add")
                if(kubeExecModel.data.selectedContext.isEmpty == false) {
                    if(kubeExecModel.data.k8SContextNamespaces != nil){
                        kubeExecModel.data.k8SContextNamespaces?.append(K8SContextNamespaces(context: kubeExecModel.data.selectedContext, namespace: nameSpace))
                    } else {
                        kubeExecModel.data.k8SContextNamespaces = [K8SContextNamespaces(context: kubeExecModel.data.selectedContext, namespace: nameSpace)]
                    }
                }
            })
        }
    }
}

struct selectContextView : View{
    @StateObject var kubeExecModel :kubeExecModel
    var body: some View {
        VStack {
            Picker("", selection: $kubeExecModel.data.selectedContext) {
                ForEach(kubeExecModel.data.k8SContext ?? ["no context available"], id: \.self) {
                    Text($0)
                }
            }
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
                    //k8SContextNamespaces?.remove(at: k8snc)
                    k8SContextNamespaces = k8SContextNamespaces!.filter(){$0 != k8snc}
                    
                    
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



