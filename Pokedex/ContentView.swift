import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(hex: 0xf35167)
                .ignoresSafeArea()
            GridView()
        }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
