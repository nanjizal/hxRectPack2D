package hxRectPack2D.data;
import hxRectPack2D.rectangle.WH;
import hxRectPack2D.rectangle.XYWHF;
class Bin {
    public var size: WH;
    public var rects = new Array<XYWHF>();
    public function new(){
        size = new WH( 0, 0 );
    }
}