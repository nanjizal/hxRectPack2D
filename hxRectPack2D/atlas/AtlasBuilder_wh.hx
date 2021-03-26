package hxRectPack2D.atlas;
import hxRectPack2D.atlas.AtlasBuilder;
import hxRectPack2D.RectPack2D;
import hxRectPack2D.rectangle.XYWHF;
import hxRectPack2D.data.Bin;
import hxRectPack2D.output.TP;

typedef ImageData = { 
    var images: Array<ImageWrapper>;
    var names: Array<String>; 
}
// the renderBlock is changed so that it uses the imageDraw of the block so that offsets can be used.
class AtlasBuilder_wh {
    var blocks          = new Array<XYWHF>();
    var bins            = new Array<Bin>();
    var imageData       : ImageData;
    var locations       : Array<Location>;
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
    public function generatePackingData( imageData_: ImageData, packSize_: Int ): Int {
        packSize    = packSize_;
        imageData = imageData_;
        createBlocks();
        pack();
        return wid;
    }
    inline
    function createBlocks(){
        var img: ImageWrapper;
        var images = imageData.images;
        for( i in 0...images.length ){
            img = images[ i ];
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
        var names = imageData.names;
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
                            , xoff + block.x ,  block.y
                            , block.w,         block.h
                            , block.flipped );
                            var newBlock = block.clone();
                            newBlock.x = xoff + block.x;
                addJSONBlock( name, locations[ id ], newBlock );
            }
        }
    }
    inline
    function addJSONBlock( name: String, location: Location, block: XYWHF ): String {
        return tp.frameDefine( name, location, block );
    }
    
    function renderBlock( image: ImageWrapper
                        , name:  String
                        , id:    Int
                        , left:  Int,  top: Int
                        , wid:   Int,  hi:  Int
                        , flip:  Bool ){
        var images = imageData.images;
        var img = images[ id ];
        Sys.println( 'render ' + name + 
                    ': x:' + left + ', y:' + top + 
                    ', w:' + wid + ', h:' + hi + 
                    ', rotated:' + flip );
        if( flip ){
            //img.drawCW( left, top, image );
        } else {
            //img.draw(   left, top, image );
        }
    }
}