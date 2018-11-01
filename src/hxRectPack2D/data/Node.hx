package hxRectPack2D.data;
import hxRectPack2D.rectangle.LTRB;
import hxRectPack2D.rectangle.WH;
import hxRectPack2D.rectangle.XYWHF;
class Node {
    public var c0 = new PNode();
    public var c1 = new PNode();
    public var rc: LTRB;
    public var id: Bool = false;
    public function new( rc_: LTRB ){
        rc = rc_;
    }
    public function reset( wh: WH ){
        id = false;
        rc = new LTRB( 0, 0, wh.w, wh.h );
        delcheck();
    }
    public function insert( rect: XYWHF ){
        if( c0.pn != null && c0.fill ){
            var newn = c0.pn.insert( rect );
            if( newn != null ) return newn;
            return c1.pn.insert( rect );
        }
        if( id ) return null;
        var f: Int = rect.fits( rc.toXYWH() );
        switch( f ){
            case 0: 
                return null;
            case 1: 
                rect.flipped = false;
            case 2: 
                rect.flipped = true;
            case 3: 
                id = true; 
                rect.flipped = false; 
                return this;
            case 4: 
                id = true;
                rect.flipped = true;
                return this;
        }
        var iw = ( rect.flipped )? rect.h: rect.w; 
        var ih = ( rect.flipped )? rect.w: rect.h;
        if( ( rc.w() - iw ) > ( rc.h() - ih ) ) {
            c0.init( rc.l,        rc.t, rc.l + iw, rc.b );
            c1.init( rc.l + iw,   rc.t, rc.r,      rc.b );
        } else {
            c0.init( rc.l, rc.t,      rc.r, rc.t + ih );
            c1.init( rc.l, rc.t + ih, rc.r, rc.b );
        }
        return c0.pn.insert( rect );
    }
    function delcheck(){
      if( c0.pn != null ){ 
          c0.fill = false; 
          c0.pn.delcheck(); 
      }
      if( c1.pn != null ){ 
          c1.fill = false;
          c1.pn.delcheck();
      }
    }
    
}