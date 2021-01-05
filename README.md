# CubeUI

### Getting Started

#### Adding a dependencies clause to your Package.swift

```
dependencies: [
    .package(url: "https://github.com/gerardogrisolini/CubeUI.git", from: "1.0.0")
]
```

#### Example CubeMenuView

```
import SwiftUI
import CubeUI

struct ContentView: View {

    @State private var index: Int = 1

    var body: some View {
    
        CubeMenuView(index: $index) {
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .bottomLeading, endPoint: .topTrailing))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Menu"))
                .navigationBarItems(
                    trailing:
                        Button(action: { index = 1 }) {
                            Image(systemName: "rotate.left.fill")
                        }
                    leading:
                        Button(action: { index = 2 }) {
                            Image(systemName: "rotate.right.fill")
                        }
                )
                .ignoresSafeArea(.all)
                
        } content: {
        
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .bottomTrailing, endPoint: .topLeading))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Content 1"))
                .navigationBarItems(
                    leading:
                        Button(action: { index = 0 }) {
                            Image(systemName: "rotate.left.fill")
                        }
                )
                .ignoresSafeArea(.all)
                
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .bottomTrailing, endPoint: .topLeading))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Content 2"))
                .navigationBarItems(
                    leading:
                        Button(action: { index = 0 }) {
                            Image(systemName: "rotate.left.fill")
                        }
                )
                .ignoresSafeArea(.all)
        }
    }
}
```

#### Example CubeView

```
import SwiftUI
import CubeUI

struct ContentView: View {
    var body: some View {
        CubeView {
            Image("0").resizable()
            Image("1").resizable()
            Image("2").resizable()
            Image("3").resizable()
        }
        .ignoresSafeArea(.all)
    }
}
```
