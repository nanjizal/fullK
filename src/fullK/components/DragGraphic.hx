package fullK.components;
import fullK.components.Common;
import kha.graphics2.Graphics;
import kha.Image;
import kha.Color;
import kha.Assets;
import kha.math.FastMatrix3;
@:enum
abstract GraphicType( Int ) to Int from Int {
    var NONE = 0;
    var IMAGE = 1;
    var TEXT = 2;
}
class DragGraphic {
    public var enabled = true;
    public var highlight = -1;
    public var graphicType = NONE;
    public var x: Float;
    public var y: Float;
    public var width: Float;
    public var height: Float;
    var spaceW: Float;
    var area: HitArea;
    public var image: Image;
    public var label: String;
    var common: Common = new Common();
    public var scale( default, set ): Float;
    public function set_scale( scale_: Float ): Float {
        scale = scale_;
        setDimensions();
        updateArea();
        return scale_;
    }
    public function setDimensions(){
        switch( graphicType ){
            case IMAGE:
                width  = image.width*scale;
                height = image.height*scale;
            case TEXT:
                width  = scale*common.font.width(  common.fontSize, " " + label + "  " );
                spaceW = scale*common.font.width(  common.fontSize, " " );
                height = scale*common.font.height( common.fontSize );
            case NONE:
                //
        }
    }
    public
    function new(){}
    public inline
    function updateArea(){
        area = {  x: x - spaceW, y: y, r: x + width, b: y + height };
    }
    public function hitOver( px: Float, py: Float ){
        if( hitCheck( px, py ) ){
            highlight = 0;
        } else {
            highlight = -1;
        }
    }
    public inline
    function renderView( g: Graphics ){
        g.transformation = FastMatrix3.identity().multmat( FastMatrix3.scale( scale, scale ) );
        switch( graphicType ){
            case IMAGE:
                g.drawImage( image, x/scale, y/scale );
                g.opacity = 0.2;
                if( highlight != -1 ) {
                    g.color = Color.Red;
                    g.drawRect( x/scale, y/scale, width/scale, height/scale, common.thick/scale );
                    g.color = Color.White;
                    g.opacity = 1.;
                }
            case TEXT:
                g.opacity = 0.05;
                if( highlight != -1 ) g.color = Color.Red;
                g.fillRect( Math.round( x/scale - spaceW ), Math.round( y/scale), Math.round( width/scale ), Math.round( height/scale ) );
                if( highlight != -1 ) g.color = Color.White;
                g.opacity = 1.;
                g.drawString( label, Math.round( x/scale ), Math.round( y/scale ) );
            case NONE:
                //
        }
        g.transformation = FastMatrix3.identity();
        updateArea();
    }
    public inline
    function hitCheck( mx: Float, my: Float ){
        updateArea();
        return ( mx > area.x && mx < area.r && my > area.y && my < area.b );
    }
}