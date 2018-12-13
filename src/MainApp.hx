package;
import kha.graphics2.Graphics;
import fullK.MainTemplate;
import fullK.components.ViewOptions;
import fullK.components.SliderBars;
import fullK.components.Common;
import kha.Image;
import kha.Assets;
import kha.math.FastMatrix3;
import fullK.components.DragGraphic;
class MainApp extends fullK.MainTemplate{ public static function main() MainTemplate.main();
    var options = new ViewOptions( 300, 100 );
    var slidersHorizontal = new SliderBars( 100, 200 );
    var slidersVertical   = new SliderBars( 100, 350 );
    var dragImage: DragGraphic;
    var dragText:  DragGraphic;
    override public inline
    function setup(){
        trace('setup');
        setupDragImage();
        setupDragText();
        frameStatGreySkin();
        setupOptions();
        setupSliderBars();
    }
    function setupDragImage(){
        dragImage = new DragGraphic(); 
        dragImage.graphicType = IMAGE;
        dragImage.image = Assets.images.khaIcon;
        dragImage.x = 500.;
        dragImage.y = 370.;
        dragImage.scale = 0.3;
    }
    function setupDragText(){
        dragText = new DragGraphic();
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
    override public
    function over(){
        options.hitOver( interaction.mouseX, interaction.mouseY );
        slidersHorizontal.hitOver( interaction.mouseX, interaction.mouseY );
        slidersVertical.hitOver( interaction.mouseX, interaction.mouseY );
        dragImage.hitOver( interaction.mouseX, interaction.mouseY );
        dragText.hitOver( interaction.mouseX, interaction.mouseY );
    }
    override public
    function move(){
        options.hitOver( interaction.mouseX, interaction.mouseY );
        slidersHorizontal.hitOver( interaction.mouseX, interaction.mouseY );
        slidersVertical.hitOver( interaction.mouseX, interaction.mouseY );
        dragImage.hitOver( interaction.mouseX, interaction.mouseY );
        dragText.hitOver( interaction.mouseX, interaction.mouseY );
    }
    override public
    function down(){
        var mx = interaction.mouseX;
        var my = interaction.mouseY;
        var imgHit = dragImage.hitCheck( mx, my );
        var txtHit = dragText.hitCheck( mx, my );
        if( imgHit ) interaction.dragItem = cast dragImage;
        if( txtHit ) interaction.dragItem = cast dragText;
        if( imgHit || txtHit ){
            options.enabled = false;
            slidersHorizontal.enabled = false;
            slidersVertical.enabled = false;
        }        
        options.hitCheck( mx, my );
        slidersHorizontal.hitCheck( mx, my );
        slidersVertical.hitCheck( mx, my );
    }
    override public
    function up(){
        options.enabled = true;
        slidersHorizontal.enabled = true;
        slidersVertical.enabled = true;
        slidersHorizontal.upCheck( interaction.mouseX, interaction.mouseY );
        slidersVertical.upCheck( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function render2D( g: Graphics ){
        g.drawRect( 100, 100, 100, 30 );
        g.drawString( 'hello world', 105, 105 );
        options.renderView( g );
        slidersHorizontal.renderView( g );
        slidersVertical.renderView( g );
        dragImage.renderView( g );
        g.opacity = 1.;
        g.drawString( 'draggable image', dragImage.x, dragImage.y - 25 );
        dragText.renderView( g );
    }
}