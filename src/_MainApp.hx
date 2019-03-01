package;
import kha.graphics2.Graphics;
import fullK.MainTemplate;
import fullK.components.ViewOptions;
import fullK.components.SliderBars;
import fullK.components.Common;
import kha.Image;
import kha.Color;
import kha.Assets;
import kha.math.FastMatrix3;
import fullK.components.DragGraphic;
import fullK.components.ColorHelper;
import fullK.components.RGBsliders;

class MainApp extends fullK.MainTemplate{ public static function main() MainTemplate.main();
    var common:             Common;
    var options:            ViewOptions;
    var slidersHorizontal:  SliderBars;
    var rgb:                RGBsliders;
    var rgbOver:            RGBsliders;
    var slidersVertical:    SliderBars;
    var dragImage:          DragGraphic;
    var dragText:           DragGraphic;
    override public inline
    function setup(){
        common = new Common();
        //common.overColorSetup( MagentaOver );
        options = new ViewOptions( 300, 100, common );
        slidersHorizontal = new SliderBars( 100, 200, common );
        slidersVertical   = new SliderBars( 100, 350, common );
        rgb = new RGBsliders( 500, 100, 100 );
        rgb.sliderChange = commonColor;
        // rgb.orientation = VERTICAL;
        rgbOver = new RGBsliders( 500, 240, 100 );
        rgbOver.values( 15, 10, 10 );
        rgbOver.sliderChange = overColor;
        
        setupDragImage();
        setupDragText();
        frameStatGreySkin();
        setupOptions();
        setupSliderBars();
        setupRenderViews();
        setupRollOvers();
        setupDrags();
        setupDownCheck();
        setupUpCheck();
    }
    function overColor( val: Int ){
        common.overColor = val;
    }
    function commonColor( val: Int ){
        common.mainColor = val;
    }
    function setupRenderViews(){
        renderViews = [ renderHelloWorld
                      , options.renderView
                      , slidersHorizontal.renderView
                      , slidersVertical.renderView
                      , rgb.renderView
                      , rgbOver.renderView
                      , renderImageTitle
                      , renderMainColorTitle
                      , renderHighlightTitle
                      , dragImage.renderView
                      , dragText.renderView ];
    }
    function setupRollOvers(){
        rollOvers = [ options.hitOver
                    , slidersHorizontal.hitOver
                    , slidersVertical.hitOver
                    , rgb.hitOver
                    , rgbOver.hitOver
                    , dragImage.hitOver
                    , dragText.hitOver ];
    }
    function setupUpCheck(){
        upChecks = [ slidersHorizontal.upCheck
                   , slidersVertical.upCheck
                   , rgb.upCheck
                   , rgbOver.upCheck ];
    }
    function setupDownCheck(){
        downChecks = [ options.hitCheck
                     , slidersHorizontal.hitCheck
                     , slidersVertical.hitCheck
                     , rgb.hitCheck
                     , rgbOver.hitCheck ];
    }
    function setupDrags(){
        drags = [ dragImage, dragText ];
    }
    function setupDragImage(){
        dragImage = new DragGraphic( common ); 
        dragImage.graphicType = IMAGE;
        dragImage.image = Assets.images.khaIcon;
        dragImage.x = 500.;
        dragImage.y = 370.;
        dragImage.scale = 0.3;
    }
    function setupDragText(){
        dragText = new DragGraphic( common );
        dragText.graphicType = TEXT;
        dragText.label = 'draggable text';
        dragText.x = 350;
        dragText.y = 370;
        dragText.scale = 0.95;
    }
    function setupOptions(){
        options.optionType   = ROUND;
        options.state        = [ true, false, false, false, false, false, false ];
        options.labels       = [ 'ROUND','SQUARE','CROSS','TICK','ROUND_TICK','TRIANGLE', 'TRIANGLE_TICK' ];
        options.optionChange = function( id: Int, state: Array<Bool> ){
            switch( id ){
                case ROUND:
                    options.optionType = ROUND;
                    slidersHorizontal.optionType = ROUND;
                    slidersVertical.optionType = ROUND;
                    options.updateState( 0 );
                case SQUARE:
                    options.optionType = SQUARE;
                    slidersHorizontal.optionType = SQUARE;
                    slidersVertical.optionType = SQUARE;
                case CROSS: 
                    options.optionType = CROSS;
                    slidersHorizontal.optionType = SQUARE;
                    slidersVertical.optionType = SQUARE;
                case TICK: 
                    options.optionType = TICK;
                    slidersHorizontal.optionType = SQUARE;
                    slidersVertical.optionType = SQUARE;
                case ROUND_TICK:
                    options.optionType = ROUND_TICK;
                    slidersHorizontal.optionType = ROUND;
                    slidersVertical.optionType = ROUND;
                case TRIANGLE:
                    options.optionType = TRIANGLE;
                    slidersHorizontal.optionType = TRIANGLE;
                    slidersVertical.optionType = TRIANGLE;
                case TRIANGLE_TICK:
                    options.optionType = TRIANGLE_TICK;
                    slidersHorizontal.optionType = TRIANGLE;
                    slidersVertical.optionType = TRIANGLE;
            }
        }
        options.optionOver   = function( id: Int ){ trace('over'); }
    }
    function setupSliderBars(){
        slidersHorizontal.orientation = HORIZONTAL;
        slidersHorizontal.slidees = [ { min: 300., max: 2000.,   value: 300., flip: false  }
                                    , { min: 300., max: 1024., value: 370., clampInteger: true }
                                    , { min: 300., max: 600., value: 400., flip: false }
                           ];
        slidersHorizontal.widths = [ 150, 150, 150 ];
        slidersHorizontal.sliderOver   = function( id: Int ){ trace('over'); }
        slidersHorizontal.sliderChange = function( id: Int, value: Float ){ 
            trace( 'slidee Horizontal ' + id +': ' + value ); 
            switch( id ){
                case 0:
                    dragText.x = value;
                case 1:
                    dragImage.x = value;
                case 2:
                    options.x = value;
            }
        
        }
        
        slidersVertical.orientation = VERTICAL;
        slidersVertical.slidees = [ { min: 300., max: 600., value: 370., clampInteger: true }
                          , { min: 0.1, max: 1.19,   value: 0.3, flip: false  }
                          , { min: 0.5, max: 3.5,   value: 0.3, flip: false  } ];
        slidersVertical.widths = [ 150, 150, 150 ];
        slidersVertical.sliderOver   = function( id: Int ){ trace('over'); }
        slidersVertical.sliderChange = function( id: Int, value: Float ){ 
            trace( 'slidee Vertical' + id +': ' + value ); 
            switch( id ){
                case 0:
                    dragImage.y = value;
                case 1:
                    dragImage.scale = value;
                case 2:
                    dragText.scale = value;
            }
        }
    }
    public override
    function over(){
        super.over();
    }
    public override 
    function move(){
        super.move();
    }
    override public
    function down(){
        super.down();
        var mx = interaction.mouseX;
        var my = interaction.mouseY;
        if( dragging ){
            options.enabled = false;
            slidersHorizontal.enabled = false;
            slidersVertical.enabled = false;
        }
    }
    override public
    function up(){
        options.enabled = true;
        slidersHorizontal.enabled = true;
        slidersVertical.enabled = true;
        super.up();
    }
    inline
    public function renderImageTitle( g: Graphics ){
        g.color = common.mainColor;
        g.drawString( 'draggable image', dragImage.x, dragImage.y - 27 );
    }
    inline
    public function renderMainColorTitle( g: Graphics ){
        g.color = common.mainColor;
        g.drawString( 'colour', rgb.x, rgb.y - 40 );
    }
    inline function renderHighlightTitle( g: Graphics ){
        g.color = common.mainColor;
        g.drawString( 'rollover color', rgbOver.x, rgbOver.y - 40 );
    }
    inline
    public function renderHelloWorld( g: Graphics ){
        g.color = common.mainColor;
        g.drawRect( 100, 100, 100, 30 );
        g.drawString( 'hello world', 105, 105 );
    }
    override public
    function render2D( g: Graphics ){
        super.render2D( g );
    }
}
