package hxRectPack2D.output;
import hxRectPack2D.output.TP;
class BodyFrames{
    var framesHolder:    FramesHolder;
    public var limbs = new Array<LimbFrame>();
    public function new( strJson: String ){
        framesHolder = TP.reconstruct( strJson );
        var limb: LimbFrame;
        for( f in framesHolder.frames ) {
            limb = new LimbFrame( f );
            limbs.push( limb );
        }
    }
    public function limbByName( name: String ){
        var out = null;
        for( limb in limbs ){
            if( limb.name == name ) {
                out = limb;
                break;
            }
        }
        return out;
    }
    public function getNames(){
        var arr = new Array<String>();
        var count = 0;
        for( limb in limbs ){
            arr[ count ] = limb.name;
            count++;
        }
        return arr;
    }
    public function getNameString(){
        var arr = new Array<String>();
        var count = 0;
        for( limb in limbs ){
            arr[ count ] = limb.name;
            count++;
        }
        return '\n' +arr.join('\n');
    }
}