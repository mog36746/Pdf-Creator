//
//  PDFPreviewViewController.swift
//  Pdf Creator
//
//  Created by Md. Mazidul Islam on 4/3/20.
//  Copyright © 2020 Jon. All rights reserved.
//

import UIKit
import PDFKit

class PDFPreviewViewController: UIViewController {
  public var documentData: Data?
  @IBOutlet weak var pdfView: PDFView!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String )
    
    if let data = documentData {
      pdfView.document = PDFDocument(data: data)
      pdfView.autoScales = true
      
    }
  }
}
