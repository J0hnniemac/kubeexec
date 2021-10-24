//
//  ContentView.swift
//  kubeexec
//
//  Created by John McManus on 21/10/2021.
//

import SwiftUI

struct ContentView: View {
    
    @State private var nameSpaces: [String] = ["default","audit"]
    
    @State private var xk8SContextNamespaces: [K8SContextNamespaces] = [K8SContextNamespaces(context: "docker-desktop", namespace: "default"), K8SContextNamespaces(context: "docker-desktop", namespace: "k8s"),K8SContextNamespaces(context: "docker-desktop", namespace: "jenkins")]
     
    @State private var k8SContextNamespaces: [K8SContextNamespaces]?

    
    var body: some View {
        VStack() {
            
            headerView(k8SContextNamespaces: $k8SContextNamespaces)
            if(k8SContextNamespaces != nil){
                k8sListView(k8SContextNamespaces: $k8SContextNamespaces)
            }
            
            
        }
        
    }
}


struct selectContextView : View{
    var k8scontext = ["docker-desktop", "dev", "qa", "prod"]
        @State private var selectedContext = "dev"
    var body: some View {
        VStack {
                    Picker("", selection: $selectedContext) {
                        ForEach(k8scontext, id: \.self) {
                            Text($0)
                        }
                    }
//                    Text("You selected: \(selectedContext)")
                }
    
    
    }
}

struct headerView :  View {
    @Binding var k8SContextNamespaces: [K8SContextNamespaces]?
    @State private var nameSpace: String = "default"
    var body: some View {
        HStack(){
            selectContextView()
            TextField("Enter Namespace", text: $nameSpace)
            Button("+", action: {
                print("Add")
                if(k8SContextNamespaces != nil){
                    k8SContextNamespaces!.append(K8SContextNamespaces(context: "docker-desktop", namespace: "default"))
                }else {
                    k8SContextNamespaces = [K8SContextNamespaces(context: "docker-desktop", namespace: "k8s")]
                }
                
            })
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

struct K8SContextNamespaces : Hashable {
    var context : String!
    var namespace: String!
}
