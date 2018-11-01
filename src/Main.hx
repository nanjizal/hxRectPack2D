package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import kha.Color;
import kha.Assets;
import kha.math.FastMatrix3;
import kha.Scheduler;
import kha.graphics2.Graphics;
import hxRectPack2D.RectPack2D;
import hxRectPack2D.rectangle.XYWHF;
import hxRectPack2D.data.Bin;
class Main {
    var blocks          = new Array<XYWHF>();
    var bins            = new Array<Bin>();
    var colors = [ Color.Red, Color.Blue, Color.Green, Color.Yellow, Color.Pink, Color.Orange, Color.Cyan, Color.Purple, Color.Magenta ];
    var packSize        = 400;
    var totalBlocks     = 200;
    var minSize         = 3;
    var maxSize         = 150;
    var colorIndex      = 0;
    public static 
    function main() {
        System.init( {  title: "hxRectPack2D Test Using Kha"
                     ,  width: 1024, height: 768
                     ,  samplesPerPixel: 4 }
                     , function(){
                        new Main();
                     } );
    }
    public function new(){
        Assets.loadEverything( loadAll );
    }
    public function loadAll(){
        createBlocks();
        Pack();
        startRendering();
    }
    inline
    function createBlocks(){
        for( i in 0...totalBlocks ){ // could improve lower bound random.
            var w = Std.int( Math.max( minSize, Math.random()*maxSize ) );
            var h = Std.int( Math.max( minSize, Math.random()*maxSize ) );
            blocks[ i ] = new XYWHF( 0, 0, w, h );
        }
    }
    inline
    function Pack(){
        RectPack2D.pack( blocks, packSize, bins );
    }
    inline
    function startRendering(){
        System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    inline
    function render( framebuffer: Framebuffer ): Void {
        colorIndex = 0;
        var g: Graphics = framebuffer.g2;
        g.begin();
        var block: XYWHF;
        var left:   Int;
        var right:  Int;
        var top:    Int;
        var bottom: Int;
        var wid:    Int;
        var hi:     Int;
        for ( j in 0...bins.length ){
            var bin0 = bins[ j ].rects;
            var xoff = j*packSize;
            for( i in 0...bin0.length ){
                block = bin0[ i ];
                g.opacity = 0.8;
                g.color = colors[ colorIndex ];
                left    = xoff + block.x;
                top     = block.y;
                right   = xoff + block.x + block.w;
                bottom  = block.y + block.h;
                wid     = block.w;
                hi      = block.h;
                // draw block
                g.fillRect( left, top, wid, hi );
                if( block.flipped ) {
                    // draw cross if block flipped
                    incColor();
                    g.color = colors[ colorIndex ];
                    g.drawLine( left, top, right, bottom, 2. );
                    g.drawLine( right, top, left, bottom, 2. );
                    g.drawRect( left, top, wid, hi, 2. );
                }
                incColor();
            }
        }
        g.end();
    }
    inline
    function incColor(){
        colorIndex++;
        if( colorIndex > colors.length - 1 ) colorIndex = 0;
    }
}