//
//  ContentView.swift
//  PersonNameAndAge
//
//  Created by Christian Malki on 2022-10-07.
//


import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    
    var name: String
    var age: Int
}



class PersonList: ObservableObject {
    
    @Published private var list = [Person]()
    
    init() {
        list.append(Person(name: "Ahmad", age: 27))
        list.append(Person(name: "Josse", age: 34))
        list.append(Person(name: "Saiman", age: 32))
        list.append(Person(name: "Christian", age: 22))
    }
    
    func addPerson(person: Person) {
        list.append(person)
    }
    
    func getPersons() -> [Person] {
        return list
    }
}


struct ContentView: View {
    
    @StateObject var personList = PersonList()
    @State var showAddPersonView = false
    
    // StateObject använder vi när vi skapar instansen för första gången. Det är i princip
    // en ObservedObject, bara att vi använder den när vi skapar instansen.
    
    // ObservedObject använder vi när instansen redan har skapats någon annanstans, men
    // vi vill endast referera till den och lyssan efter förändringar i den.
    
    
    var body: some View {
        
        ZStack {
            
            Color.init(red: 210/255, green: 210/255, blue: 210/255).ignoresSafeArea()
            
            NavigationView {
            
            PersonListView(personList: personList, showAddPersonView: $showAddPersonView)
            
//            if showAddPersonView {
//                AddPersonView(personList: personList, showAddPersonView: $showAddPersonView)
//            }
            
            }
            
        }
        
        
    }
}


struct PersonListView: View {
    @ObservedObject var personList: PersonList
    @Binding var showAddPersonView: Bool
    
    var body: some View {
        
        VStack {
            
            Text("Persons").font(.system(size: 38)).bold()
            
            
            NavigationLink(isActive: $showAddPersonView, destination: {

                AddPersonView(personList: personList, showAddPersonView: $showAddPersonView)

            }, label: {
                HStack {
                    Text("Add Person").bold()
                }.padding().background(.black).cornerRadius(10).foregroundColor(.white)
            })
            
            
            
            
            
            Spacer().frame(height: 50)
            
            ScrollView(showsIndicators: false) {
            
            ForEach(personList.getPersons()) {
                person in
                
                ZStack {
                    Rectangle()
                        .fill(Color.init(red: 117/255, green: 0/255, blue: 112/255))
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.2, alignment: .center)
                        .cornerRadius(30)
                    
                    Text("\(person.name), \(String(person.age))").font(.system(size: 30)).bold()
                    
                    
                }.foregroundColor(.white).padding(.vertical)
                
            }
                
            }
            

            Spacer()
            
            
        }.padding(.top)
        
    }
}

struct AddPersonView: View {
    @ObservedObject var personList: PersonList
    @Binding var showAddPersonView: Bool
    
    @State var name: String = ""
    @State var age: String = ""
    
    var body: some View {
        ZStack {
            
        Color.init(red: 210/255, green: 210/255, blue: 210/255).ignoresSafeArea()

        
            VStack(spacing: 50) {
            
            Text("Fyll i dina uppgifter").font(.system(size: 28)).bold()
            
            VStack(alignment: .leading) {

            Text("Name")
                TextField("", text: $name).textFieldStyle(.roundedBorder).padding(.bottom)
            
            Text("Age")
                TextField("", text: $age).textFieldStyle(.roundedBorder).keyboardType(.numberPad)
            
            }.padding()
            
            Button(action: {
                
                if name == "" || age == "" {
                    return
                }
                
                if let age = Int(age) {
                    
                    personList.addPerson(person: Person(name: name, age: age))
                    showAddPersonView = false
                }
                
            }, label: {
                HStack {
                    Text("Add Person").bold()
                }.padding().background(.black).cornerRadius(10).foregroundColor(.white)
            })
        
        }
            
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //AddPersonView(personList: PersonList(), showAddPersonView: .constant(true))
    }
}
