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
@:enum
abstract Orientation( Bool ) to Bool from Bool {
    var VERTICAL   = false;
    var HORIZONTAL = true;
}
typedef Slidee = { min:  Float
                 , max:  Float
                 , value: Float
                 , ?flip:  Bool
                 , ?clampInteger: Bool }
class SliderBars {
    public var orientation = HORIZONTAL;
    public var visible: Bool = true;
    public var enabled: Bool = true;
    var dragging = false;
    public var optionType = SQUARE;
    var highlight: Int = -1;
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
            slidee = slidees[ i ];
            switch( orientation ){
                case HORIZONTAL:
                    common.horiLine( g, cx, cy, wid );
                    pos = slideePos( slidee, cx, wid );
                    if( slidee.clampInteger ){
                        g.drawString( Std.string( Math.round( slidee.value ) )
                            , pos + common.radiusOutline, cy - common.gapH - common.radiusInner );
                    } else {
                        g.drawString( Std.string( Math.round( slidee.value * 100 )/100 )
                            , pos + common.radiusOutline, cy - common.gapH - common.radiusInner );
                    }
                    renderSlideeX( g, pos, cy );
                    if( enabled ){
                        hitArea[ i ] = common.hitAreaRender( i, highlight, g, cx, cy, wid + common.dia );
                    }
                    cy += common.dy();
                case VERTICAL:
                    common.vertLine( g, cx, cy, wid );
                    pos = slideePos( slidee, cy, wid );
                    if( slidee.clampInteger ){
                        g.drawString( Std.string( Math.round( slidee.value ) )
                            , cx + common.gapH - 2*common.radiusInner, pos - 2.2*common.radiusOutline );
                    } else {
                        g.drawString( Std.string( Math.round( slidee.value * 100 )/100 )
                            , cx + common.gapH - 2*common.radiusInner, pos - 2.2*common.radiusOutline );
                    }
                    renderSlideeY( g, cx, pos );
                    if( enabled ){
                        hitArea[ i ] = common.hitAreaRenderV( i, highlight, g, cx, cy, wid + common.dia );
                    }
                    cx += common.dy()*1.8;
            }
        }
    }
    inline
    function slideePos( slidee: Slidee, cx: Float, width: Float ){
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
    public function renderSlideeX( g: Graphics, cx: Float, cy: Float ){
        switch( optionType ){
            case ROUND, ROUND_TICK:
                common.circleIn( g, cx, cy + common.thick/4 );
            case SQUARE, CROSS, TICK:
                common.squareIn( g, cx, cy + common.thick/4 );
            case TRIANGLE, TRIANGLE_TICK:
                common.triangleUpIn( g, cx, cy - common.thick - common.thick/4 );
        }
    }
    public function renderSlideeY( g: Graphics, cx: Float, cy: Float ){
        switch( optionType ){
            case ROUND, ROUND_TICK:
                common.circleIn( g, cx, cy );
            case SQUARE, CROSS, TICK:
                common.squareIn( g, cx + common.thick/4, cy );
            case TRIANGLE, TRIANGLE_TICK:
                common.triangleRightIn( g, cx, cy - common.thick - common.thick/4 );
        }
    }
    public function updateValue( hit: Int, px: Float, py: Float ){
        var slidee = slidees[ hit ];
        var wid    = widths[ hit ];
        var delta: Float;
        switch( orientation ){
            case HORIZONTAL:
                delta = px - x;
            case VERTICAL:
                delta = py - y;
        }
        var dw     = slidee.max - slidee.min;
        var dif    = dw/wid;
        var value: Float;
        if( !slidee.flip ){
            value = slidee.min + delta*dif;
        } else {
            value = slidee.min + ( wid - delta )*dif;
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
        if( !enabled ) return;
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