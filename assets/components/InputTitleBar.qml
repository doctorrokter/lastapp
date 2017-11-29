import bb.cascades 1.4

TitleBar {
    id: root
    
    property string hintText: ""
    property bool showCancel: true
    
    signal cancel();
    signal typing(string text);

    appearance: TitleBarAppearance.Plain
    kind: TitleBarKind.FreeForm
    
    kindProperties: FreeFormTitleBarKindProperties {
        Container {
            background: ui.palette.primaryBase
            leftPadding: ui.du(1.5)
            rightPadding: ui.du(1.5)
            topPadding: ui.du(1.5)
            
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            
            
            TextField {
                id: tasksInputField
                
                backgroundVisible: false
                inputMode: TextFieldInputMode.Text
                hintText: root.hintText
                
                input {
                    keyLayout: KeyLayout.Text
                    submitKey: SubmitKey.EnterKey
                    onSubmitted: {
                        root.cancel();
                        tasksInputField.resetText();
                    }
                }
                textStyle.color: ui.palette.textOnPrimary
                
                onTextChanging: {
                    root.typing(text);
                }
            }
            
            Button {
                text: "X"
                maxWidth: ui.du(8)
                color: ui.palette.primary
                visible: root.showCancel
                
                onClicked: {
                    tasksInputField.resetText();
                    root.cancel();
                }
            }
        }
    }
    
    function focus() {
        tasksInputField.requestFocus();
    }
    
    function reset() {
        tasksInputField.resetText();
    }
    
    function value() {
        return tasksInputField.text;
    }
}