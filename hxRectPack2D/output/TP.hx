package hxRectPack2D.output;
import hxRectPack2D.rectangle.XYWHF;
typedef Location = {
    var x: Float;
    var y: Float;
    var w: Float;
    var h: Float;
}
// to make sure only valid image pixel formats are used and specified correctly.
// left off PVRTC, PVR and ETC since I don't think we can read write them with hxFormat
@:enum 
abstract PixelFormat( String ) from String to String {
    var RGBA8888 = 'RGBA8888'; // default only likely to support this 
    var RGBA4444 = 'RGBA4444';
    var RGBA5551 = 'RGBA5551';
    var RGBA5555 = 'RGBA5555';
    var BGRA8888 = 'BGRA8888'; // and maybe this
    var RGB888 = 'RGB888';
    var RGB565 = 'RGB565';
    var ALPHA  = 'ALPHA';
    var ALPHA_INTENSITY = 'ALPHA_INTENSITY';
}
class TP {
    var frames = new Array<String>();
    var meta: String;
    public function new(){}
    public function resetFrames(){
        frames = new Array<String>();
    }
    public
    function frameDefine( name: String, location: Location, block: XYWHF
                  , x2: Bool = false, trimmed_: Bool = false ): String {
        var x: Int;
        var y: Int;
        var w: Int;
        var h: Int;
        var ow: Int = block.w;
        var oh: Int = block.h;
        var flipped = block.flipped;
        var trimmed = trimmed_;
        var lx: Float;
        var ly: Float;
        var lw: Float;
        var lh: Float;
        // if scale is 2
        if( x2 ){
            x = block.x*2;
            y = block.y*2;
            w = block.w*2;
            h = block.h*2;
        } else {
            x = block.x;
            y = block.y;
            w = block.w;
            h = block.h;
        }
        // location on screen where you want your sprite.
        if( location == null ){
            lx = 0;
            ly = 0;
            lw = ow;
            lh = oh;
        } else {
            lx = location.x;
            ly = location.y;
            lw = location.w;
            lh = location.h;
        }
        var str = 
'   "$name":
    {
        "frame": {"x":$x,"y":$y,"w":$w,"h":$h},
        "rotated": $flipped,
        "trimmed": $trimmed,
        "spriteSourceSize": {"x":$lx,"y":$ly,"w":$lw,"h":$lh},
        "sourceSize": {"w":$ow,"h":$oh }
    }';
        frames[ frames.length ] = str;
        return str;
    }
    public
    function metaDefine( imageName_: String
                 , width_: Int, height_: Int
                 , format_: PixelFormat = RGBA8888
                 , scale_: Float = 1 ): String { // only 2x scale supported currently
        var imageName       = imageName_;
        var width           = width_;
        var height          = height_;
        var format: String  = format_;
        var scale           = Std.string( scale_ );
        var str =
'   "meta": {
        "app": "http://www.codeandweb.com/texturepacker",
        "version": "1.0",
        "image": "$imageName",
        "format": "$format",
        "size": {"w":$width,"h":$height},
        "scale": "$scale"
    }';
        meta = str;
        return str;
    }
    public
    function write(): String {
        var header = 
'{
    "frames": {
\n';
        var body = frames.join(',\n');
        return header + body + ',\n' + meta + '\n}';
    }
}