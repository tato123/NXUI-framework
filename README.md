# This project is still fairly premature, feel free though to get involved to move it along!

NXUI (Next Generation User Interface ) focuses on making gpu accelerated 2d/3d applications simple by leveraging the
away3d and starling frameworks. The frameworks can share a common stage3dproxy, which while fundamentally sound can 
come with a lot of boilerplate. NXUI attempts to manage the boilerplace so developers can rapidly develop applications.

```
[SWF(frameRate="60")]
public class MyApp extends Sprite
{
	
	public function MyApp()
	{
		// Assuming 
		engine = new Nxui(this);	
		// Tell the engine to go into fullscreen (works on Adobe Air)		
		engine.fullScreen = true;		
		// Event listener when all framework layers have been created
		engine.addEventListener(NxuiEvent.FRAMEWORK_INITIALIZED, contextCreated);	
	}
	
	public function contextCreated(evt:NxuiEvent) : void
	{				
		Nxui.current.enqueue(Graphics,Sounds);
		engine.addEventListener(NxuiEvent.ASSETMANAGER_LOADCOMPLETE, assetsLoaded);	
	}
	
	public function assetsLoaded(evt:NxuiEvent) : void
	{
		engine.generateLayers([
			{"layer":new StarlingProxy(BackgroundSprite),"id": "background"}
			
		]);
		engine.pushScene(MainScene);
	}
}
```