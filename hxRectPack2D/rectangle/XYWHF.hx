package hxRectPack2D.rectangle;
class XYWHF extends XYWH {
    public var flipped = false;
    public var id: Int;
    public function new( id_: Int, x_: Int, y_: Int, w_: Int, h_: Int ){
        super( x_, y_, w_, h_ );
        id = id_;
    }
    public function flip(){
        flipped = !flipped;
        var t = w;
        w = h;
        h = t;
    }
    public function clone(){
        var res = new XYWHF( id, x, y, w, h );
        res.flipped = flipped;
        return res;
    }
    public static inline function sorts():Array< XYWHF->XYWHF->Int >{
        return Sorts.all();
    }
    public function toObject( name: String = '' ){
        return { id: id, name: name, x: x, y: y, width: w, height: h };
    }
    public function string( name: String ){
        return Std.string( toObject( name ) );
    }
}
