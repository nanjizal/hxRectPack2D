package hxRectPack2D.rectangle;
class WH{
    public var w: Int = 0;
    public var h: Int = 0;
    public function new( w_: Int = 0, h_: Int = 0 ){
        w = w_;
        h = h_;
    }
    inline
    public function area():Int {
        return Std.int( w*h );
    }
    inline
    public function perimeter(): Int{
        return Std.int( 2*w + 2*h );
    }
    public function fits( r: WH ): Int {
        if( w == r.w && h == r.h ) return 3;
        if( h == r.w && w == r.h ) return 4;
        if( w <= r.w && h <= r.h ) return 1;
        if( h <= r.w && w <= r.h ) return 2;
        return 0;
    }
}