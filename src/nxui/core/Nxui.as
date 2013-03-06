package nxui.core
{

	import com.nxui.display.AnimationSprite;
	import com.nxui.display.LoadingSprite;
	import com.nxui.display.SceneProxy;
	import flash.display.Stage3D;
	import flash.geom.Rectangle;
	import nxui.display.SceneBase;
	import nxui.events.SceneEvent;
	import nxui.support.IEngineSupport;
	import starling.utils.AssetManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;	
	
	import nxui.display.IEngineDisplayProxy;	
	import nxui.events.NxuiEvent;

	/**
	 * Scene simiplifies the creation of a away3d + starling project
	 * by completly managing the entire stack, creating rendering layers
	 * automatically from scene objects, handling transitions, etc....
	 */
	public class Nxui extends EventDispatcher
	{
		// Current context
		private var _root:Sprite;		
		private var _sceneList:Array;		
		private var _firstFrameComplete:Boolean = false;
				
		/** Calcalate time */
		private var deltaTime:Number;
		/** The time of the previous frame rendered. */
		private var prevFrame:Number; 	
				
		/** Current NXUI layer*/
		private static var _current:Nxui;
		/** Set to Fullscreen*/
		private var _fullScreen:Boolean;		
		/** Semaphore style locking  */
		private var _locks:int = 0;
			
		/** Asset Manager */
		private var _assetManager:AssetManager;
		/** Scene bootstrapper */
		private var _bootstrapper:SceneBootstrapper;
			
		/** Get the engine started */
		private var _engineSupport:IEngineSupport;
		/** Stage3D */
		private var _stage3D:Stage3D;
		
		/**
		 * Constructor for NXUI which will handle managing 
		 * a stage3D engine by providing a boilerplate to any engine type
		 * 
		 * @param	root
		 */
		public function Nxui(root:Sprite, Engine:Class)
		{
			
			
			// Configure the root
			_root = root;
			_root.stage.align = StageAlign.TOP_LEFT;
			_root.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Start the engine
			_engineSupport = new Engine();
			_engineSupport.addEventListener(NxuiEvent.CONTEXT_CREATED, onContextCreated);
			_stage3D = _engineSupport.initializeStage3D(_root);
			
			// Init the display list and scenes			
			_sceneList = [];
			
			_bootstrapper = _bootstrapper = new SceneBootstrapper();
			_bootstrapper.addEventListener(SceneEvent.LOAD_COMPLETE, onLoadComplete);
			_bootstrapper.addEventListener(SceneEvent.LOAD_ERROR, onLoadError);
			_assetManager = new AssetManager();
			
			_current = this;
			
			addEventListener(NxuiEvent.ASSETMANAGER_LOADCOMPLETE, onAssetLoadComplete);
						
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
		
		
		/**
		 * Creates supplemental layers that might be needed
		 * for transitions and such
		 * @param	evt
		 */
		public function onContextCreated(evt:Event) : void
		{
			//
			_engineSupport.createAnimationLayer();	
			// 
			_engineSupport.createLoadingLayer();		
		}
		
		private function onAssetLoadComplete(evt:Event) : void
		{
			queueStatus(NxuiStatus.RUNNING);
		}
		
		/**
		 * Frame renderer, responsible for rendering the current scene
		 * 
		 * 
		 * @param	evt
		 */
		public function onFrameEnter(evt:Event ) : void
		{
			
			_engineSupport.clearScreenBuffer();
						
			// Render only if engines are ready
			// otherwise display the loading screen
			if ( isStageContextReady() ) 
			{		
				
				deltaTime = (getTimer() - prevFrame) * 0.001;
						
				// Render the content for each layer			
				var currentScene:Object = _sceneList[_sceneList.length-1];								
				currentScene.update(deltaTime);					
				_engineSupport.renderAnimationLayer();
			}
			else
			{
				// Display a loading texture on the flash 
				// display list that will hide the app until it is ready
				_engineSupport.renderLoadingLayer();
								
			}			
			
			
			// Swap for display buffer
			_engineSupport.presentScreenBuffer();
				
		}

		
		// +---------------------------------------------------------------------
		// Display Hiearchy
		// +---------------------------------------------------------------------
		
		/**
		 * Change a semaphore lock
		 * 
		 * @param	status
		 */
		public function queueStatus(status:String ) : void
		{			
			switch ( status ) 
			{
				case NxuiStatus.LOADING:
					_locks++;
					break;
				case NxuiStatus.RUNNING:
					_locks--;
					break;	
			}
		}		
		
		/**
		 * Pushes a scene onto the current display hiearchy
		 * 
		 */
		public function pushScene(SceneClass:Class) : void
		{
			// Enque switches the current status to loading
			queueStatus(NxuiStatus.LOADING);
			
			// Load the scene 
			if ( _sceneList ) 
			{
				_bootstrapper.loadScene(SceneClass);			
			}
			else 
			{
				throw new Error("[NXUI] Unable to load scene, scene list is null");
			}
		}
		
		/**
		 * Pop a scene
		 * 
		 * @return
		 */
		public function popScene() : SceneBase
		{
			var scene:SceneBase =  _sceneList.pop();
			scene.willDisappear();
			scene.dispose();			
			return scene;
		}
		
		// +---------------------------------------------------------------------
		// Dispatcher Implementation
		// +---------------------------------------------------------------------

		/**
		 * There are many preconditions that can define whether
		 * a stage is actually ready to be rendered when multiple
		 * scenes and stage3d layers are involved. Method
		 * tries to check all those preconditions 
		 * 
		 * @return
		 */
		public function isStageContextReady() : Boolean
		{
			
			// It is ackward to see scoping brackets in a method
			// but this is to make sure the code is clearly divided
			// between not ready and ready
			
			// Not Ready
			if ( !_engineSupport.isStageContextReady() )
			{
				return false;
			}
					
			
			if ( _sceneList.length == 0 )
			{
				return false;
			}
			
			// Something is loading
			if ( _locks > 0 ) 
			{
				return false;
			}
		
		
			// Ready, go ahead and flip flags and such			
			if ( !_firstFrameComplete ) 
			{				
				dispatchEvent(new NxuiEvent(NxuiEvent.FRAMEWORK_INITIALIZED));
				_firstFrameComplete = true;					
			}
		
			
			return true;
		}		
		
		/**
		 * Enqueue a global asset to the appropriate starling or away3d asset manager
		 * 
		 * @param	...rawAssets
		 */
		public function enqueue(...rawAssets) : void
		{	
			queueStatus(NxuiStatus.LOADING);
			
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
		
		/**
		 * A scene loaded succesfully
		 * @param	evt
		 */
		public function onLoadComplete(evt:SceneEvent) : void
		{
			
			trace("Loading Complete");
			_sceneList.push(evt.scenes[0]);
			evt.scenes[0].willAppear();
			queueStatus(NxuiStatus.RUNNING);
		}
		
		/**
		 * A scene received an error when attempting to load
		 * @param	evt
		 */
		public function onLoadError(evt:SceneEvent) : void
		{
			queueStatus(NxuiStatus.RUNNING);
			trace("Loading Error");
			throw new Error("[NXUI] An error occured loading a scene");
			
		}
		
		// +---------------------------------------------------------------------
		// Other Get / Set
		// +---------------------------------------------------------------------
		
		/** Root flash view */
		public function get root() : Sprite { return _root;}
		
		/** Current context*/
		public static function get current() :  Nxui { return _current;}
	
		/** Get the asset manager */
		public function set fullScreen(val:Boolean) : void 
		{ 
			_fullScreen=val; 
			if (_fullScreen) 
			{
				_root.stage.displayState = StageDisplayState.FULL_SCREEN;
			} 
		} 
		
		/** Get the asset manager */
		public function get assetManager():AssetManager	{ return _assetManager; }		
		/** Get the current engine support class */
		public function get engineSupport() : IEngineSupport { return _engineSupport; }
		
		/** Get the current engine support class */
		public function get viewPort() : Rectangle { return new Rectangle(0, 0, root.width, root.height); }
		
			
		/** Get the current engine support class */
		public function get stage3D() : Stage3D { return _stage3D; }
	}
}

/**
 * Describes the status changes that can occur internally as assets, scenes, etc... are loaded
 */
class NxuiStatus 
{
	public static const RUNNING:String = "RUNNING";
	public static const LOADING:String = "LOADING";
	
}