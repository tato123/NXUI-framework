package com.nxui.display 
{
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.*;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 */
	public class LoadingSprite extends Sprite
	{
		private var progress:int = 0;;
		private var tf:TextField;
		private var prevTime:Number;
		
		public function LoadingSprite() 
		{			
			tf = new TextField(200,80,"");			
			tf.color = 0xFFFFFF;
			addChild(tf);		
			
			prevTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onEnterFrame(evt:Event) : void
		{
			var diff:Number = getTimer() - prevTime;
			if ( diff < 750 ) 
			{
				return ; 				
			}
			
			
			var minWidth:Number =  width==0? 200 : width;
			var minHeight:Number = height==0? 200: height;
			var dotCount:Number = 10;
			
			
			tf.text = "Loading";
			
			var i:int = 0;			
			for ( i; i < ( progress % dotCount); i++ )
			{
				tf.text += ".";
			}
			
			progress++;
			if ( progress % dotCount  == 0 )
			{
				progress == 0;
			}
			prevTime = getTimer();
		}
	
		
	}

}