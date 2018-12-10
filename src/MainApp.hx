package;
import kha.graphics2.Graphics;
import fullK.MainTemplate;
import fullK.components.ViewOptions;
import fullK.components.SliderBars;
import fullK.components.Common;
class MainApp extends fullK.MainTemplate{ public static function main() MainTemplate.main();
    var options = new ViewOptions( 300, 100 );
    var sliders = new SliderBars(  100, 200 );
    override public inline
    function setup(){
        trace('setup');
        frameStatGreySkin();
        setupOptions();
        setupSliderBars();
    }
    function setupOptions(){
        options.optionType   = ROUND;
        options.state        = [ true, false, false, false, false, false, false ];
        options.labels       = [ 'ROUND','SQUARE','CROSS','TICK','ROUND_TICK','TRIANGLE', 'TRIANGLE_TICK' ];
        options.optionChange = function( id: Int, state: Array<Bool> ){
            switch( id ){
                case ROUND:
                    options.optionType = ROUND;
                    sliders.optionType = ROUND;
                    options.updateState( 0 );
                case SQUARE:
                    options.optionType = SQUARE;
                    sliders.optionType = SQUARE;
                case CROSS: 
                    options.optionType = CROSS;
                    sliders.optionType = SQUARE;
                case TICK: 
                    options.optionType = TICK;
                    sliders.optionType = SQUARE;
                case ROUND_TICK:
                    options.optionType = ROUND_TICK;
                    sliders.optionType = ROUND;
                case TRIANGLE:
                    options.optionType = TRIANGLE;
                    sliders.optionType = TRIANGLE;
                case TRIANGLE_TICK:
                    options.optionType = TRIANGLE_TICK;
                    sliders.optionType = TRIANGLE;
            }
        }
        options.optionOver   = function( id: Int ){ trace('over'); }
    }
    function setupSliderBars(){
        sliders.slidees = [ { min: 0., max: 100., value: 50., clampInteger: true }
                          , { min: 0., max: 200., value: 50., flip: false }
                          , { min: 0., max: 1.,   value: 0.3, flip: true  } ];
        sliders.widths = [ 150, 150, 150 ];
        sliders.sliderOver   = function( id: Int ){ trace('over'); }
        sliders.sliderChange = function( id: Int, value: Float ){ trace( 'slidee ' + id +': ' + value ); }
    }
    override public inline 
    function over(){
        options.hitOver( interaction.mouseX, interaction.mouseY );
        sliders.hitOver( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function move(){
        options.hitOver( interaction.mouseX, interaction.mouseY );
        sliders.hitOver( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function down(){
        options.hitCheck( interaction.mouseX, interaction.mouseY );
        sliders.hitCheck( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function up(){
        sliders.upCheck( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function render2D( g2: Graphics ){
        g2.drawRect( 100, 100, 100, 30 );
        g2.drawString( 'hello world', 105, 105 );
        options.renderView( g2 );
        sliders.renderView( g2 );
    }
}