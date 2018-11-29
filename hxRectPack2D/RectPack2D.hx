package hxRectPack2D;
import hxRectPack2D.rectangle.XYWHF;
import hxRectPack2D.rectangle.LTRB;
import hxRectPack2D.rectangle.WH;
import hxRectPack2D.data.Bin;
import hxRectPack2D.data.Node;
class RectPack2D {
    public inline static var discardStep = 128;
    public function new(){}
    static function rect2D(  v:    Array<XYWHF>, maxS: Int
                           , succ: Array<XYWHF>, unsucc: Array<XYWHF> ){
        var root = new Node( new LTRB( 0, 0, 0, 0 ) );
        var n    = v.length;
        var order = [];
        var sorts = XYWHF.sorts();
        var len = sorts.length;
        for( i in 0...len ){ 
            var cpy = v.slice( 0 );
            haxe.ds.ArraySort.sort( cpy, sorts[ i ] );
            order[ i ] = cpy;
        }
        var minBin = new WH( maxS, maxS );
        var minFunc = -1;
        var bestFunc = 0;
        var bestArea = 0;
        var _area = 0;
        var step: Float = 0;
        var fit;
        var i;
        var fail = false;
        var rect: XYWHF;
        var rc: LTRB;
        for( f in 0...len ){
            v = order[ f ];
            step = ( minBin.w / 2 );
            root.reset( minBin );
            while( true ){
                if( root.rc.w() > minBin.w ){
                    if( minFunc > -1 ) break;
                    _area = 0;
                    root.reset( minBin );
                    for( i in 0...n ){
                        var rect = v[ i ];
                        if( root.insert( rect ) != null ) _area += rect.area();
                    }
                    fail = true;
                    break;
                }
                fit = -1;
                for( i in 0...n ){
                    if( root.insert( v[ i ] ) == null ){
                        fit = 1;
                        break;
                    }
                }
                if( fit == -1 && step <= discardStep ) break;
                rc = root.rc;
                var fs = Std.int( fit*step );
                root.reset( new WH( rc.w() + fs, rc.h() + fs ) );
                step = step/2;
                if( step == Math.NaN || step == 0 ) step = 1;
            }
            rc = root.rc;
            if( !fail && ( minBin.area() >= rc.area() )) {
                minBin = new WH( rc.w(), rc.h() );
                minFunc = f;
            } else if( fail && ( _area > bestArea) ){
                bestArea = _area;
                bestFunc = f;
            }
            fail = false;
        }
        v = order[ minFunc == -1 ? bestFunc : minFunc ];
        var clipX = 0;
        var clipY = 0;
        var ret: Node;
        root.reset( minBin );
        for( i in 0...n ){
            var rect = v[ i ];
            ret = root.insert( rect );
            if( ret != null ) {
                rc = ret.rc;
                rect.x = rc.l;
                rect.y = rc.t;
                if( rect.flipped ){
                    rect.flipped = false;
                    rect.flip();
                 }
                 clipX = Std.int( Math.max( clipX, rc.r ) );
                 clipY = Std.int( Math.max( clipY, rc.b ) ); 
                 succ.push( rect );
             } else {
                 unsucc.push( rect );
                 rect.flipped = false;
             }
         }
         return new WH( clipX, clipY );
    }
    public static
    function pack( v: Array<XYWHF>, maxS: Int, bins: Array<Bin> ){
        var n     = v.length;
        var _rect = new WH( maxS, maxS );
        var vec0  = new Array<XYWHF>();
        var vec1  = new Array<XYWHF>();
        for( i in 0...n ){
            vec0[ i ] = v[ i ].clone();
            if( v[ i ].fits( _rect ) == 0 ) return false;
        }
        var b = null;
        var ccc = 0;
        while( true ){
            bins.push( new Bin() );
            b = bins[ bins.length - 1 ];
            b.size = rect2D( vec0, maxS, b.rects, vec1 );
            #if haxe 4
            vec0.resize( 0 );
            #else
            for( i in 0...vec0.length ) vec0[ i ] = null; 
            vec0 = [];
            #end
            if( vec1.length == 0 ) break;
            var tmp = vec0;
            vec0 = vec1;
            vec1 = tmp;
            ccc++;
            if( ccc > 20 ) throw "overflow";
        }
        return true;
    }
}
