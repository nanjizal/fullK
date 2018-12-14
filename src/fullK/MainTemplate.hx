package fullK;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import kha.Color;
import kha.Assets;
import kha.Scaler;
import kha.Font;
import kha.Color;
import kha.Assets;
import kha.Scheduler;
import kha.graphics2.Graphics;
import kha.graphics4.DepthStencilFormat;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.math.FastMatrix3;
import kha.math.FastMatrix4;
import kha.WindowOptions;
import kha.WindowMode;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import fullK.browser.FullScreen;
import kha.WindowOptions;
import kha.WindowMode;
import kha.Window;
import fullK.components.DragGraphic;
#if js
import js.Browser;
import js.html.CanvasElement;
#end
class MainTemplate {
    public var frameStats:       fullK.FrameStats;
    public var interaction:      fullK.Interaction;
    public var font:             Font;
    public var backgroundColor = 0xFF202020;
    var dragging: Bool;
    var renderViews =       new Array<Graphics->Void>();
    var rollOvers   =       new Array<Float->Float->Void>();
    var drags       =       new Array<DragGraphic>();
    var downChecks  =       new Array<Float->Float->Void>();
    var upChecks    =       new Array<Float->Float->Void>(); 
    public
    function setup(){
        trace( 'override setup' );
    }
    public
    function render2D( g: Graphics ){
        for( i in 0...renderViews.length ) renderViews[ i ]( g );
    }
    public
    function over(){
        for( i in 0...rollOvers.length ) rollOvers[ i ]( interaction.mouseX, interaction.mouseY );
    }
    public 
    function move(){
        for( i in 0...rollOvers.length ) rollOvers[ i ]( interaction.mouseX, interaction.mouseY );
    }
    public
    function down(){
        var mx = interaction.mouseX;
        var my = interaction.mouseY;
        var drag: DragGraphic;
        for( i in 0...drags.length ){
            drag = drags[ i ];
            var hit = drag.hitCheck( mx, my );
            if( hit ){
                interaction.dragItem = cast drag;
                renderViews = toLast( renderViews, drag.renderView );
                dragging = true;
            }
        }
        for( i in 0...downChecks.length ) downChecks[ i ]( mx, my );
    }
    public
    function up(){
        var mx = interaction.mouseX;
        var my = interaction.mouseY;
        dragging = false;
        for( i in 0...upChecks.length ) upChecks[ i ]( mx, my );
    }

    public static 
    function main() {
        FullScreen.setup();
        System.start( {  title: "fullK"  /* newer kha setup */
                             ,  width: 1024, height: 768
                             ,  window: { windowFeatures:    FeatureResizable }
                             , framebuffer: { samplesPerPixel: 4 } }
                             , function( window: Window ){
                                new MainApp();
        } );
        /* // DO NOT REMOVE:
        System.init( { title: "fullK"/* older kha setup *//*
                    ,  width: 1024, height: 768
                    ,  samplesPerPixel: 4 }
                    ,  function(){ new MainApp();
        } );
        */
    }
    public function new(){ Assets.loadEverything( loadAll ); }
    public 
    function loadAll(){
        Browser.window.dispatchEvent( new js.html.Event('resize') );
        font                 = Assets.fonts.OpenSans_Regular;
        interaction          = new Interaction();
        frameStats           = new FrameStats( interaction );
        interaction.dnMouse  = down;
        interaction.upMouse  = up;
        interaction.over     = over;
        interaction.move     = move;
        setup();
        startRendering();
    }
    public function frameStatGreySkin(){
        frameStats.bgColor   = Color.White;
        frameStats.foreColor = Color.fromValue( 0xFF000c00 );
        frameStats.subColor  = Color.fromValue( 0xFF0000aa );
        frameStats.bgAlpha   = 0.7;
        frameStats.foreAlpha = 0.9;
    }
    inline
    function startRendering(){
        // DO NOT REMOVE:
       System.notifyOnFrames( function ( framebuffer ) { render( framebuffer[0] ); } ); // newer Kha setup
       //System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    // moves specific item to end so it's accessed last ( like render function to render last )
    public
    function toLast<T>( arr: Array<T>, top: T ): Array<T> {
        var temp = new Array<T>();
        var j = 0;
        var t: T;
        for( i in 0...arr.length ){
            t = arr[ i ];
            if( t != top ) temp[ j++ ] = t;
        }
        temp[ j++ ] = top;
        return temp;
    }
    inline
    function render( framebuffer: Framebuffer ){
        var g2 = framebuffer.g2;
        g2.begin( Color.fromValue( backgroundColor ) );
        g2.color = Color.White;
        g2.font = font;
        g2.fontSize = 22;
        render2D( g2 );
        frameStats.render( g2 );
        g2.end();
    }
}