package hxRectPack2D.atlas;
import hxRectPack2D.atlas.AtlasBuilder;
import hxRectPack2D.RectPack2D;
import hxRectPack2D.rectangle.XYWHF;
import hxRectPack2D.data.Bin;
import hxRectPack2D.output.TP;
import hxRectPack2D.output.BodyFrames;
class BodyBuilder {
    var blocks          = new Array<XYWHF>();
    var bins            = new Array<Bin>();
    var locations       : Array<Location>;
    var tp              = new TP();
    var wid             : Int;
    var hi              : Null<Int>;
    var packSize        : Int;
    public var jsonString      : String;
    public var bodyFrames      : BodyFrames;
    var names           : Array<String>;
    public function new(){}
    public function reset(){
        hi     = null;
        blocks = new Array<XYWHF>();
        bins   = new Array<Bin>();
        tp     = new TP();
    }
    // Packing
    public function generatePackingData( names_: Array<String>
                                       , blocks_: Array<XYWHF>
                                       , packSize_: Int ): Int {
        packSize    = packSize_;
        names       = names_;
        blocks      = blocks_;
        pack();
        return wid;
    }
    inline
    function pack(){
        RectPack2D.pack( blocks, packSize, bins );
        wid         = packSize*bins.length;
        hi          = packSize;
    }
    // Rendering
    public function build( fileName: String, locations_: Array<Location> = null ): Void {
        if( hi == null ) return; // return early if not packed
        locations = ( locations_ == null )? []: locations_; 
        addMeta( fileName );
        renderToLimbs();
    }
    inline
    function addMeta( fileName: String ){
        tp.metaDefine( fileName, wid, hi );
    }
    inline
    function renderToLimbs(){
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
                var newBlock = block.clone();
                newBlock.x = xoff + block.x;
                addJSONBlock( name, locations[ id ], newBlock );
            }
        }
        jsonString = tp.write();
        bodyFrames = new BodyFrames( jsonString );
    }
    inline
    function addJSONBlock( name: String, location: Location, block: XYWHF ): String {
        return tp.frameDefine( name, location, block );
    }
}