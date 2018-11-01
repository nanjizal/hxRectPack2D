package hxRectPack2D.rectangle;
class LTRB{
    public var l: Int = 0;
    public var t: Int = 0;
    public var r: Int = 0;
    public var b: Int = 0;
    public function new( l_: Int, t_: Int, r_: Int, b_: Int ){
        l = l_;
        t = t_;
        r = r_;
        b = b_;
    }
    public function w(){
        return ( r - l );
    }
    public function h(){
        return ( b - t );
    }
    inline
    public function area(): Int {
        return Std.int( w()*h() );
    }
    inline
    public function perimeter(): Int {
        return Std.int( 2*w() + 2*h() );
    }
    public function setW( ww: Int ){
        r = l + ww;
    }
    public function setH( hh: Int ){
        b = t + hh;
    }
    public function toXYWH(){
        var rect = new XYWH( l, t, 0, 0 );
        rect.setR( r );
        rect.setB( b );
        return rect;
    }
}