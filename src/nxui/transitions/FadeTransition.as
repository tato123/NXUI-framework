package nxui.transitions
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import nxui.core.Nxui;
	
	import starling.animation.IAnimatable;
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;


	/**
	 * Fade effect is a 2d effect that is rendered into a starling
	 * context
	 */
	public class FadeTransition implements IAnimatedTransition
	{
		public static const FADE_IN:String = "fadeIn";
		public static const FADE_OUT:String = "fadeOut";
		
		private var color:uint = 0x000000;
		private var duration:Number
		private var type:String;
		private var runningAnimation:IAnimatable;
		
		// Add a sprite, i.e. loading screen

		private var mSprite:DisplayObject;
		private var placement:String;
		
		private var _delay:Number = 0;
		public var onComplete:Function;
		public var onStart:Function;
		
		public function FadeTransition(color:uint=0x000000, duration:Number=5, animationType:String="fadeOut", sprite:DisplayObject=null, placement:String="center")
		{

			this.color = color;
			this.duration = duration;
			this.type = animationType;
			this.mSprite = sprite;
			this.placement = placement;
		}
		
		public function set delay(val:Number):void
		{
			this._delay = val;
		}
		
		
		public function createQuad(viewPort:Rectangle) : Sprite
		{
			
			var displaySprite:Sprite = new Sprite();
			displaySprite.width = viewPort.width;
			displaySprite.height = viewPort.height;
			displaySprite.x = 0;
			displaySprite.y = 0;
				

			var rect:flash.display.Sprite = new flash.display.Sprite();
			rect.graphics.lineStyle(0,color,1);
			rect.graphics.beginFill(color,1);
			rect.graphics.drawRect(0,0,viewPort.width,viewPort.height);
			rect.graphics.endFill();
			
			var bmd:flash.display.BitmapData = new flash.display.BitmapData(rect.width, rect.height, true);
			bmd.draw(rect);
			
						
			var img:Image = new Image(Texture.fromBitmapData(bmd,false,true,1));
			displaySprite.addChild(img);
			
			
			// if we have an additional sprite add it too
			if (mSprite ) 
			{
				switch(placement)
				{
					case "center":
					{
						mSprite.x = viewPort.width/2;
						mSprite.y = viewPort.height/2;
						displaySprite.addChild(mSprite);
						break;
					}
						
					default:
					{
						break;
					}
				}
			}
			
			
			return displaySprite;
						
		}
		
		
		public function play() : void
		{
			// Get the current engine instance
			var mCurrent:Nxui = Nxui.current;
			
			
			// Create our quad from the information
			var quad:Sprite  = createQuad(mCurrent.stage3DProxy.viewPort);	
			Sprite(mCurrent.animation2dLayer.root).addChild(quad);
			var tween:Tween;
			switch (type)
			{
				case FADE_IN:
					tween = new Tween(quad,duration);
					quad.alpha=0.0;			
					tween.fadeTo(1.0);
					break;
				case FADE_OUT:
					tween = new Tween(quad,duration);
					quad.alpha=1.0;			
					tween.fadeTo(0.0);
					
					break;
				
			}
			tween.onStart = onStart;
			tween.onComplete = onComplete;
			tween.delay = _delay;
			// Add animation
			runningAnimation = tween;
			
			// Add to the animation layer
			mCurrent.animation2dLayer.juggler.add(tween);

		}
		
		public function stop() : void
		{
			Nxui.current.animation2dLayer.juggler.remove(runningAnimation);
		}
		
	}
}