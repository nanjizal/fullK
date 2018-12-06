package;
import kha.graphics2.Graphics;
import fullK.MainTemplate;
import fullK.components.ViewOption;

class MainApp extends fullK.MainTemplate{ public static function main() MainTemplate.main();
    var option = new ViewOptions( 300, 100 );
    override public inline
    function setup(){
        trace('setup');
        frameStatGreySkin();
        createOption();
    }
    function createOption(){
        option.optionType   = ROUND;
        option.state        = [ true, false, false, false, false, false, false ];
        option.labels       = [ 'ROUND','SQUARE','CROSS','TICK','ROUND_TICK','TRIANGLE', 'TRIANGLE_TICK' ];
        option.optionChange = function( id: Int, state: Array<Bool> ){
            switch( id ){
                case 0:
                    option.optionType = ROUND;
                    option.updateState( 0 );
                case 1:
                    option.optionType = SQUARE;
                case 2: 
                    option.optionType = CROSS;
                case 3: 
                    option.optionType = TICK;
                case 4:
                    option.optionType = ROUND_TICK;
                case 5:
                    option.optionType = TRIANGLE;
                case 6:
                    option.optionType = TRIANGLE_TICK;
            }
        }
        option.optionOver   = function( id: Int ){ trace('over'); }
    }
    override public inline 
    function over(){
        option.hitOver( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function down(){
        option.hitCheck( interaction.mouseX, interaction.mouseY );
    }
    override public inline
    function render2D( g2: Graphics ){
        g2.drawRect( 100, 100, 100, 30 );
        g2.drawString( 'hello world', 105, 105 );
        option.renderView( g2 );
    }
}