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
  let title: String
  let body: String
  let image: UIImage
  let contactInfo: String
  
  init(title: String, body: String, image: UIImage, contact: String) {
    self.title = title
    self.body = body
    self.image = image
    self.contactInfo = contact
  }
  
  func createFlyer() -> Data {
    // 1
    let pdfMetaData = [
      kCGPDFContextCreator: "Flyer Builder",
      kCGPDFContextAuthor: "raywenderlich.com",
      kCGPDFContextTitle: title
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
      let titleBottom = addDate(pageRect: pageRect)
      let subtitleBottom = addSubTitle(pageRect: pageRect, titleTop: titleBottom )
      let imageBottom = addImage(pageRect: pageRect, imageTop: subtitleBottom + 18.0)
      addBodyText(pageRect: pageRect, textTop: imageBottom + 18.0)
      
//      let context = context.cgContext
//      drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 8)
//      drawContactLabels(context, pageRect: pageRect, numberTabs: 8)
    }
    
    return data
  }
  
  func addDate(pageRect: CGRect) -> CGFloat {
    // 1
    let titleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 2
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
    // 3
    let titleStringSize = attributedTitle.size()
    // 4
    let titleStringRect = CGRect(x: 72,
                                 y: 72, width: titleStringSize.width,
                                 height: titleStringSize.height)
    // 5
    attributedTitle.draw(in: titleStringRect)
    // 6
    return titleStringRect.origin.y + titleStringRect.size.height
  }
  
  
  func addSubTitle(pageRect: CGRect, titleTop: CGFloat) -> CGFloat {
    // 1
    let titleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 2
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
    // 3
    let titleStringSize = attributedTitle.size()
    // 4
    let titleStringRect = CGRect(x: 72,
                                 y: titleTop, width: titleStringSize.width,
                                 height: titleStringSize.height)
    // 5
    attributedTitle.draw(in: titleStringRect)
    // 6
    return titleStringRect.origin.y + titleStringRect.size.height
  }
  

  func addBodyText(pageRect: CGRect, textTop: CGFloat) {
    // 1
    let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 2
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    // 3
    let textAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: textFont
    ]
    let attributedText = NSAttributedString(string: body, attributes: textAttributes)
    // 4
    let textRect = CGRect(x: 72, y: textTop, width: pageRect.width - 144,
                          height: pageRect.height - textTop - pageRect.height / 5.0)
    attributedText.draw(in: textRect)
  }

  func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
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
    return imageRect.origin.y + imageRect.size.height
  }
  
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
