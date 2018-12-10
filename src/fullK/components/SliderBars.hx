package fullK.components;

import kha.System;
import kha.Assets;
import kha.Font;
import kha.Color;
import kha.graphics2.Graphics;
import kha.input.Mouse;
import kha.graphics2.GraphicsExtension;
import fullK.components.Common;
using kha.graphics2.GraphicsExtension;
typedef Slidee = { min:  Float
                 , max:  Float
                 , value: Float
                 , ?flip:  Bool
                 , ?clampInteger: Bool }
class SliderBars {
    var dragging = false;
    public var optionType = SQUARE;
    var highlight: Int = -1;
    public var visible: Bool = true;
    var x = 100.;
    var y = 100.;
    public var gapH = 16.;
    var common: Common = new Common();
    public var widths: Array<Int>;
    public var slidees: Array<Slidee>;
    var hitArea = new Array<HitArea>();
    public var sliderOver: Int -> Void;
    public var sliderChange: Int -> Float -> Void;
    var lastHit: Int;
    var lastX: Float;
    var lastY: Float;
    public function new( x_: Float = 100, y_: Float = 100){
        x = x_;
        y = y_;
    }
    public function renderView( g: Graphics ){
        if( visible == false ) return;
        if( widths == null ) return;
        var cx = x;
        var cy = y;
        var wid: Float;
        var slidee: Slidee;
        var pos: Float;
        for( i in 0...widths.length ){
            wid = widths[ i ];
            common.horiLine( g, cx, cy, wid );
            slidee = slidees[ i ];
            pos = slideePos( slidee, cx, wid );
            if( slidee.clampInteger ){
                g.drawString( Std.string( Math.round( slidee.value ) )
                            , pos + common.radiusOutline, cy - common.gapH - common.radiusInner );
            } else {
                g.drawString( Std.string( Math.round( slidee.value * 100 )/100 )
                            , pos + common.radiusOutline, cy - common.gapH - common.radiusInner );
            }
            renderSlidee( g, pos, cy );//cx + wid/2
            hitArea[ i ] = common.hitAreaRender( i, highlight, g, cx, cy, wid + common.dia );
            cy += common.dy();
        }
    }
    inline
    function slideePos( slidee: Slidee, cx: Float, width: Float ){
        var min: Float;
        var max: Float;
        var flip = slidee.flip;
        if( flip == null ) slidee.flip = false;
        if( slidee.clampInteger == null ) slidee.clampInteger = false;
        var min = slidee.min;
        var max = slidee.max;
        if( min > max ){ // make sure min max values are reasonable and fix if not
            slidee.min = max;
            slidee.max = min;
            min = slidee.min;
            max = slidee.max;
        }
        var dw = max - min;
        var dif = width/dw;
        var value = slidee.value;
        var dValue: Float;
        if( !flip ){
            dValue = value - min;
        } else {
            dValue = max - value - min;
        }
        var dx = dValue*dif;
        // clamp outputs to range
        if( dx < 0.1 ) dx = 0.;
        if( dx > width - 0.1 ) dx = width;
        return cx + dx;
    }
    public function renderSlidee( g: Graphics, cx: Float, cy: Float ){
        switch( optionType ){
            case ROUND, ROUND_TICK:
                common.circleIn( g, cx, cy + common.thick/4 );
            case SQUARE, CROSS, TICK:
                common.squareIn( g, cx, cy + common.thick/4 );
            case TRIANGLE, TRIANGLE_TICK:
                common.triangleUpIn( g, cx, cy - common.thick - common.thick/4 );
        }
    }
    public function updateValue( hit: Int, px: Float, py: Float ){
        var slidee = slidees[ hit ];
        var wid    = widths[ hit ];
        var dx     = px - x;
        var dw     = slidee.max - slidee.min;
        var dif    = dw/wid;
        var value: Float;
        if( !slidee.flip ){
            value = slidee.min + dx*dif;
        } else {
            value = slidee.min + ( wid - dx )*dif;
        }
        if( value > slidee.max ) value = slidee.max;
        if( value < slidee.min ) value = slidee.min;
        slidee.value = value;
        return value;
    }
    public function hitOver( px: Float, py: Float ){
        var hit = hitTest( px, py );
        if( hit != -1 ){
            if( sliderOver != null ){
                highlight = hit;
                sliderOver( hit );
            }
            if( dragging ) updateSlider( hit, px, py );
        } else {
            highlight = -1;
            dragging = false;
        }
    }
    public function upCheck( px: Float, py: Float ){
        var hit = hitTest( px, py );
        if( hit != -1 ){
            if( dragging ) updateSlider( hit, px, py );
        }
        dragging = false;
    }
    
    public function hitCheck( px: Float, py: Float ){
        var hit = hitTest( px, py );
        if( hit != -1 ){
            updateSlider( hit, px, py );
            dragging = true;
        }
    }
    inline 
    function updateSlider( hit: Int, px: Float, py: Float ){
        if( sliderChange != null ){
            var value = updateValue( hit, px, py );
            var clamp = slidees[ hit ].clampInteger;
            if( clamp ) value = Math.round( value );
            if( lastHit == hit && lastX == px && lastY == py ){
                // don't record if value not changed
            } else {
                sliderChange( hit, value );
                lastX = px;
                lastY = py;
                lastHit = hit;
            }
        }
    }
    inline function hitTest( px: Float, py: Float ): Int {
        var area: HitArea;
        var hit = -1;
        for( i in 0...hitArea.length ){
            area = hitArea[ i ];
            if( px > area.x && px < area.r && py > area.y && py < area.b ){
                hit = i;
                break;
            }
        }
        return hit;
    }
}