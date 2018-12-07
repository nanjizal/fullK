package fullK.browser;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
#if js
import js.Browser;
import js.html.CanvasElement;
#end

class FullScreen {
    
    public static
    function setup(){
        #if js
        var win            = Browser.window;
        var document       = win.document;
        var doc            = document;
        var docElement     = doc.documentElement;
        var docStyle       = docElement.style;
        var bodyStyle      = doc.body.style;
        docStyle.padding   = "0";
        docStyle.margin    = "0";
        bodyStyle.padding  = "0";
        bodyStyle.margin   = "0";
        bodyStyle.color    = "0x9B7031";
        var canvas         = cast( doc.getElementById( "khanvas" ), CanvasElement );
        var canvaStyle     = canvas.style;
        canvaStyle.display = "block";
        var resize = 
        function() {
            var dpRatio     = win.devicePixelRatio;
            canvas.width    = Std.int( win.innerWidth * dpRatio );
            canvas.height   = Std.int( win.innerHeight * dpRatio );
            var nWid        = Std.int( canvas.width  / dpRatio );
            var nHi         = Std.int( canvas.height / dpRatio );
            if( nHi != hi || nWid != wid ){
                wid         = nWid;
                hi          = nHi;
                var size    = ( hi > wid )? wid: hi;
                scale       = size/768;
                canvaStyle.width  = docElement.clientWidth + "px";
                canvaStyle.height = docElement.clientHeight + "px";
                transform         = FastMatrix3.scale( scale, scale );
            }
        }
        win.onresize = resize;
        resize();
        #end
    }
    // more browser crap not used much on this.
    public static var wid:        Int  = 0;
    public static var hi:         Int  = 0;
    public static var transform:  FastMatrix3;
    public static var resize:     Void->Void;
    public static var scale:      Float = 1.;
    
}