//
//  paginatePDF.swift
//  PDFPaginator
//
//  Created by Paul Gowder on 6/4/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Cocoa
import Quartz


func writeOnPage(page: PDFPage, pageNumber: Int) -> PDFPage {
    let outData = NSMutableData()
    let outPDFConsumer = CGDataConsumer(data: outData as CFMutableData)!
    var mediaBox: CGRect = page.bounds(for: .mediaBox)
    
    let gc = CGContext(consumer: outPDFConsumer, mediaBox: &mediaBox, nil)!
    let nsgc = NSGraphicsContext(cgContext: gc, flipped: false)
    NSGraphicsContext.current = nsgc
    gc.beginPDFPage(nil); do {
        page.draw(with: .mediaBox, to: gc)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        let richText = NSAttributedString(string: "Page \(pageNumber)", attributes: [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 1),
            NSAttributedString.Key.foregroundColor: NSColor.red,
            NSAttributedString.Key.paragraphStyle: style
            ])
        gc.saveGState(); do {
            richText.draw(at: .zero)
        }; gc.restoreGState()
        
    }; gc.endPDFPage()
    NSGraphicsContext.current = nil
    gc.closePDF()
    var outDoc = PDFDocument(data: outData as Data)!
    let testUrl = URL(fileURLWithPath: "/Users/pauliglot/Downloads/testoutOTHER.pdf")
    outDoc.write(to: testUrl)
    let outPage: PDFPage = outDoc.page(at: 0)!
    return outPage
}

func writeOnDocument(_ inUrl: URL) {
    let outUrl = URL(fileURLWithPath: "/Users/pauliglot/Downloads/testout.pdf")
    let doc = PDFDocument(url: inUrl)!
    var page: PDFPage = doc.page(at: 0)!
    let inPage = writeOnPage(page: page, pageNumber: 0)
    var outDoc = PDFDocument()
    outDoc.insert(inPage, at: 0)
    outDoc.write(to: outUrl)
}
