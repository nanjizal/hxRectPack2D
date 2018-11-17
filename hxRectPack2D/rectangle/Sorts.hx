package hxRectPack2D.rectangle;
import hxRectPack2D.rectangle.XYWHF;
class Sorts {
    public static inline function all(): Array< XYWHF->XYWHF->Int > {
        return [ area, perimeter, maxSide, maxWidth, maxHeight ];
    }
    public function new(){
    }
    public static inline
    function area( a: XYWHF , b: XYWHF ): Int {
        var aa = a.area();
        var ba = b.area();
        return if( aa > ba ){
            1;
        } else if( aa < ba ){
            -1;
        } else {
            0;
        }
    }
    public static inline
    function perimeter( a: XYWHF, b: XYWHF ): Int {
        var ap = a.perimeter();
        var bp = b.perimeter();
        return if( ap > bp ){
            1;
        } else if( ap < bp ){
            -1;
        } else {
            0;
        }
    }
    public static inline
    function maxSide( a: XYWHF, b: XYWHF ): Int {
        var am = Math.max( a.w, a.h );
        var bm = Math.max( b.w, b.h );
        return if( am > bm ){
            1;
        } else if( am < bm ){
            -1;
        } else {
            0;
        } 
    }
    public static inline
    function maxWidth( a: XYWHF, b: XYWHF ): Int {
        var aw = a.w;
        var bw = b.w;
        return if( aw > bw ){
            1;
        } else if( aw < bw ){
            -1;
        } else {
            0;
        } 
    }
    public static inline
    function maxHeight( a: XYWHF, b: XYWHF ): Int {
        var ah = a.h;
        var bh = b.h;
        return if( ah > bh ){
            1;
        } else if( ah < bh ){
            -1;
        } else {
            0;
        } 
    }
}