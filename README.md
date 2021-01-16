# ZenUI

### Getting Started

#### Adding a dependencies clause to your Package.swift

```
dependencies: [
    .package(url: "https://github.com/gerardogrisolini/ZenUI.git", from: "1.1.5")
]
```

#### Example CubeView

```
import SwiftUI
import ZenUI

struct ContentView: View {
    @State private var index: Int = 0
    
    var body: some View {
    
        CubeView(index: $index, mode: .drag) {
            SideView(number: 1, color: .blue)
            SideView(number: 2, color: .orange)
            SideView(number: 3, color: .green)
            SideView(number: 4, color: .yellow)
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { index = 0 }) {
                    Image(systemName: "line.horizontal.3")
                }
            }
        }
    }
}

struct SideView: View {
    var number: Int
    var color: Color
    
    var body: some View {
        Text("Content \(number)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
    }
}
```

#### Example RefreshView

```
import SwiftUI
import ZenUI

struct ContentView: View {
    
    @State var offset: CGFloat = 0
    @State var isRefresh: Bool = false
    
    var body: some View {
    
        RefreshView(offset: $offset, isRefresh: $isRefresh) {
            
            Text("\(offset) - \(isRefresh.description)")
                .font(.title)
                .frame(maxWidth: .infinity)
        }
    }
}
```

