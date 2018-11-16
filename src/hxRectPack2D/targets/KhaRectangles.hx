package hxRectPack2D.targets;
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
class KhaRectangles {
    public var colorIndex      = 0;
    var colors = [ Color.Red
                 , Color.Blue
                 , Color.Green
                 , Color.Yellow
                 , Color.Pink
                 , Color.Orange
                 , Color.Cyan
                 , Color.Purple
                 , Color.Magenta ];
    var totalBlocks      = 200;
    var minSize          = 3;
    var maxSize          = 150;
    public function new(){}
    inline public
    function createBlocks(){
        var blocks = new Array<XYWHF>();
        for( i in 0...totalBlocks ){ // could improve lower bound random.
            var w = Std.int( Math.max( minSize, Math.random()*maxSize ) );
            var h = Std.int( Math.max( minSize, Math.random()*maxSize ) );
            blocks[ i ] = new XYWHF( i, 0, 0, w, h );
        }
        return blocks;
    }
    inline function currColor() return colors[ colorIndex ];
    inline function incColor() if( colorIndex++ > colors.length - 2 ) colorIndex = 0;
    inline public
    function drawBlock( g: Graphics, block: XYWHF, xoff: Int ){
        g.opacity = 0.8;
        g.color = currColor();
        var left    = xoff + block.x;
        var top     = block.y;
        var right   = xoff + block.x + block.w;
        var bottom  = block.y + block.h;
        var wid     = block.w;
        var hi      = block.h;
        incColor();
        // draw block
        g.fillRect( left, top, wid, hi );
        if( block.flipped ) {
            // draw cross if block flipped
            incColor();
            g.color = currColor();
            g.drawLine( left, top, right, bottom, 2. );
            g.drawLine( right, top, left, bottom, 2. );
            g.drawRect( left, top, wid, hi, 2. );
        }
        incColor();
    }
}