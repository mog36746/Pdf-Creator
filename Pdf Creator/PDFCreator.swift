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
    let fontSize: CGFloat
    let date: String
    let to: String
    let subject: String
    let application: String
    let request: String
    let from: String
    let image: UIImage
    
    init(fontSize: CGFloat, date: String,  to: String, subject: String, application: String, request: String, from: String, image: UIImage){
        self.date = date
        self.to = to
        self.subject = subject
        self.application = application
        self.request = request
        self.from = from
        self.image = image
        self.fontSize = fontSize
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
        let textFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
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
        let textFont = UIFont.systemFont(ofSize: 11.0, weight: .regular)
        // 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.15
        // 3
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(string: application, attributes: textAttributes)
        // 4
        // determine the size of CGRect needed for the string that was given by caller
        let paragraphSize = CGSize(width: pageRect.width - 144, height: pageRect.height)
        let paragraphRect = attributedText.boundingRect(with: paragraphSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        // Create a CGRect that is the same size as paragraphRect but positioned on the pdf where we want to draw the paragraph
        let positionedParagraphRect = CGRect(
            x: 72,
            y: textTop,
            width: paragraphRect.width,
            height: paragraphRect.height
        )
        
        // draw the paragraph into that CGRect
        attributedText.draw(in: positionedParagraphRect)
        
        // return the bottom of the paragraph
        return positionedParagraphRect.origin.y + positionedParagraphRect.size.height
    }
    
    func addRequest(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
        // 1
        let textFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        // 2
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineHeightMultiple = 1.15
        // 3
        let textAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont
        ]
        let attributedText = NSAttributedString(string: request, attributes: textAttributes)
        // 4
        // determine the size of CGRect needed for the string that was given by caller
        let paragraphSize = CGSize(width: pageRect.width - 144, height: pageRect.height)
        let paragraphRect = attributedText.boundingRect(with: paragraphSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        
        // Create a CGRect that is the same size as paragraphRect but positioned on the pdf where we want to draw the paragraph
        let positionedParagraphRect = CGRect(
            x: 72,
            y: textTop,
            width: paragraphRect.width,
            height: paragraphRect.height
        )
        
        // draw the paragraph into that CGRect
        attributedText.draw(in: positionedParagraphRect)
        
        // return the bottom of the paragraph
        return positionedParagraphRect.origin.y + positionedParagraphRect.size.height
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
        let maxHeight = 108.0
        let maxWidth = 72.0
        // 2
        let aspectWidth = CGFloat(maxWidth) / image.size.width
        let aspectHeight = CGFloat(maxHeight) / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)
        // 3
        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio
        // 4
        let imageRect = CGRect(x: 72, y: imageTop,
                               width: scaledWidth, height: scaledHeight)
        // 5
        image.draw(in: imageRect)
    }
}
