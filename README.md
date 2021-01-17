# ZenUI

### Getting Started

#### Adding a dependencies clause to your Package.swift

```
dependencies: [
    .package(url: "https://github.com/gerardogrisolini/ZenUI.git", from: "1.1.7")
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
    @State private var index: Int = 0
    @State private var offset: CGFloat = 0
    @State private var isRefresh: Bool = false
    @State private var data: [Int] = []
    
    var body: some View {
        NavigationView {
        
            RefreshView(offset: $offset, isRefresh: $isRefresh, onRefresh: refresh) {
        
                LazyVStack(alignment: .leading, spacing: 1) {
                    ForEach(data, id: \.self) { value in
                        Text(value.description)
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding()
                    }
                }
            }
            .navigationTitle("\(offset)")
        }
        .onAppear {
            refresh()
        }
    }
    
    private func refresh() {
        isRefresh = true
        data.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            data.append(contentsOf: 0...100)
            isRefresh = false
        }
    }
}
```
