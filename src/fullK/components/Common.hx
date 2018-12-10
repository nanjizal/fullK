package fullK.components;

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
@:enum
abstract OptionType( Int ) to Int from Int {
    var ROUND           = 0;
    var SQUARE          = 1;
    var CROSS           = 2;
    var TICK            = 3;
    var ROUND_TICK      = 4;
    var TRIANGLE        = 5;
    var TRIANGLE_TICK   = 6;
}
class Common {
    public var radiusOutline = 10.;
    public var radiusInner = 4.;
    public var thick =1.5;
    public var gapW = 20.;
    public var gapH = 16.;
    public var dia: Float;
    public var diaInner: Float;
    public function new(){
        dia = radiusOutline*2;
        diaInner = radiusInner*2;
    }
    inline public
    function circleOut( g: Graphics, cx: Float, cy: Float ){
        GraphicsExtension.drawCircle( g, cx, cy, radiusOutline, thick );
    }
    inline public
    function squareOut( g: Graphics, cx: Float, cy: Float ){
        g.drawRect( cx - radiusOutline, cy - radiusOutline, dia, dia, thick );
    }
    inline public
    function triangleUpOut( g: Graphics, cx: Float, cy: Float ){
        g.drawLine( cx - radiusOutline, cy + radiusOutline
                  , cx, cy - radiusOutline );
        g.drawLine( cx, cy - radiusOutline, cx + radiusOutline
                  , cy + radiusOutline );
        g.drawLine( cx + radiusOutline, cy + radiusOutline
                  , cx - radiusOutline, cy + radiusOutline );
    }
    inline public
    function cross( g: Graphics, cx: Float, cy: Float ){
        var cx_ = cx - thick;
        var cy_ = cy - thick;
        g.drawLine( cx_ - radiusInner, cy_ - radiusInner
                  , cx_ + diaInner, cy_ + diaInner, thick*2 );
        g.drawLine( cx_ - radiusInner, cy_ + diaInner
                  , cx_ + diaInner, cy_ - radiusInner , thick*2 );
    }
    inline public
    function tick( g: Graphics, cx: Float, cy: Float ){
        var cx_ = cx - thick;
        var cy_ = cy - thick;
        var r_3 = radiusInner/3;
        var t2  = thick*2;
        g.drawLine( cx_ - r_3, cy_ + diaInner
                  , cx_ + diaInner, cy_ - radiusInner , t2 );
        g.drawLine( cx_ - r_3, cy_ + diaInner
                  , cx_ - radiusInner, cy_ + radiusInner/2, t2 );
    }
    inline public
    function tickRight( g: Graphics, cx: Float, cy: Float ){
        tick( g, cx + radiusInner/2, cy );
    }
    inline public
    function circleIn( g: Graphics, cx: Float, cy: Float ){
        GraphicsExtension.fillCircle( g, cx, cy, radiusInner );
    }
    inline public
    function squareIn( g: Graphics, cx: Float, cy: Float ){
        g.fillRect( cx - radiusInner, cy - radiusInner, diaInner, diaInner );
    }
    inline public
    function triangleUpIn( g: Graphics, cx: Float, cy: Float ){
        g.fillTriangle(  cx - radiusInner, cy + radiusInner*1.5
                       , cx,               cy - radiusInner*0.5
                       , cx + radiusInner, cy + 1.5*radiusInner );
    }
    inline public
    function horiLine( g: Graphics, cx: Float, cy: Float, width ){
        g.drawLine( cx, cy + thick/2, cx + width, cy + thick/2, thick );
    }
    inline public
    function hitAreaRender( i: Int, highlight: Int
                          , g: Graphics
                          , cx: Float, cy: Float
                          , wid: Float ){
        var dx = cx - radiusOutline - thick;
        var dy = cy - radiusOutline - thick;
        var dw = wid + thick*2;
        var dr = dx + dw;
        var dh = dia + thick*2;
        var db = dy + dh;
        if( highlight == i ) { 
            g.opacity = 0.1;
            g.color = Color.Red;
        } else {
            g.opacity = 0.05;
        }
        g.fillRect( dx, dy, dw, dh );
        if( highlight == i ) g.color = Color.White;
        g.opacity = 1.;
        return {  x: dx, y: dy, r: dr , b: db };
    }
    inline public
    function dy():Float {
        return dia + gapH;
    }
}