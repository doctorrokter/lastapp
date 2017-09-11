import bb.cascades 1.4

Container {
    id: root
    
    property string image: ""
    
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    
    layout: DockLayout {}
    
    attachedObjects: [
        LayoutUpdateHandler {
            id: rootLUH
        }
    ]
    
    ImageView {
        id: imageView
        
        filterColor: {
            if (root.image === "") {
                return ui.palette.plain;
            }
        }
        
        imageSource: {
            if (root.image === "") {
                return "asset:///images/ic_cd.png"
            }
        }
        scalingMethod: ScalingMethod.AspectFill
        horizontalAlignment: HorizontalAlignment.Center
        
        preferredWidth: rootLUH.layoutFrame.width
        preferredHeight: rootLUH.layoutFrame.height
    }
    
    ActivityIndicator {
        id: spinner
        running: false
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        minWidth: ui.du(10)
    }
    
    onImageChanged: {
        load();
    }
    
    onCreationCompleted: {
        _imageService.imageLoaded.connect(root.onImageLoaded);
        load();
    }
    
    function onImageLoaded(remotePath, localPath) {
        spinner.stop();
        if (root.image === remotePath) {
            if (localPath === "") {
                imageView.imageSource = "asset:///images/ic_cd.png";
            } else {
                imageView.imageSource = localPath;
            }
        }
    }
    
    function load() {
        spinner.start();
        _imageService.loadImage(root.image);
    }
}
