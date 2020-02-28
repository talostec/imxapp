import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
//import QtQml.Models 2.1

//#02b9db home界面小图片背景色

Rectangle {
    id:root
    color: "#00000000"

    FontLoader { id: fixedFont; name: "Courier" }
    FontLoader { id: localFont; source: "fonts/DIGITAL/DS-DIGIB.TTF" }
//    FontLoader { id: webFont; source: "http://www.princexml.com/fonts/steffmann/Starburst.ttf" }
    function fitWidth(text){
           return  fontMetrics.advanceWidth(text);
       }

    function addModelData(catalogue,cimage,cname,application,aimage,aqml,acolor){
        var index = findIndex(catalogue)
        console.log("addModeData:"+catalogue)
        if(index === -1){
            viewModel.append({"catalogue":catalogue,"cimage":cimage,"cname":cname,"level":0,
                                 "subNode":[{"application":application,"aimage":aimage,"acolor":acolor,"aqml":aqml,"level":1,"subNode":[]}]})
        }
        else{
            viewModel.get(index).subNode.append({"application":application,"aimage":aimage,"acolor":acolor,"aqml":aqml,"level":1,"subNode":[]})
        }

    }

    function findIndex(name){
        for(var i = 0 ; i < viewModel.count ; ++i){
            if(viewModel.get(i).catalogue === name){
                return i
            }
        }
        return -1
    }

    FontMetrics {
        id: fontMetrics
        font.family: "Microsoft YaHei"
        font.pixelSize: 20
    }

        //个性推荐的顶部，使用pathView
        Rectangle{
            id:pathViewRect;
            width: 720;
            height: 400;
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top;
            anchors.topMargin: 20
            color: "transparent";

            ListModel{
                id:viewModel;
//                ListElement{
//                    catalogue:"multimedia"
//                    cimage:"qrc:/images/wvga/home/homepage_media_nor.png"
//                    cname: qsTr("多媒体")
//                    subNode: [
//                        ListElement {
//                            aimage: "qrc:/images/wvga/home/cam.png"
//                            application: qsTr("摄像头")
//                            aqml: "SystemWindow.qml"
//                            acolor: "white"
//                        },
//                        ListElement {
//                            aimage:"qrc:/images/wvga/home/mpl.png"
//                            application: qsTr("播放器")
//                            aqml:"SystemWindow.qml"
//                            acolor:"black"
//                        }
//                    ]
//                }
//                ListElement{
//                    catalogue:"system"
//                    cimage:"qrc:/images/wvga/home/homepage_system_nor.png"
//                    cname: qsTr("系统")
//                }
//                ListElement{
//                    catalogue:"public"
//                    cimage:"qrc:/images/wvga/home/homepage_public_nor.png"
//                    cname: qsTr("公共服务")
//                }
//                ListElement{
//                    catalogue:"health"
//                    cimage:"qrc:/images/wvga/home/homepage_medical_nor.png"
//                    cname: qsTr("卫生医疗")
//                }
//                ListElement{
//                    catalogue:"machine"
//                    cimage:"qrc:/images/wvga/home/homepage_machine_nor.png"
//                    cname: qsTr("智能家电")
//                }
            }

            Component{
                id:viewDelegate;
                Item{
                    id:wrapper;
                    width: parent.width/2.5;
                    height: parent.height-20;
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    z:PathView.zOrder;
                    scale: PathView.itemScale;
                    Image {
                        id:image;
                        width: 225;
                        height: parent.height-80;
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: cimage;
                    }
                    ShaderEffect {
                        anchors.top: image.bottom
                        width: image.width
                        height: image.height/3;
                        anchors.left: image.left
                        property variant source: image;
                        property size sourceSize: Qt.size(0.5 / image.width, 0.5 / image.height);
                        fragmentShader:
                                "varying highp vec2 qt_TexCoord0;
                                uniform lowp sampler2D source;
                                uniform lowp vec2 sourceSize;
                                uniform lowp float qt_Opacity;
                                void main() {

                                    lowp vec2 tc = qt_TexCoord0 * vec2(1, -1) + vec2(0, 1);
                                    lowp vec4 col = 0.25 * (texture2D(source, tc + sourceSize) + texture2D(source, tc- sourceSize)
                                    + texture2D(source, tc + sourceSize * vec2(1, -1))
                                    + texture2D(source, tc + sourceSize * vec2(-1, 1)));
                                    gl_FragColor = col * qt_Opacity * (1.0 - qt_TexCoord0.y) * 0.2;
                                }"
                    }
                    Text{
                        width: parent.width;
                        height: 40;
                        anchors.bottom: image.bottom;
                        anchors.horizontalCenter: image.horizontalCenter
                        anchors.bottomMargin: 15;
                        text: cname;
                        horizontalAlignment: Text.AlignHCenter
                        color: "#dcdde4";
                        font.family: "Microsoft YaHei";
                        font.pixelSize: 30;
                        wrapMode: Text.Wrap;
                    }
                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true;
                        cursorShape: Qt.PointingHandCursor;

                        onClicked: {
                            if(index!==pathView.currentIndex)
                            {
                                pathView.currentIndex=index;
                                pageIndicator.currentIndex=index;
                            }
                            else
                            {
                                //打开链接
                            }
                        }
                    }
                }

            }

            PathView{
                id:pathView;
                anchors.fill: parent;
                interactive: true;
                currentIndex: pageIndicator.currentIndex;
                pathItemCount: 5;
                preferredHighlightBegin: 0.5;
                preferredHighlightEnd: 0.5;
                highlightRangeMode: PathView.StrictlyEnforceRange;

                delegate: viewDelegate;
                model: viewModel;

//                transform: Rotation{
//                    origin.x:image.width/2.0
//                    origin.y:image.height/2.0
//                    axis{x:0;y:1;z:0}
//                    angle: PathView.iconAngle
//                }

                path:Path{
                    startX:50;
                    startY:0;
                    PathAttribute{name:"zOrder";value:0}
                    PathAttribute{name:"itemScale";value:0.4}
                    PathLine{
                        x:pathView.width/4;
                        y:0;
                    }
                    PathAttribute{name:"zOrder";value:5}
                    PathAttribute{name:"itemScale";value:0.55}
                    PathLine{
                        x:pathView.width/2;
                        y:0;
                    }
                    PathAttribute{name:"zOrder";value:10}
                    PathAttribute{name:"itemScale";value:1}
                    PathLine{
                        x:pathView.width*0.75;
                        y:0;
                    }
                    PathAttribute{name:"zOrder";value:5}
                    PathAttribute{name:"itemScale";value:0.55}
                    PathLine{
                        x:pathView.width-50;
                        y:0;
                    }
                    PathAttribute{name:"zOrder";value:0}
                    PathAttribute{name:"itemScale";value:0.4}
                }
            }

            Image{
                id: pointer
                source: "qrc:/images/wvga/home/icon_arrow_.png"
                anchors{
                    bottom:pathViewRect.bottom
                    horizontalCenter: pathViewRect.horizontalCenter
                    bottomMargin: 75
                }
            }
            Rectangle{
                id: subMenu
                width: 800
                height: 55
//                radius: 20
                color: Qt.rgba(0,0xff,0xff,0.1)
                anchors{
                    bottom:pathViewRect.bottom
                    horizontalCenter: pathViewRect.horizontalCenter
                    bottomMargin: 20
                }

                RowLayout{
                    id: subMenuRow
                    width: 800
                    height: 55

//                    anchors{
//                        fill:parent
//                        top: pointer.bottom
//                        horizontalCenter: subMenu.horizontalCenter
//                    }

                    Repeater{
//                        anchors{
//                            horizontalCenter: subMenu.horizontalCenter
//                        }
                        model:{
                            var index = findIndex("multimedia")
                            console.log("index="+index)
                            console.log("currentIndex="+pathView.currentIndex)
                            if(pathView.currentIndex>0)
                            {
                                index = pathView.currentIndex;
                            }
                            console.log("index="+index)
                            viewModel.get(index/*pathView.currentIndex*/).subNode
                        }
                        Rectangle{
                            id:rootrect
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredWidth:128
                            Layout.preferredHeight:48
                            color: Qt.rgba(0,0,0,0)

                            Rectangle{
                                id: appRect
                                implicitWidth: {
                                    var wid = fitWidth(tt.text)+55
                                    console.log("wid:"+wid)
                                    Math.min(wid,160)
                                }
                                implicitHeight: 42
                                radius: 10
                                color: model.acolor
                                anchors{
                                    verticalCenter: parent.verticalCenter
                                    leftMargin: 20
                                }

                                Image{
                                    id: appicon
                                    width: 24
                                    height: 24
                                    source: model.aimage
                                    anchors{
                                        left: parent.left
                                        verticalCenter: parent.verticalCenter
                                        leftMargin: 10
                                    }
                                }

                                Text{
                                    id:tt
                                    text: model.application
                                    color: "#dcdde4";
                                    font.family: "Microsoft YaHei";
                                    font.pixelSize: 20;
//                                    wrapMode: Text.Wrap;
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                        left: appicon.right
                                        leftMargin: 10
                                        right: parent.right
                                        rightMargin: 10
                                    }

                                }

                                MouseArea{
                                    anchors.fill: parent;
                                    hoverEnabled: true;
                                    cursorShape: Qt.PointingHandCursor;

                                    onClicked: {
                                        console.log("clicked:"+model.aqml)
                                        var obj = Qt.createComponent(model.aqml).createObject(mainWnd)
                        //                        obj.z = 4;
                                        obj.show()                                    }
                                }
                            }
                        }

                    }

                }
            }

            PageIndicator{
                id:pageIndicator;
                visible: false
                interactive: true;
                count:pathView.count;
                currentIndex: pathView.currentIndex;
                height: 7;
                anchors.bottom: parent.bottom;
                anchors.horizontalCenter: parent.horizontalCenter;
                delegate: Rectangle{
                    implicitWidth: 20;
                    implicitHeight: 2;
                    color: "#7F8082";
                    opacity: index === pageIndicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 500
                        }
                    }

                }

                onCurrentIndexChanged: {
//                    timer.running=false;
//                    timer.running=true;
                    console.log("currentIndexChanged:"+ currentIndex)
                }
            }

//            //Timer
//            Timer{
//                id:timer;
//                interval: 7500;
//                repeat: true;
//                running: false;
//                onTriggered: {
//                    pageIndicator.currentIndex=(pageIndicator.currentIndex+1)%(pathView.count);
//                }
//            }

//            Component.onCompleted: {
//                timer.running=true;
//            }
        }


//    property string myText: "1234567890:."

//    property int size: 40
////    anchors.fill: parent
//    Rectangle {

//        width: 320; height: 450
////        color: "#00000000"


//        Column {
//            anchors { fill: parent; leftMargin: 10; rightMargin: 10; topMargin: 10 }
//            spacing: 15

//            Text {
//                text: myText
//                color: "lightsteelblue"
//                width: parent.width
//                wrapMode: Text.WordWrap
//                font.family: "Times"
//                font.pixelSize: size
//            }
//            Text {
//                text: myText
//                color: "lightsteelblue"
//                width: parent.width
//                wrapMode: Text.WordWrap
//                horizontalAlignment: Text.AlignHCenter
//                font { family: "Times"; pixelSize: size; capitalization: Font.AllUppercase }
//            }
//            Text {
//                text: myText
//                color: "lightsteelblue"
//                width: parent.width
//                horizontalAlignment: Text.AlignRight
//                wrapMode: Text.WordWrap
//                font { family: fixedFont.name; pixelSize: size; weight: Font.Bold; capitalization: Font.AllLowercase }
//            }
//            Text {
//                text: myText
//                color: "lightsteelblue"
//                width: parent.width
//                wrapMode: Text.WordWrap
//                font { family: fixedFont.name; pixelSize: size; italic: true; capitalization: Font.SmallCaps }
//            }
//            Text {
//                text: myText
//                color: "lightsteelblue"
//                width: parent.width
//                wrapMode: Text.WordWrap
//                font { family: localFont.name; pixelSize: size; capitalization: Font.Capitalize }
//            }
//            Text {
//                text: {
//                    if (webFont.status == FontLoader.Ready) myText
//                    else if (webFont.status == FontLoader.Loading) "Loading..."
//                    else if (webFont.status == FontLoader.Error) "Error loading font"
//                }
//                color: "lightsteelblue"
//                width: parent.width
//                wrapMode: Text.WordWrap
//                font.family: webFont.name; font.pixelSize: size
//            }
//        }
//    }

    HomeButton {
        text: qsTr("toMENU")
        label.visible: false
        source:"images/wvga/home/home.png"
//        width: 30
//        height: 30
        glowRadius: 20
//        z: 2

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: height * 0.5
            }

        onClicked: {
               mainWnd.chooseWnd("MENU")
        }

    Component.onCompleted: {
//1
        addModelData(
                    "multimedia",
                    "qrc:/images/wvga/home/homepage_media_nor.png",
                    qsTr("多媒体"),
                    qsTr("摄像头"),
                    "qrc:/images/wvga/home/media_icon_camera_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
//2
        addModelData(
                    "multimedia",
                    "qrc:/images/wvga/home/homepage_media_nor.png",
                    qsTr("多媒体"),
                    qsTr("播放器"),
                    "qrc:/images/wvga/home/media_icon_video_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
        //3
        addModelData(
                    "system",
                    "qrc:/images/wvga/home/homepage_system_nor.png",
                    qsTr("系统"),
                    qsTr("系统信息"),
                    "qrc:/images/wvga/home/system_icon_info_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
        //4
        addModelData(
                    "system",
                    "qrc:/images/wvga/home/homepage_system_nor.png",
                    qsTr("系统"),
                    qsTr("系统设置"),
                    "qrc:/images/wvga/home/system_icon_set_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
        //5
        addModelData(
                    "machine",
                    "qrc:/images/wvga/home/homepage_machine_nor.png",
                    qsTr("智能家电"),
                    qsTr("洗衣机"),
                    "qrc:/images/wvga/home/smart_icon_washing_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
        //6
        addModelData(
                    "health",
                    "qrc:/images/wvga/home/homepage_medical_nor.png",
                    qsTr("卫生医疗"),
                    qsTr("心电仪"),
                    "qrc:/images/wvga/home/medical_icon_heart_nor.png",
                    "scope.qml",
                    "#02b9db"
                    )
        //7
        addModelData(
                    "public",
                    "qrc:/images/wvga/home/homepage_public_nor.png",
                    qsTr("公共服务"),
                    qsTr("取票机"),
                    "qrc:/images/wvga/home/public_icon_ticket_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
        //8
        addModelData(
                    "system",
                    "qrc:/images/wvga/home/homepage_system_nor.png",
                    qsTr("系统"),
                    qsTr("文件管理器"),
                    "qrc:/images/wvga/home/media_icon_doc.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
        //9
        addModelData(
                    "multimedia",
                    "qrc:/images/wvga/home/homepage_media_nor.png",
                    qsTr("多媒体"),
                    qsTr("图片"),
                    "qrc:/images/wvga/home/media_icon_img_nor.png",
                    "SystemWindow.qml",
                    "#02b9db"
                    )
    }
    }
}