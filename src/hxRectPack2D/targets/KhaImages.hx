package hxRectPack2D.targets;
import kha.math.FastMatrix3;
import hxRectPack2D.rectangle.XYWHF;
import kha.graphics2.Graphics;
import hxRectPack2D.output.TP;
import kha.Assets;
import kha.Image;
import kha.Font;
import kha.Color;
class KhaImages {
    public var showLabel        = false;
    public var showBackColor    = false;
    public var showImage        = true;
    public var showCross        = false;
    public var scale            = 1;
    var images                  = new Array<Image>();
    var names:                  Array<String>;
    var colors = [ Color.Red
                 , Color.Blue
                 , Color.Green
                 , Color.Yellow
                 , Color.Pink
                 , Color.Orange
                 , Color.Cyan
                 , Color.Purple
                 , Color.Magenta ];
    public var colorIndex = 0;
    // set by block in render loop
    var g:       Graphics;
    var image:   Image;
    var left:    Int;
    var top:     Int;
    var right:   Int;
    var bottom:  Int;
    var wid:     Int;
    var hi:      Int;
    public function new(){}
    inline public 
    function createImageBlocks(){
        var imageList = kha.Assets.images;
        names = imageList.names;
        var img: Image;
        var blocks = new Array<XYWHF>();
        for( i in 0...names.length ){
            img = Reflect.field( imageList, names[ i ] );
            images[ images.length ] = img;
            blocks[ i ] = new XYWHF( i, 0, 0, img.width, img.height );
        }
        return blocks;
    }
    inline function currColor() return colors[ colorIndex ];
    inline function incColor() if( colorIndex++ > colors.length - 2 ) colorIndex = 0;
    inline
    public function drawBlock( g_: Graphics, block: XYWHF, xoff: Int, tp: TP ){
        var id       = block.id;
        var name     = names[ id ];
        var scale    = 1;
        var flipped  = block.flipped;
        g            = g_;
        image        = images[ id ];
        setDimensions( block, xoff );
        var location = null;
        tp.frameDefine( name, location, block );
        if( showBackColor ) fillRect();
        // trace( block.string( name ) );
        if( flipped ){
            if( showImage ) drawFlippedImage();
        } else {
            if( showImage ) drawImage();
        }
        var str = ' ' + name + ' ';
        if( showLabel ) drawLabel( str );
        if( flipped && showBackColor ) flippedOutline( showCross );
    }
    inline
    function setDimensions( block: XYWHF, xoff: Int ){
        if( scale == 1 ){
            left     = xoff + block.x;
            top      = block.y;
            right    = xoff + ( block.x + block.w );
            bottom   = ( block.y + block.h );
            wid      = block.w;
            hi       = block.h;
        } else {
            left     = xoff + block.x * scale;
            top      = block.y * scale;
            right    = xoff + ( block.x + block.w )*scale ;
            bottom   = ( block.y + block.h )*scale;
            wid      = block.w* scale;
            hi       = block.h* scale;
        }
    }
    inline
    function fillRect(){
        g.opacity = 0.7;
        g.color = currColor();
        g.fillRect( left, top, wid, hi );
        incColor();
    }
    inline
    function flippedOutline( cross: Bool){
        g.opacity = 0.5;
        g.color = currColor();
        if( cross ){
            g.drawLine( left, top, right, bottom, 2. );
            g.drawLine( right, top, left, bottom, 2. );
        }
        g.drawRect( left, top, wid, hi, 2. );
        incColor();
    }
    inline
    function drawImage(){
        g.opacity = 1.;
        g.color   = Color.White;
        if( scale == 1 ){
            g.drawImage( image, left, top );
        } else {
            g.transformation = FastMatrix3.translation( -left, -top )
                                        .multmat( FastMatrix3.scale( scale, scale ) )
                                        .multmat( FastMatrix3.translation( left, top ) );
            g.drawImage( image, 0, 0 );
            g.transformation = FastMatrix3.identity();
        }
    }
    inline
    function drawFlippedImage(){
        g.opacity = 1.;
        g.color = Color.White;
        var transform = g.transformation;
        if( scale == 1 ){
            g.transformation = FastMatrix3.translation( left + wid, top + hi )
                               .multmat( FastMatrix3.rotation( Math.PI/2 ) )
                               .multmat( FastMatrix3.translation( -hi, 0 ) );
        } else {
            g.transformation = FastMatrix3.translation( left + wid, top + hi )
                               .multmat( FastMatrix3.rotation( Math.PI/2 ) )
                               .multmat( FastMatrix3.translation( -hi, 0 ) )
                               .multmat( FastMatrix3.scale( scale, scale ) );
        }
        g.drawImage( image, 0, 0 );
        incColor();
        g.transformation = FastMatrix3.identity();
    }
    inline
    function drawLabel( str: String ){
        g.color = Color.White;
        var font = g.font;
        var size = g.fontSize;
        var strWidth = font.width( size, str );
        var strHeight = font.height( size );
        var str2 = ''; // wrap string
        while( strWidth > wid && str.length > 0 ){
            str2        = str.substr( str.length - 1, 1 ) + str2;
            str         = str.substr( 0, str.length - 1 );
            strWidth    = font.width( g.fontSize, str );
        }
        if( str2.length != 0 ) str2 = ' ' + str2;
        if( strWidth < wid ){
            g.opacity = 0.6;
            g.fillRect( left + 1 , top + 1, strWidth, strHeight );
            if( str2.length != 0 ){
                g.fillRect( left + 1, top + 1 + strHeight, strWidth, strHeight * 0.7 );
            }
            g.color = Color.fromValue( 0xFF0000FF );
            g.opacity = 1.;
            g.drawString( str, left, top );
            if( str2.length != 0 ){
                g.drawString( str2, left, top + strHeight * 0.7 );
            }
        }
    }
}