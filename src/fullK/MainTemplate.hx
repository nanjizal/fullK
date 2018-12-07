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

#if js
import js.Browser;
import js.html.CanvasElement;
#end
class MainTemplate {
    public var frameStats:       fullK.FrameStats;
    public var interaction:      fullK.Interaction;
    public var font:             Font;
    public var backgroundColor = 0xFF202020;
    public
    function setup(){
        trace( 'override setup' );
    }
    public
    function render2D( g2: Graphics ){
        trace( 'override render2D' );
    }
    public
    function over(){
        trace( 'override over' );
    }
    public
    function down(){
        trace( 'override down' );
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
        interaction.over     = over;
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