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
                .fill(Color.orange)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Menu"))
                
        } content: {
        
            Rectangle()
                .fill(Color.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Content 1"))
                
            Rectangle()
                .fill(Color.green)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Content 2"))
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { index = index > 0 ? 0 : 1 }) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.white)
                }
            }
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
            Rectangle()
                .fill(Color.orange)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Rectangle()
                .fill(Color.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Rectangle()
                .fill(Color.green)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Rectangle()
                .fill(Color.yellow)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
    }
}
```
