import SwiftUI
import PDFKit

struct OutlineItem: Identifiable {
    let id = UUID()
    let label: String
    let destination: PDFDestination?
    let children: [OutlineItem]?
}

struct SidebarView: View {
    let document: PDFDocument?
    let pdfView: CustomPDFView
    @Binding var currentPage: Int
    
    @State private var selectedTab = 0 // 0 = Pages, 1 = Outline
    @State private var outlineSearchQuery = ""
    @State private var outlineItems: [OutlineItem] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Selector
            Picker("", selection: $selectedTab) {
                Label("Pages", systemImage: "square.grid.2x2").tag(0)
                Label("Outline", systemImage: "list.bullet").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(SimplePDFDesign.Space.sm)
            
            Divider()
            
            // Tab Content
            Group {
                if selectedTab == 0 {
                    // Pages Tab (Custom SwiftUI Thumbnail Grid)
                    if let doc = document {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(0..<doc.pageCount, id: \.self) { index in
                                    if let page = doc.page(at: index) {
                                        let bounds = page.bounds(for: .mediaBox)
                                        let pageW = bounds.width > 0 ? bounds.width : 1.0
                                        let pageH = bounds.height > 0 ? bounds.height : 1.0
                                        let aspectRatio = pageW / pageH
                                        
                                        let thumbnailWidth: CGFloat = 110
                                        let thumbnailHeight = thumbnailWidth / aspectRatio
                                        let isSelected = currentPage == index + 1
                                        
                                        VStack(spacing: 6) {
                                            Image(nsImage: page.thumbnail(of: NSSize(width: thumbnailWidth * 2.0, height: thumbnailHeight * 2.0), for: .mediaBox))
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: thumbnailWidth, height: thumbnailHeight)
                                                .background(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.xs, style: .continuous))
                                                .shadow(
                                                    color: SimplePDFDesign.Shadow.thumbnail.color,
                                                    radius: SimplePDFDesign.Shadow.thumbnail.radius,
                                                    x: SimplePDFDesign.Shadow.thumbnail.x,
                                                    y: SimplePDFDesign.Shadow.thumbnail.y
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.xs, style: .continuous)
                                                        .stroke(isSelected ? SimplePDFDesign.ColorToken.accent : SimplePDFDesign.ColorToken.divider, lineWidth: isSelected ? SimplePDFDesign.Stroke.selected : SimplePDFDesign.Stroke.hairline)
                                                )
                                            
                                            Text("\(index + 1)")
                                                .font(SimplePDFDesign.Typography.monoLabel())
                                                .foregroundColor(isSelected ? SimplePDFDesign.ColorToken.accentStrong : SimplePDFDesign.ColorToken.secondaryText)
                                        }
                                        .padding(.vertical, SimplePDFDesign.Space.xs)
                                        .padding(.horizontal, SimplePDFDesign.Space.sm)
                                        .background(isSelected ? SimplePDFDesign.ColorToken.selectionFill.opacity(0.54) : Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: SimplePDFDesign.Radius.md, style: .continuous))
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            currentPage = index + 1
                                            if let targetPage = doc.page(at: index) {
                                                pdfView.go(to: targetPage)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(SimplePDFDesign.Space.lg)
                        }
                        .background(SimplePDFDesign.ColorToken.panelSoft)
                    } else {
                        placeholderView(message: "No Document Loaded")
                    }
                } else {
                    // Outline (Table of Contents) Tab
                    VStack(spacing: 0) {
                        // Outline Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(SimplePDFDesign.ColorToken.secondaryText)
                            TextField("Search Outline...", text: $outlineSearchQuery)
                                .textFieldStyle(.plain)
                            if !outlineSearchQuery.isEmpty {
                                Button(action: { outlineSearchQuery = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(SimplePDFDesign.ColorToken.secondaryText)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .simpleSearchFieldBackground()
                        .padding([.horizontal, .top], SimplePDFDesign.Space.sm)
                        .padding(.bottom, SimplePDFDesign.Space.sm)
                        
                        Divider()
                        
                        if outlineItems.isEmpty {
                            placeholderView(message: "No Table of Contents")
                        } else {
                            let filtered = filterOutline(outlineItems, query: outlineSearchQuery)
                            if filtered.isEmpty {
                                placeholderView(message: "No Matches Found")
                            } else {
                                List {
                                    OutlineGroup(filtered, children: \.children) { item in
                                        Button(action: {
                                            if let dest = item.destination {
                                                pdfView.go(to: dest)
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: "bookmark")
                                                    .foregroundColor(SimplePDFDesign.ColorToken.accent)
                                                    .font(SimplePDFDesign.Typography.label())
                                                Text(item.label)
                                                    .font(SimplePDFDesign.Typography.body())
                                                    .lineLimit(1)
                                            }
                                        }
                                        .buttonStyle(.plain)
                                        .help(item.label)
                                    }
                                }
                                .listStyle(.sidebar)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: document) { _, newDoc in
            loadOutline(from: newDoc)
        }
        .onAppear {
            loadOutline(from: document)
        }
    }
    
    private func placeholderView(message: String) -> some View {
        VStack {
            Spacer()
            Text(message)
                .font(SimplePDFDesign.Typography.body())
                .foregroundColor(SimplePDFDesign.ColorToken.secondaryText)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadOutline(from doc: PDFDocument?) {
        guard let doc = doc else {
            outlineItems = []
            return
        }
        outlineItems = buildOutline(from: doc.outlineRoot)
    }
    
    private func buildOutline(from outline: PDFOutline?) -> [OutlineItem] {
        guard let outline = outline else { return [] }
        var items: [OutlineItem] = []
        
        for i in 0..<outline.numberOfChildren {
            if let child = outline.child(at: i) {
                let label = child.label ?? "Untitled Page"
                let destination = child.destination
                let children = buildOutline(from: child)
                items.append(OutlineItem(
                    label: label,
                    destination: destination,
                    children: children.isEmpty ? nil : children
                ))
            }
        }
        return items
    }
    
    private func filterOutline(_ items: [OutlineItem], query: String) -> [OutlineItem] {
        if query.isEmpty { return items }
        
        return items.compactMap { item in
            let filteredChildren = filterOutline(item.children ?? [], query: query)
            let matchesQuery = item.label.localizedCaseInsensitiveContains(query)
            
            if matchesQuery || !filteredChildren.isEmpty {
                return OutlineItem(
                    label: item.label,
                    destination: item.destination,
                    children: filteredChildren.isEmpty ? nil : filteredChildren
                )
            }
            return nil
        }
    }
}
