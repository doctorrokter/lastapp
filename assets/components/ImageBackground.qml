import bb.cascades 1.4
import chachkouski.util 1.0

WebImageView {
    id: backgroundImage
    
    property string direction: "up"
    
    image: ""
    
    onCreationCompleted: {
        bgTimer.start();
    }
    
    attachedObjects: [
        Timer {
            id: bgTimer
            
            property int threshold: 125
            property double slideStep: 0.05
            
            interval: 100
            
            onTimeout: {
                if (backgroundImage.translationY <= -bgTimer.threshold) {
                    backgroundImage.direction = "down";
                } else if (backgroundImage.translationY >= ui.du(0)) {
                    backgroundImage.direction = "up";
                }
                switch (backgroundImage.direction) {
                    case "up":
                        backgroundImage.translationY -= ui.du(bgTimer.slideStep);
                        break;
                    case "down":
                        backgroundImage.translationY += ui.du(bgTimer.slideStep);
                        break;
                }
            }
        }
    ]
}
