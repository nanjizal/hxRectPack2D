package hxRectPack2D.rectangle;
class XYWH extends WH {
    public var x: Int = 0;
    public var y: Int = 0;
    public function new( x_: Int, y_: Int, w_: Int, h_: Int ){
        super( w_, h_ );
        x = x_;
        y = y_;
    }
    public function r(){
        return x + w;
    }
    public function b(){
        return y + h;
    }
    public function setR( rr: Int ){
        w = (rr - x);
    }
    public function setB( bb: Int ){
        h = (bb - y);
    }
}