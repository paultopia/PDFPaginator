//
//  paginatePDF.swift
//  PDFPaginator
//
//  Created by Paul Gowder on 6/4/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Cocoa
import Quartz

func printPDFContents(_ url: URL){
    let pdf = PDFDocument(url: url)!
    print(pdf.string!)
}

func writeOnPage(doc: PDFDocument, page: Int) -> PDFDocument {
    let page: PDFPage = doc.page(at: page)!
    var mediaBox: CGRect = page.bounds(for: .mediaBox)
    let pdfData = NSMutableData()
    let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
    let gc = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
    let nsgc = NSGraphicsContext(cgContext: gc, flipped: false)
    NSGraphicsContext.current = nsgc
    gc.beginPDFPage(nil); do {
        page.draw(with: .mediaBox, to: gc)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let richText = NSAttributedString(string: "Hello, world!", attributes: [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: NSColor.red,
            NSAttributedString.Key.paragraphStyle: style
            ])
        // moving text around: see https://stackoverflow.com/a/44641001/4386239
        gc.saveGState(); do {
            richText.draw(at: .zero)
        }; gc.restoreGState()
        
    }; gc.endPDFPage()
    NSGraphicsContext.current = nil
    gc.closePDF()
    let outDocument = PDFDocument(data: pdfData as Data)!
    return outDocument
}

func makePDFArray(_ inUrl: URL){
    var outArray = [PDFDocument]()
    let doc: PDFDocument = PDFDocument(url: inUrl)!
    let pageCount = doc.pageCount
    for i in 0..<pageCount {
        outArray.append(writeOnPage(doc: doc, page: i))
    }
    let outUrl = URL(fileURLWithPath: "/Users/pauliglot/Downloads/testout.pdf")
    outArray.last!.write(to: outUrl)
}
