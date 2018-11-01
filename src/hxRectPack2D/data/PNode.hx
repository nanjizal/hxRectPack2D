package hxRectPack2D.data;
import hxRectPack2D.rectangle.LTRB;
class PNode {
    public var pn: Null<Node> = null;
    public var fill: Bool = false;
    public function new(){}
    public function init( l: Int, t: Int, r: Int, b: Int ){
        if( pn == null ) {
            pn = new Node( new LTRB( l, t, r, b ) );
        } else {
            pn.rc = new LTRB( l, t, r, b );
            pn.id = false;
        }
        fill = true;
    }
}
