//
//  PDFCreator.swift
//  Pdf Creator
//
//  Created by Md. Mazidul Islam on 4/3/20.
//  Copyright © 2020 Jon. All rights reserved.
//

import UIKit
import PDFKit


class PDFCreator: NSObject {
    let date: String
    let to: String
    let subject: String
    let application: String
    let request: String
    let from: String
    let image: UIImage

    init(date: String,  to: String, subject: String, application: String, request: String, from: String, image: UIImage){
        self.date = date
        self.to = to
        self.subject = subject
        self.application = application
        self.request = request
        self.from = from
        self.image = image
    }
    
    
    
    func createFlyer() -> Data {
        // 1
        let pdfMetaData = [
            kCGPDFContextCreator: "Application Builder",
            kCGPDFContextAuthor: "ios dev",
            kCGPDFContextTitle: subject
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // 2
        let pageWidth = (8.27 * 72.0)
        let pageHeight = 11.69 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        // 4
        let data = renderer.pdfData { (context) in
            // 5
            context.beginPage()
            // 6
            let datePosition = addDate(pageRect: pageRect)
            let toPosition = addTo(pageRect: pageRect, textTop: datePosition)
            let subjectPosition = addSubject(pageRect: pageRect, textTop: toPosition)
            let applicationPosition = addApplication(pageRect: pageRect, textTop: subjectPosition)
            let requestPosition = addRequest(pageRect: pageRect, textTop: applicationPosition)
            let fromPosition = addFrom(pageRect: pageRect, textTop: requestPosition)
            addImage(pageRect: pageRect, imageTop: fromPosition)
            
            //      let context = context.cgContext
            //      drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 8)
            //      drawContactLabels(context, pageRect: pageRect, numberTabs: 8)
        }
        
        return data
    }
    
    func addDate(pageRect: CGRect) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // 2
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: textFont]
        let attributedText = NSAttributedString(string: date, attributes: textAttributes)
        // 3
        let textStringSize = attributedText.size()
        // 4
        let textStringRect = CGRect(x: 72,
                                    y: 72, width: textStringSize.width,
                                    height: textStringSize.height)
        // 5
        attributedText.draw(in: textStringRect)
        // 6
        return textStringRect.origin.y + textStringRect.size.height
    }
    
    func addTo(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // 2
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: textFont]
        let attributedText = NSAttributedString(string: to, attributes: textAttributes)
        // 3
        let textStringSize = attributedText.size()
        // 4
        let textStringRect = CGRect(x: 72,
                                    y: textTop, width: textStringSize.width,
                                    height: textStringSize.height)
        // 5
        attributedText.draw(in: textStringRect)
        // 6
        return textStringRect.origin.y + textStringRect.size.height
    }
    
    func addSubject(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // 2
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: textFont]
        let attributedText = NSAttributedString(string: subject, attributes: textAttributes)
        // 3
        let textStringSize = attributedText.size()
        // 4
        let textStringRect = CGRect(x: 72,
                                    y: textTop, width: textStringSize.width,
                                    height: textStringSize.height)
        // 5
        attributedText.draw(in: textStringRect)
        // 6
        return textStringRect.origin.y + textStringRect.size.height
    }
    
    func addApplication(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 2
        // 3
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(string: application, attributes: textAttributes)
        // 4
        let textRect = CGRect(x: 72, y: textTop, width: pageRect.width - 144,
                              height: 100)
        attributedText.draw(in: textRect)
        // 5
        return textRect.origin.y + textRect.size.height
    }
    
    func addRequest(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 2
        // 3
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(string: request, attributes: textAttributes)
        // 4
        let textRect = CGRect(x: 72, y: textTop, width: pageRect.width - 144,
                              height: attributedText.size().height)
        attributedText.draw(in: textRect)
        // 5
        return textRect.origin.y + textRect.size.height
    }
    
    func addFrom(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        // 2
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: textFont]
        let attributedText = NSAttributedString(string: from, attributes: textAttributes)
        // 3
        let textStringSize = attributedText.size()
        // 4
        let textStringRect = CGRect(x: 72,
                                    y: textTop, width: textStringSize.width,
                                    height: textStringSize.height)
        // 5
        attributedText.draw(in: textStringRect)
        // 6
        return textStringRect.origin.y + textStringRect.size.height
    }
    
    func addImage(pageRect: CGRect, imageTop: CGFloat) {
        // 1
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.8
        // 2
        let aspectWidth = maxWidth / image.size.width
        let aspectHeight = maxHeight / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        // 3
        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio
        // 4
        //    let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageX = 100.0
        let imageRect = CGRect(x: 72, y: imageTop,
                               width: 100.0, height: 50.0)
        // 5
        image.draw(in: imageRect)
    }
    
    ////Old
    //  func addDate(pageRect: CGRect) -> CGFloat {
    //    // 1
    //    let titleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    //    // 2
    //    let titleAttributes: [NSAttributedString.Key: Any] =
    //      [NSAttributedString.Key.font: titleFont]
    //    let attributedTitle = NSAttributedString(string: subject, attributes: titleAttributes)
    //    // 3
    //    let titleStringSize = attributedTitle.size()
    //    // 4
    //    let titleStringRect = CGRect(x: 72,
    //                                 y: 72, width: titleStringSize.width,
    //                                 height: titleStringSize.height)
    //    // 5
    //    attributedTitle.draw(in: titleStringRect)
    //    // 6
    //    return titleStringRect.origin.y + titleStringRect.size.height
    //  }
    //
    //
    //  func addSubTitle(pageRect: CGRect, titleTop: CGFloat) -> CGFloat {
    //    // 1
    //    let titleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    //    // 2
    //    let titleAttributes: [NSAttributedString.Key: Any] =
    //      [NSAttributedString.Key.font: titleFont]
    //    let attributedTitle = NSAttributedString(string: subject, attributes: titleAttributes)
    //    // 3
    //    let titleStringSize = attributedTitle.size()
    //    // 4
    //    let titleStringRect = CGRect(x: 72,
    //                                 y: titleTop, width: titleStringSize.width,
    //                                 height: titleStringSize.height)
    //    // 5
    //    attributedTitle.draw(in: titleStringRect)
    //    // 6
    //    return titleStringRect.origin.y + titleStringRect.size.height
    //  }
    //
    //
    //  func addBodyText(pageRect: CGRect, textTop: CGFloat) {
    //    // 1
    //    let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    //    // 2
    //    let paragraphStyle = NSMutableParagraphStyle()
    //    paragraphStyle.alignment = .natural
    //    paragraphStyle.lineBreakMode = .byWordWrapping
    //    // 3
    //    let textAttributes = [
    //      NSAttributedString.Key.paragraphStyle: paragraphStyle,
    //      NSAttributedString.Key.font: textFont
    //    ]
    //    let attributedText = NSAttributedString(string: application, attributes: textAttributes)
    //    // 4
    //    let textRect = CGRect(x: 72, y: textTop, width: pageRect.width - 144,
    //                          height: pageRect.height - textTop - pageRect.height / 5.0)
    //    attributedText.draw(in: textRect)
    //  }
    
    
    //  // 1
    //  func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
    //                    tearOffY: CGFloat, numberTabs: Int) {
    //    // 2
    //    drawContext.saveGState()
    //    drawContext.setLineWidth(2.0)
    //
    //    // 3
    //    drawContext.move(to: CGPoint(x: 0, y: tearOffY))
    //    drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
    //    drawContext.strokePath()
    //    drawContext.restoreGState()
    //
    //    // 4
    //    drawContext.saveGState()
    //    let dashLength = CGFloat(72.0 * 0.2)
    //    drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
    //    // 5
    //    let tabWidth = pageRect.width / CGFloat(numberTabs)
    //    for tearOffIndex in 1..<numberTabs {
    //      // 6
    //      let tabX = CGFloat(tearOffIndex) * tabWidth
    //      drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
    //      drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
    //      drawContext.strokePath()
    //    }
    //    // 7
    //    drawContext.restoreGState()
    //  }
    //
    //  func drawContactLabels(_ drawContext: CGContext, pageRect: CGRect, numberTabs: Int) {
    //    let contactTextFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
    //    let paragraphStyle = NSMutableParagraphStyle()
    //    paragraphStyle.alignment = .natural
    //    paragraphStyle.lineBreakMode = .byWordWrapping
    //    let contactBlurbAttributes = [
    //      NSAttributedString.Key.paragraphStyle: paragraphStyle,
    //      NSAttributedString.Key.font: contactTextFont
    //    ]
    //    let attributedContactText = NSMutableAttributedString(string: contactInfo, attributes: contactBlurbAttributes)
    //    // 1
    //    let textHeight = attributedContactText.size().height
    //    let tabWidth = pageRect.width / CGFloat(numberTabs)
    //    let horizontalOffset = (tabWidth - textHeight) / 2.0
    //    drawContext.saveGState()
    //    // 2
    //    drawContext.rotate(by: -90.0 * CGFloat.pi / 180.0)
    //    for tearOffIndex in 0...numberTabs {
    //      let tabX = CGFloat(tearOffIndex) * tabWidth + horizontalOffset
    //      // 3
    //      attributedContactText.draw(at: CGPoint(x: -pageRect.height + 5.0, y: tabX))
    //    }
    //    drawContext.restoreGState()
    //  }
}
