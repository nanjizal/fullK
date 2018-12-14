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

class ViewOptions {
    public var visible: Bool = true;
    public var enabled: Bool = true;
    var highlight: Int = -1;
    public var optionType = SQUARE;
    var radiusOutline = 10.;
    var radiusInner = 4.;
    public var x = 100.;
    public var y = 100.;
    var thick =1.5;
    public var gapW = 20.;
    public var gapH = 16.;
    public var optionChange: Int -> Array<Bool> -> Void;
    public var optionOver: Int -> Void;
    public var labels: Array<String>;
    var hitArea = new Array<HitArea>();
    public var state: Array<Bool>;
    var common: Common;
    public function new( x_: Float = 100, y_: Float = 100, common_: Common ){
        x = x_;
        y = y_;
        common = common_;
    }
    public function renderView( g: Graphics ){
        if( visible == false ) return;
        g.color = common.mainColor;
        var cx = x;
        var cy = y;
        var font = g.font;
        var size = g.fontSize;
        var fontHi = font.height( g.fontSize );
        var label: String;
        var fontWid;
        var dia = radiusOutline*2;
        common.gapW = gapW;
        common.gapH = gapH;
        for( i in 0...labels.length ){
            label = labels[ i ];
            fontWid = font.width( size, label );
            // hit area
            if( enabled ){
                hitArea[ i ] = common.hitAreaRender( i, highlight, g, cx, cy, fontWid + gapW+ dia*2 );
            }
            // graphics
            drawOuter( g, cx, cy );
            if( state[ i ] ) drawInner( g, cx, cy );
            renderText( label, g, cx, cy );
            cy += common.dy();
        }
    }
    inline
    function drawInner( g: Graphics, cx: Float, cy: Float ){
        switch( optionType ){
            case ROUND:
                common.circleIn( g, cx, cy );
            case SQUARE:
                common.squareIn( g, cx, cy );
            case CROSS:
                common.cross( g, cx, cy );
            case TICK:
                common.tick( g, cx, cy );
            case ROUND_TICK:
                common.tick( g, cx, cy );
            case TRIANGLE:
                common.triangleUpIn( g, cx, cy );
            case TRIANGLE_TICK:
                common.tickRight( g, cx, cy );
        } 
    }
    inline
    function drawOuter( g: Graphics, cx: Float, cy: Float ){
        switch( optionType ){
            case ROUND:
                common.circleOut( g, cx, cy );
            case SQUARE:
                common.squareOut( g, cx, cy );
            case CROSS:
                common.squareOut( g, cx, cy );
            case TICK:
                common.squareOut( g, cx, cy );
            case ROUND_TICK:
                common.circleOut( g, cx, cy );
            case TRIANGLE:
                common.triangleUpOut( g, cx, cy );
            case TRIANGLE_TICK:
                common.triangleUpOut( g, cx, cy );
        }
    }
    public function renderText( label: String, g: Graphics, cx: Float, cy: Float ){
        g.drawString( label, cx + radiusOutline + gapW, cy - radiusOutline );
    }
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
    public function hitCheck( px: Float, py: Float ){
        if( !enabled ) return;
        var hit = hitTest( px, py );
        if( hit != -1 ){
            if( optionChange != null ){
                updateState( hit );
                optionChange( hit, state );
            }
        }
    }
    public function updateState( hit: Int ){
        if( optionType == ROUND 
         || optionType == TRIANGLE 
         || optionType == SQUARE ){
            for( i in 0...state.length ){
                state[ i ] = ( hit == i );
            }
        } else {
            state[ hit ] = !state[ hit ];
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