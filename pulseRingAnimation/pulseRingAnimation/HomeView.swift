//
//  ContentView.swift
//  pulseRingAnimation
//
//  Created by cit on 28/08/22.
//

import SwiftUI

struct ContentView: View {
    
    //Animation Parameters...
    @State var startAnimation = false
    
    @State var pulse1 = false
    @State var pulse2 = false
    
    @State var foundPeople: [People] = []
    // finishAnimation
    @State var finishAnimation = false
    
    var body: some View {
        VStack{
            // NAVBAR
            HStack(spacing:10){
                Button(action: {}, label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                })

                Text("NearBy Search")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: verifyAndAddPeople, label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                })
            }
            .padding()
            .padding(.top, getSafeArea().top)
            .background(Color.white)
            
            ZStack{
                
                Circle()
                    .stroke(Color.gray.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse1 ? 3.3 : 1)
                    .opacity(pulse1 ? 0 : 1)
                
                Circle()
                    .stroke(Color.gray.opacity(0.6))
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse2 ? 3.3 : 1)
                    .opacity(pulse2 ? 0 : 1)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 130, height: 130)
                //Shadows...
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                
                ZStack{
                    Circle()
                        .stroke(Color.blue,lineWidth: 1.4)
                        .frame(width: 30, height: 30)
                    
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color.blue,lineWidth: 1.4)
                    
                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color.blue,lineWidth: 1.4)
                        .rotationEffect(.init(degrees: -180))
                }
                .frame(width: 70, height: 70)
                // Rotating view...
                .rotationEffect(.init(degrees: startAnimation ? 360 : 0))
                
                // showinf found people...
                ForEach(foundPeople){ people in
                    
                    Image(people.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(4)
                        .background(Color.white.clipShape(Circle()))
                        .offset(people.offset)
                    
                
                }
            }
            .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea()
        .background(Color.black.opacity(0.05).ignoresSafeArea())
        .onAppear(perform: {
            animateView()
        })
    }
    
    func verifyAndAddPeople(){
        if foundPeople.count < 5 {
            // add people
            withAnimation {
                var people = peoples[foundPeople.count]
                // setting custom offset for top five found people...
                people.offset = firstFiveOffsets[foundPeople.count]
                foundPeople.append(people)
            }
        } else {
            // finish animation and showing bottom sheet...
            withAnimation(Animation.linear(duration: 0.6)){
                finishAnimation.toggle()
                // resetting akk animation...
                startAnimation = false
                pulse1 = false
                pulse2 = false
            }
        }
    }
    
    func animateView(){
        withAnimation(Animation.linear(duration: 1.7).repeatForever(autoreverses: false)){
            startAnimation.toggle()
        }
        // it will start next round 0.1s eariler....
        withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
            pulse1.toggle()
        }
        
        //2nd pulse animation...
        // will start 0.5 delay...
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.linear(duration: 1.7).delay(-0.1).repeatForever(autoreverses: false)){
                pulse2.toggle()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// Extending view to get Safearea and screen Size...

extension View{
    
    func getSafeArea()->UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}


// Sample People Model And Data...

struct People: Identifiable {
    var id = UUID().uuidString
    var image: String
    var name: String
    // Offset will be used for showing user in pulse animation...
    var offset: CGSize = CGSize(width: 0, height: 0)
}

var peoples = [
    People(image: "cat_profile_1", name: "gato1"),
    People(image: "cat_profile_2", name: "gato2"),
    People(image: "cat_profile_3", name: "gato3"),
    People(image: "dog_profile_1", name: "dog1"),
    People(image: "horse_profile_1", name: "cavalo1")
]

// Random Offsets for top 5 people...
var firstFiveOffsets: [CGSize] = [
    CGSize(width: 100, height: 100),
    CGSize(width: -100, height: -100),
    CGSize(width: -50, height: 130),
    CGSize(width: 50, height: -130),
    CGSize(width: 120, height: -50)
]
