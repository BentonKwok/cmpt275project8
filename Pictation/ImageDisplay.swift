import UIKit

/* A UIStackView subclass to implement the displayed images at the top of
 * intermediate and advanced levels. It also keeps track of the words associated with the
 * selected images and stores them in the selectedText property which is a String array
 * that is not set to private in order to be accessible for sentence processing
 */
@IBDesignable class ImageDisplay: UIStackView {
    //MARK: Properties
    private var selectedImages = [UIImageView]()
    private var numSubViews = 0
    @IBInspectable var imageSize: CGSize = CGSize(width: 60.0, height: 60.0)
    var selectedText = [String]()
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addArrangedSubview(UIImageView())
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        addArrangedSubview(UIImageView())
    }
    
    //MARK: Actions
    //Adds images and text passed in into the their containers in the object
    func addImage( newImage : UIImage?, newText : String?, maxSubViews : Int){
        if(numSubViews < maxSubViews){
            let newImageView = UIImageView()
            guard (newText != nil && newImage != nil) else{
                print("Passed in Image or Txt is nil in: ImageDisplay.addImage( )")
                return
            }
            newImageView.image = newImage!
            //a bunch of properites to make sure the image views resize correctly
            newImageView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleBottomMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleRightMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleLeftMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleTopMargin.rawValue) | UInt8(UIViewAutoresizing.flexibleWidth.rawValue)))
            newImageView.contentMode = UIViewContentMode.scaleAspectFit
            newImageView.translatesAutoresizingMaskIntoConstraints = false
            newImageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
            newImageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
          
            selectedImages.append(newImageView)
            selectedText.append(newText!)
            
            //add to the stack
            addArrangedSubview(newImageView)
            numSubViews += 1
        }
    }
    
    //resets the ImageDisplayObject
    func reset( ){
        if(numSubViews > 0){
            selectedText.removeAll()
            //remove pictures from the stack
            for view in selectedImages{
                view.removeFromSuperview()
            }
            
            selectedImages.removeAll()
            numSubViews = 0
        }
    }
}
