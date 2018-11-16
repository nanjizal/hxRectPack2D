package hxRectPack2D.targets;

import kha.System;
import kha.Assets;
import kha.Font;
import kha.Color;
import kha.graphics2.Graphics;
import kha.input.Mouse;
import kha.graphics2.GraphicsExtension;

using kha.graphics2.GraphicsExtension;
typedef HitArea = {
    var x: Float;
    var y: Float;
    var r: Float;
    var b: Float;
}
enum OptionType {
    ROUND;
    SQUARE;
    CROSS;
    TICK;
}
class ViewOptions {
    public var visible: Bool = true;
    public var optionType = SQUARE;
    var radiusOutline = 10.;
    var radiusInner = 4.;
    var x = 100.;
    var y = 100.;
    var thick =1.5;
    public var gapW = 20.;
    public var gapH = 16.;
    public var optionChange: Int -> Array<Bool> -> Void;
    public var optionOver: Int -> Void;
    public var labels: Array<String>;
    var hitArea = new Array<HitArea>();
    public var state: Array<Bool>;
    public function new( x_: Float = 100, y_: Float = 100){
        x = x_;
        y = y_;
    }
    public function renderView( g: Graphics ){
        if( visible == false ) return;
        g.color = Color.White;
        var cx = x;
        var cy = y;
        var font = g.font;
        var size = g.fontSize;
        var fontHi = font.height( g.fontSize );
        var label: String;
        var fontWid;
        var dia = radiusOutline*2;
        var diaInner = radiusInner*2;
        var dx: Float;
        var dy: Float;
        var dw: Float;
        var dh: Float;
        var dr: Float;
        var db: Float;
        for( i in 0...labels.length ){
            label = labels[ i ];
            fontWid = font.width( size, label );
            // hit area
            dx = cx - radiusOutline - thick;
            dy = cy - radiusOutline - thick;
            dw = fontWid + gapW + dia*2 + thick*2;
            dr = dx + dw;
            dh = dia + thick*2;
            db = dy + dh;
            hitArea[ i ] = {  x: dx, y: dy, r: dr , b: db };
            if( highlight == i ) { 
                g.opacity = 0.1;
                g.color = Color.Red;
            } else {
                g.opacity = 0.05;
            }
            g.fillRect( dx, dy, dw, dh );
            if( highlight == i ) g.color = Color.White;
            g.opacity = 1.;
            // graphics
            switch( optionType ){
                case ROUND:
                    GraphicsExtension.drawCircle( g, cx, cy, radiusOutline, thick );
                case SQUARE:
                    g.drawRect( cx - radiusOutline, cy - radiusOutline, dia, dia, thick );
                case CROSS:
                    g.drawRect( cx - radiusOutline, cy - radiusOutline, dia, dia, thick );
                case TICK:
                    g.drawRect( cx - radiusOutline, cy - radiusOutline, dia, dia, thick );
            }
            if( state[ i ] ) {
                switch( optionType ){
                    case ROUND:
                        GraphicsExtension.fillCircle( g, cx, cy, radiusInner );
                    case SQUARE:
                        g.fillRect( cx - radiusInner, cy - radiusInner, diaInner, diaInner );
                    case CROSS:
                        var cx_ = cx - thick;
                        var cy_ = cy - thick;
                        g.drawLine( cx_ - radiusInner, cy_ - radiusInner
                                  , cx_ + diaInner, cy_ + diaInner, thick*2 );
                        g.drawLine( cx_ - radiusInner, cy_ + diaInner
                                  , cx_ + diaInner, cy_ - radiusInner , thick*2 );
                    case TICK:
                        var cx_ = cx - thick;
                        var cy_ = cy - thick;
                        g.drawLine( cx_ - radiusInner/3, cy_ + diaInner
                                  , cx_ + diaInner, cy_ - radiusInner , thick*2 );
                        g.drawLine( cx_ - radiusInner/3, cy_ + diaInner
                                  , cx_ - radiusInner, cy_ + radiusInner/2, thick*2 );
                } 
            }
            g.drawString( label, cx + radiusOutline + gapW, cy - radiusOutline );
            cy += dia + gapH;
        }
    }
    var highlight: Int = -1;
    public function hitOver( x: Float, y: Float ){
        var hit = hitTest( x, y );
        if( hit != -1 ){
            if( optionOver != null ){
                highlight = hit;
                optionOver( hit );
            }
        } else {
            highlight = -1;
        }
    }
    public function hitCheck( x: Float, y: Float ){
        var hit = hitTest( x, y );
        if( hit != -1 ){
            if( optionChange != null ){
                if( optionType == ROUND ){
                    for( i in 0...state.length ){
                        state[ i ] = ( hit == i );
                    }
                } else {
                    state[ hit ] = !state[ hit ];
                }
                optionChange( hit, state );
            }
        }
    }
    inline function hitTest( x: Float, y: Float ): Int {
        var area: HitArea;
        var hit = -1;
        for( i in 0...hitArea.length ){
            area = hitArea[ i ];
            if( x > area.x && x < area.r && y > area.y && y < area.b ){
                hit = i;
                break;
            }
        }
        return hit;
    }
}