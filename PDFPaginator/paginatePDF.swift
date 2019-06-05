//
//  paginatePDF.swift
//  PDFPaginator
//
//  Created by Paul Gowder on 6/4/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Cocoa
import Quartz

func writeOnPage(doc: PDFDocument, pageNum: Int) -> PDFPage {
    let page: PDFPage = doc.page(at: pageNum)!
    var mediaBox: CGRect = page.bounds(for: .mediaBox)
    let pdfData = NSMutableData()
    let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
    let gc = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
    let nsgc = NSGraphicsContext(cgContext: gc, flipped: false)
    NSGraphicsContext.current = nsgc
    gc.beginPDFPage(nil); do {
        page.draw(with: .mediaBox, to: gc)
        
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        
        
        let richText = NSAttributedString(string: "page: \(pageNum + 1)", attributes: [
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: NSColor.red,
            NSAttributedString.Key.paragraphStyle: style
            ])
        // moving text around: see https://stackoverflow.com/a/44641001/4386239
        // which is what most of this stuff is swiped from
        gc.saveGState(); do {
            richText.draw(at: .zero)
        }; gc.restoreGState()
        
    }; gc.endPDFPage()
    NSGraphicsContext.current = nil
    gc.closePDF()
    
    let outDocument = PDFDocument(data: pdfData as Data)!
    return outDocument.page(at: 0)!
}

func combinePDFPages(pages: [PDFPage]) -> PDFDocument {
    var outDoc = PDFDocument()
    for (num, page) in pages.enumerated() {
        outDoc.insert(page, at: num)
    }
    return outDoc
}

func makePDFArray(_ inUrl: URL){
    var outArray = [PDFPage]()
    let doc: PDFDocument = PDFDocument(url: inUrl)!
    let pageCount = doc.pageCount
    for i in 0..<pageCount {
        outArray.append(writeOnPage(doc: doc, pageNum: i))
    }
    let otherOutUrl = URL(fileURLWithPath: "/Users/pauliglot/Downloads/paginated_pdf.pdf")
    let wholeDoc = combinePDFPages(pages: outArray)
    wholeDoc.write(to: otherOutUrl)

}
