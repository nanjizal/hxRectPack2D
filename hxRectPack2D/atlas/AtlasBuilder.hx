package hxRectPack2D.atlas;
import hxRectPack2D.RectPack2D;
import hxRectPack2D.rectangle.XYWHF;
import hxRectPack2D.data.Bin;
import hxRectPack2D.output.TP;

typedef Atlas = {
    var imageWrapper: ImageWrapper;
    var jsonString:   String;
}
typedef ImageWrapper = {
    var width:      Int;
    var height:     Int;
    function draw(   fx: Int, fy: Int, fromImg: ImageWrapper ): Void;
    function drawCW( fx: Int, fy: Int, fromImg: ImageWrapper ): Void;
    function drawACW( fx: Int, fy: Int, fromImg: ImageWrapper ): Void;
}
/** AtlasBuilder 
 *
 *  usage:
 *
 *  var atlasBuilder = new AtlasBuilder();
 *  var width = atlasBuilder.generatePackingData( arrImages, height ); // arrImages is array of image holders
 *  var img: ImageWrapper = new ImageHolder( height, width ); // image holder is your class.
 *  var atlas: Atlas = atlasBuilder.getAtlas( 'output.png', img );
 *  
 */
class AtlasBuilder {
    var blocks          = new Array<XYWHF>();
    var bins            = new Array<Bin>();
    var names           = new Array<String>();
    var locations       : Array<Location>;
    var arrImages       : Array<ImageWrapper>;
    var tp              = new TP();
    var wid             : Int;
    var hi              : Int;
    var packSize        : Int;
    public function new(){}
    public function reset(){
        hi     = null;
        blocks = new Array<XYWHF>();
        bins   = new Array<Bin>();
        tp     = new TP();
    }
    // Packing
    public function generatePackingData( arrImages_: Array<ImageWrapper>
                                       , names_: Array<String>, packSize_: Int ): Int {
        packSize    = packSize_;
        arrImages   = arrImages_;
        names       = names_;
        createBlocks();
        pack();
        return wid;
    }
    inline
    function createBlocks(){
        var img: ImageWrapper;
        for( i in 0...arrImages.length ){
            img = arrImages[ i ];
            blocks[ i ] = new XYWHF( i, 0, 0, img.width, img.height );
        }
    }
    inline
    function pack(){
        RectPack2D.pack( blocks, packSize, bins );
        wid         = packSize*bins.length;
        hi          = packSize;
    }
    // Rendering
    public function getAtlas( fileName: String, image: ImageWrapper
                            , locations_: Array<Location> = null ): Atlas {
        if( hi == null ) return null; // return early if not packed
        locations = ( locations_ == null )? []: locations_; 
        addMeta( fileName );
        renderToAtlas( image );
        return {    imageWrapper: image
               ,    jsonString:   tp.write() 
               };
    }
    inline
    function addMeta( fileName: String ){
        tp.metaDefine( fileName, wid, hi );
    }
    inline
    function renderToAtlas( image: ImageWrapper ): Void {
        var block: XYWHF;
        var id: Int;
        var name: String;
        for ( j in 0...bins.length ){
            var bin0 = bins[ j ].rects;
            var xoff = j*packSize;
            for( i in 0...bin0.length ){
                block = bin0[ i ];
                id = block.id;
                name = names[ id ];
                renderBlock(  image
                            , name
                            , id
                            , xoff + block.x,  block.y
                            , block.w,         block.h
                            , block.flipped );
                addJSONBlock( name, locations[ id ], block );
            }
        }
    }
    inline
    function addJSONBlock( name: String, location: Location, block: XYWHF ): String {
        return tp.frameDefine( name, location, block );
    }
    inline
    function renderBlock( image: ImageWrapper
                        , name:  String
                        , id:    Int
                        , left:  Int,  top: Int
                        , wid:   Int,  hi:  Int
                        , flip:  Bool ){
        var img = arrImages[ id ];
        Sys.println( 'render ' + name + 
                    ': x' + left + ', y:' + top + 
                    ', w:' + wid + ', h:' + hi + 
                    ', rotated:' + flip );
        if( flip ){
            image.drawCW( left, top, img );
        } else {
            image.draw(   left, top, img );
        }
    }
}
