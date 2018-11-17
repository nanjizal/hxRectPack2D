package;
import kha.Framebuffer;
import kha.System;
import kha.Assets;
import kha.Font;
import kha.Color;
import kha.Scheduler;
import kha.graphics2.Graphics;
import hxRectPack2D.RectPack2D;
import hxRectPack2D.rectangle.XYWHF;
import hxRectPack2D.data.Bin;
import hxRectPack2D.targets.KhaImages;
import hxRectPack2D.targets.KhaRectangles;
import kha.input.Mouse;
import kha.graphics2.GraphicsExtension;
import hxRectPack2D.targets.ViewOptions;
import hxRectPack2D.output.TP;
using kha.graphics2.GraphicsExtension;
enum DemoEnum {
    ImageDemo;
    RectangleDemo;
}
class RectPack2Demo {
    var busy             = false;
    var blocks           = new Array<XYWHF>();
    var bins             = new Array<Bin>();
    var khaImages        = new KhaImages();
    var khaRectangles    = new KhaRectangles();
    var imageOption      = new ViewOptions( 400 + 90, 610 );
    var demoOption       = new ViewOptions( 590 + 90, 610 );
    var scaleOption      = new ViewOptions( 780 + 90, 610 );
    var tp               = new TP();
    var packSize         = 300;//400;
    var font:            Font;
    var lastColorIndex   = 0;
    var outputWidth:     Int;
    // Change here to switch between demo types.
    var demoType:  DemoEnum = ImageDemo;
    inline
    function imageSheetRenderOptions(){
        khaImages.showImage     = true;
        khaImages.showLabel     = true;
        khaImages.showBackColor = true;
        khaImages.showCross     = true; // dependant on if backColor on.
    }
    public static 
    function main() {
        trace('main started');
        System.init( {  title: "hxRectPack2D Test Using Kha"
                     ,  width: 1024, height: 768
                     ,  samplesPerPixel: 4 }
                     , function(){
                        new RectPack2Demo();
                     } );
    }
    public
    function new(){
        trace('new RectPackDemo');
        Assets.loadEverything( loadAll );
    }
    public
    function loadAll(){
        trace('load all ');
        imageSheetRenderOptions();
        setupOptions();
        rebuild();
        startRendering();
    }
    inline
    function setupOptions(){
        // Options for Image rendering like showing labels on each image.
        imageOption.optionType = CROSS;
        imageOption.state = [ true, true, true, true ];
        imageOption.labels = [ 'show image'
                             , 'show label'
                             , 'show back color'
                             , 'show cross' ];
        imageOption.optionChange = optionChange;
        imageOption.optionOver = optionOver;
        // Options of demo type to show either just Rectangles of Zebra parts.
        demoOption.optionType = ROUND;
        demoOption.state = [ true, false ];
        demoOption.labels = [ 'image demo'
                            , 'rectangle demo' ];
        demoOption.optionChange = demoChange;
        demoOption.optionOver = optionOver;
        // Scale option 
        scaleOption.optionType = TICK;
        scaleOption.state = [ false ];
        scaleOption.labels = [ 'x2 Image' ];
        scaleOption.optionChange = scaleChange;
        scaleOption.optionOver = optionOver;
    }
    inline
    function scaleChange( id: Int, state: Array<Bool> ){
        if( state[ 0 ] ) {
            khaImages.scale = 2; // other scales probably don't work
        } else {
            khaImages.scale = 1;
        }
        bins = new Array<Bin>();
        rebuild();
        clean = false;
    }
    inline
    function demoChange( id: Int, state: Array<Bool> ){
        switch( id ){
            case 0: 
                demoType = ImageDemo;
            case 1:
                demoType = RectangleDemo;
        }
        bins = new Array<Bin>();
        rebuild();
        clean = false;
    }
    public
    function optionChange( id: Int, state: Array<Bool> ){
        var value = state[ id ];
        switch( id ){
            case 0:
                khaImages.showImage     = value;
            case 1:
                khaImages.showLabel     = value;
            case 2:
                khaImages.showBackColor = value;
            case 3:
                khaImages.showCross     = value;
            case _:
                //
        }
        bins = new Array<Bin>();
        rebuild();
        clean = false;
    }
    public
    function optionOver( id: Int ){
        clean = false;
    }
    inline
    function rebuild(){
        switch( demoType ){
            case ImageDemo:
                font = Assets.fonts.OpenSans_Regular;
                blocks = khaImages.createImageBlocks();
            case RectangleDemo:
                blocks = khaRectangles.createBlocks();
        }
        Pack();
    }
    inline
    function Pack(){
        busy = true;
        RectPack2D.pack( blocks, packSize, bins );
        outputWidth = packSize*bins.length;
        tp.metaDefine( 'output.png', outputWidth, packSize );
        busy = false;
    }
    inline
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
        if (Mouse.get() != null) Mouse.get().notify( mouseDown, null, mouseOver, null );
    }
    inline
    function mouseDown( button: Int, x: Int, y: Int ): Void {
        if( busy ) return;
        imageOption.hitCheck( x, y );
        demoOption.hitCheck(  x, y );
        scaleOption.hitCheck( x, y );
    }
    inline
    function mouseOver( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        if( busy ) return;
        khaImages.colorIndex = lastColorIndex;
        imageOption.hitOver( x, y );
        demoOption.hitOver(  x, y );
        scaleOption.hitOver( x, y );
    }
    var clean: Bool = false;
    function render( framebuffer: Framebuffer ): Void {
        //( clean )? return: clean = true;
        var g = framebuffer.g2;
        g.begin();
        switch( demoType ){
            case ImageDemo:
                g.font = font;
                g.fontSize = 20;
                drawImageSheet( g );
            case RectangleDemo:
                drawRectangleSheet( g );
        }
        if( demoType == ImageDemo ) {
            imageOption.renderView( g );
            scaleOption.renderView( g );
        }
        demoOption.renderView( g );
        g.end();
    }
    inline
    function drawImageSheet( g: Graphics ){
        tp.resetFrames();
        lastColorIndex = khaImages.colorIndex;
        var factor = ( khaImages.scale == 1 )? packSize: packSize*khaImages.scale;
        for ( j in 0...bins.length ){
            var bin0 = bins[ j ].rects;
            var xoff = j*factor;
            for( i in 0...bin0.length ){
                khaImages.drawBlock( g, bin0[ i ], xoff, tp );
            }
        }
        khaImages.colorIndex = lastColorIndex;
        trace( 'texture pack file:\n ' + tp.write() );
    }
    inline
    function drawRectangleSheet( g: Graphics ){
        khaRectangles.colorIndex = 0;
        for ( j in 0...bins.length ){
            var bin0 = bins[ j ].rects;
            var xoff = j*packSize;
            for( i in 0...bin0.length ){
                khaRectangles.drawBlock( g, bin0[ i ], xoff );
            }
        }
    }
}