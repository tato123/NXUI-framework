package nxui.core
{

	import com.nxui.display.AnimationSprite;
	import com.nxui.display.SceneProxy;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import nxui.display.IEngineDisplayProxy;
	import nxui.display.Scene;
	import nxui.events.NxuiEvent;
	
	import starling.core.Starling;
	import starling.utils.AssetManager;

	

	/**
	 * Scene simiplifies the creation of a away3d + starling project
	 * by completly managing 
	 * 
	 * 
	 * 
	 */
	public class Nxui extends EventDispatcher
	{
		// Current context
		private var _root:Sprite;
		private var _displayList:Array;
		private var _sceneList:Array;
		private var _context:Nxui;
		private var _firstFrameComplete:Boolean = false;
		
		
		// Stage manager and proxy instances
		private var stage3DManager : Stage3DManager;
		private var _stage3DProxy : Stage3DProxy;
		
		// Calcalate time
		private var deltaTime:Number;
		private var prevFrame:Number; // The time of the previous frame rendered.
		
		// 
		private static var _current:Nxui;

		
		private var _animationLayer:Starling;
		private var _contextReady:Boolean;
		private var _fullScreen:Boolean;
		
		private var _assetManager:AssetManager;
		
		public function Nxui(root:Sprite)
		{
			_root = root;
			_root.stage.align = StageAlign.TOP_LEFT;
			_root.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Init the display list and scenes
			_displayList = new Array();
			_sceneList = new Array();
			_contextReady = false;
			
			_assetManager = new AssetManager();
			
			// Define a new Stage3DManager for the Stage3D objects
			stage3DManager = Stage3DManager.getInstance(_root.stage);
			

			// Create a new Stage3D proxy to contain the separate views
			_stage3DProxy = stage3DManager.getFreeStage3DProxy();
			_stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			_stage3DProxy.antiAlias = 8;
			_stage3DProxy.color = 0x0;		
		
			_current = this;
			
			start();	
		}
		
		public function start() : void
		{
			_root.addEventListener(Event.ENTER_FRAME, onFrameEnter);
			prevFrame = getTimer();
		}
		
		public function stop() : void
		{
			_root.removeEventListener(Event.ENTER_FRAME, onFrameEnter);
		}
		
		// +---------------------------------------------------------------------
		// Event Listeners
		// +---------------------------------------------------------------------
		
		public function onContextCreated(evt:Event) : void
		{
			//
			createAnimationLayers();	
		}
		
		
		
		public function onFrameEnter(evt:Event ) : void
		{
			// Weird timing bug appears sometimes,
			// wait until ready
			if ( Starling.context == null ) 
			{
				
				return ;
			}
			if ( !_firstFrameComplete ) 
			{
				
				dispatchEvent(new NxuiEvent(NxuiEvent.FRAMEWORK_INITIALIZED));
				_firstFrameComplete = true;
			}
			
			// Don't bother rendering if there isn't anything
			// on the view stack
			if ( _displayList.length == 0 )
			{
				return ;
			}
			
			
			stage3DProxy.clear();
			
			deltaTime = (getTimer() - prevFrame) * 0.001;
			
			
			// Render the content for each layer			
			if ( _sceneList.length > 0  )
			{
				var sceneProxy:SceneProxy = SceneProxy(_sceneList[_sceneList.length-1]) as SceneProxy;
				var currentScene:Scene = sceneProxy.scene as Scene;
				
				// play animation on first pass
				if ( !sceneProxy.visible ) 
				{
					currentScene.willAppear();
					sceneProxy.visible = true;
				}
				else 
				{
					currentScene.update(deltaTime);	
				}
				
			}
			
			// Draw each layer to the frame buffer
			for each (var obj:Object in _displayList ) 
			{
				
				if ( obj["type"] == getQualifiedClassName(Starling) )
				{
					Starling(obj["child"]).nextFrame();
				}
				else if ( obj["type"] == getQualifiedClassName(View3D) )
				{
					View3D(obj["child"]).render();
				}
			}
		
			// animation layer
			if ( animation2dLayer ) 
			{
				animation2dLayer.nextFrame();	
			}
		
			
			
			
			// Swap for display buffer
			stage3DProxy.present();
			
		}

		
		// +---------------------------------------------------------------------
		// Display Hiearchy
		// +---------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function getChildWithTag(id:String) : Object
		{
			for each (var child:Object in _displayList)
			{
				if ( child["id"] == id )
				{
					return child["child"];
				}
			}
			return null;
		}
		
		/**
		 * Add a display child
		 */
		public function addChild(child:Object, id:String=null) : void
		{
			if ( child is Starling || child is View3D) 
			{				
				
				var ref:Object = {"type":getQualifiedClassName(child), "child":child, "id":id};				
				_displayList.push(ref);
				
				if ( child is View3D )
				{					
					_root.addChild(View3D(child));	
				}
				
				 
			}
			else
			{
				throw new Error("[NXUI] Scene child must be of type starling or away3d");
			}
		}
		
		/**
		 * Get the children 
		 */
		public function getChildAt(index:Number, prefetch:Number) : Object
		{
			return _displayList.getItemAt(index, prefetch);
		}
		
		/**
		 * Provides an immutable array instance
		 */
		public function getChildren() : Array
		{
			return _displayList.toArray();
		}
		
		/**
		 * Pushes a scene onto the current display hiearchy
		 */
		public function pushScene(SceneClass:Class) : void
		{
			if ( _sceneList ) 
			{
				var sceneInstance:Scene = new SceneClass();				
				
				var sceneProxy:SceneProxy = new SceneProxy(sceneInstance);
				_sceneList.push(sceneProxy);
			}
		}
		
		// +---------------------------------------------------------------------
		// Dispatcher Implementation
		// +---------------------------------------------------------------------
		
		public function generateLayers(children:Array) : void
		{
			if ( children ) 
			{
				for each ( var child:Object in children ) 
				{
					if ( child is IEngineDisplayProxy)
					{						
						addChild(IEngineDisplayProxy(child).createInstance(_root.stage, stage3DProxy));
					}
					else if ( child is Object ) 
					{
						addChild(IEngineDisplayProxy(child["layer"]).createInstance(_root.stage, stage3DProxy), child["id"]);
					}
				}
			}
		}
		
		private function createAnimationLayers() : void
		{
			// Generate animation layer
			_animationLayer =  new Starling(AnimationSprite, _root.stage, stage3DProxy.viewPort,stage3DProxy.stage3D);
			//_animationLayer.shareContext = true;
			_animationLayer.antiAliasing = 1;			
		}
		
		public function enqueue(...rawAssets) : void
		{			
			_assetManager.enqueue(rawAssets);
			
			_assetManager.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio);
				
				if (ratio == 1.0)
				{
					dispatchEvent(new NxuiEvent(NxuiEvent.ASSETMANAGER_LOADCOMPLETE));
				}
					
			});
		}
		
		// +---------------------------------------------------------------------
		// Other Get / Set
		// +---------------------------------------------------------------------
		
		/** Root flash view */
		public function get root() : Sprite { return _root;}
		/** Current context*/
		public static function get current() :  Nxui { return _current;}
		/** Current context*/
		public function get stage3DProxy() :  Stage3DProxy { return _stage3DProxy;}
		/** Current context*/
		public function get animation2dLayer() :  Starling { return _animationLayer;}
		
		public function set fullScreen(val:Boolean) : void 
		{ 
			_fullScreen=val; 
			if (_fullScreen) 
			{
				_root.stage.displayState = StageDisplayState.FULL_SCREEN;
			} 
		} 
		public function get assetManager():AssetManager	{return _assetManager;}
		
	}
}