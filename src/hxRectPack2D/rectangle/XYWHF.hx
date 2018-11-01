package hxRectPack2D.rectangle;
class XYWHF extends XYWH {
    public var flipped = false;
    public function new( x_: Int, y_: Int, w_: Int, h_: Int ){
        super( x_, y_, w_, h_ );
    }
    public function flip(){
        flipped = !flipped;
        var t = w;
        w = h;
        h = t;
    }
    public function clone(){
        var res = new XYWHF( x, y, w, h );
        res.flipped = flipped;
        return res;
    }
    public static inline function sorts():Array< XYWHF->XYWHF->Int >{
        return Sorts.all();
    }
}