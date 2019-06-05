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
    //let outUrl = URL(fileURLWithPath: "/Users/pauliglot/Downloads/testout.pdf")
    //let doc: PDFDocument = PDFDocument(url: inUrl)!
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

        gc.saveGState(); do {
            richText.draw(at: .zero)
        }; gc.restoreGState()
        
    }; gc.endPDFPage()
    NSGraphicsContext.current = nil
    gc.closePDF()
    let outDocument = PDFDocument(data: pdfData as Data)!
    //outDocument.write(to: outUrl)
    return outDocument
}

func makePDFArray(_ inUrl: URL){
    var outArray = [PDFDocument]()
    let doc: PDFDocument = PDFDocument(url: inUrl)!
    let outDoc = writeOnPage(doc: doc, page: 0)
    outArray.append(outDoc)
    let outUrl = URL(fileURLWithPath: "/Users/pauliglot/Downloads/testout.pdf")
    outArray[0].write(to: outUrl)
}
