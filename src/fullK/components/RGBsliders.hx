package fullK.components;
import fullK.components.ColorHelper;
import fullK.components.SliderBars;
import kha.graphics2.Graphics;
import kha.Color;

class RGBsliders{
    var rSlider: SliderBars;
    var gSlider: SliderBars;
    var bSlider: SliderBars;
    var rCommon: Common;
    var gCommon: Common;
    var bCommon: Common;
    public var x: Float;
    public var y: Float;
    public var orientation( default, set ): Orientation;
    public function set_orientation( val: Orientation ){
        orientation = val;
        for( slider in allSlides ){
            slider.orientation = val;
            switch( orientation ){
                case HORIZONTAL:
                    slider.slidees[0].flip = false;
                
                case VERTICAL:
                    slider.slidees[0].flip = true;
            }
        }
        return val;
    } 
    public var sliderOver: Int -> Void;
    public var sliderChange: Int -> Void;
    var allSlides = new Array<SliderBars>();
    public function new( x_: Float = 100, y_: Float = 100, wid: Int ){
        x = x_;
        y = y_;
        rCommon = new Common();
        rCommon.mainColor = 0xFFFF3333;
        rCommon.overColorSetup( RedOver );
        gCommon = new Common();
        gCommon.mainColor = 0xFF33FF33;
        gCommon.overColorSetup( GreenOver );
        bCommon = new Common();
        bCommon.mainColor = 0xFF3333FF;
        bCommon.overColorSetup( BlueOver );
        rSlider = new SliderBars( x_, y_, rCommon );
        gSlider = new SliderBars( x_, y_, gCommon );
        bSlider = new SliderBars( x_, y_, bCommon );
        allSlides = [ rSlider, gSlider, bSlider ];
        for( slider in allSlides ){
            slider.slidees = [ { min: 0., max: 100., value: 100., flip: false, clampInteger: true } ];
            slider.widths = [ wid ];
            slider.sliderOver   = function( id: Int ){ trace('over'); }
            slider.sliderChange = function( id: Int, value: Float ){ colorSet(); };
        }
        orientation = HORIZONTAL;
    }
    public function values( r: Int, g: Int, b: Int ){
        rSlider.slidees[0].value = r;
        gSlider.slidees[0].value = g;
        bSlider.slidees[0].value = b;
    }
    function colorSet(){
        if( sliderChange != null ) { 
            sliderChange( 
                ColorHelper.rgbPercent( Std.int( rSlider.slidees[0].value )
                                      , Std.int( gSlider.slidees[0].value )
                                      , Std.int( bSlider.slidees[0].value )
                                      )
            );
        }
    }
    public function upCheck( px: Float, py: Float ){
        for( slider in allSlides ) slider.upCheck( px, py );
    }
    public function hitCheck( px: Float, py: Float ){
        for( slider in allSlides ) slider.hitCheck( px, py );
    }
    public function hitOver( px: Float, py: Float ){
        for( slider in allSlides ) slider.hitOver( px, py );
    }
    public function renderView( g: Graphics ){
        rSlider.x = x;
        rSlider.y = y;
        var x2 = x;
        var y2 = y;
        switch( orientation ){
            case HORIZONTAL:
                y2 += rCommon.dy()*0.75;
                gSlider.x = x2;
                gSlider.y = y2;
                y2 += bCommon.dy()*0.75;
                bSlider.x = x2;
                bSlider.y = y2;
            case VERTICAL:
                x2 += rCommon.dx()*0.65;
                gSlider.x = x2;
                gSlider.y = y2;
                x2 += bCommon.dx()*0.65;
                bSlider.x = x2;
                bSlider.y = y2;
        }
        // reverse render so the number is always on top.
        for( i in 0...allSlides.length ) allSlides[ 2 - i ].renderView( g );
    }
}