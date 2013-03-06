package nxui.support 
{
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	import com.nxui.display.AnimationSprite;
	import com.nxui.display.LoadingSprite;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.EventDispatcher;
	import nxui.events.NxuiEvent;
	import starling.core.Starling;
	/**
	 * ...
	 */
	public class AwayStarlingEngine extends EventDispatcher implements IEngineSupport 
	{
		
		// Stage manager and proxy instances
		private var _stage3DManager : Stage3DManager;
		private var _stage3DProxy : Stage3DProxy;
		private var _root : Sprite;
		/** 2D animation layer */
		private var _animationLayer:Starling;	
		/** 2D animation layer */
		private var _loadingSprite:Starling;	
		
		public function AwayStarlingEngine() 
		{
			
		}
	
		public function initializeStage3D(root:Sprite) : Stage3D
		{
			// application root
			_root = root;
			
			// Define a new Stage3DManager for the Stage3D objects
			_stage3DManager = Stage3DManager.getInstance(_root.stage);			

			// Create a new Stage3D proxy to contain the separate views
			_stage3DProxy = _stage3DManager.getFreeStage3DProxy();
			_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			_stage3DProxy.antiAlias = 2;
			_stage3DProxy.color = 0x0;		
			
			return _stage3DProxy.stage3D;
		}
		
		private function onContextCreated(evt:Stage3DEvent) : void
		{
			dispatchEvent(new NxuiEvent(NxuiEvent.CONTEXT_CREATED));
		}
		
		public function createAnimationLayer() : Object
		{
			// Generate animation layer
			_animationLayer =  new Starling(AnimationSprite, _root.stage, _stage3DProxy.viewPort,_stage3DProxy.stage3D);
			_animationLayer.shareContext = true;
			_animationLayer.antiAliasing = 1;			
			trace("Animation Layer Created");
			return _animationLayer;
		}
		
		public function createLoadingLayer() : Object
		{
			// Generate animation layer
			_loadingSprite =  new Starling(LoadingSprite, _root.stage, _stage3DProxy.viewPort,_stage3DProxy.stage3D);
			_animationLayer.shareContext = true;
			_loadingSprite.antiAliasing = 1;	
			trace("Loading Layer Created");
			return _loadingSprite;
		}
		
		public function clearScreenBuffer() : void 
		{
			_stage3DProxy.clear();
		}
		
		public function presentScreenBuffer() : void
		{
			_stage3DProxy.present();
		}
		
		public function isStarlingReady() :Boolean
		{
			if ( Starling.context == null ) 
			{				
				return false;
			}	
			return true;
		}
		
		public function isStageContextReady() : Boolean
		{
			// Not Ready
			if ( !isStarlingReady() )
			{
				return false;
			}
			return true;		
		}
		
		public function renderAnimationLayer() : void
		{
			_animationLayer.nextFrame();
		}
		
		public function renderLoadingLayer() : void
		{
			_loadingSprite.nextFrame();
		}
	}

}