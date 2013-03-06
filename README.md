# This project is still fairly premature, feel free though to get involved to move it along!

NXUI (Next Generation User Interface ) focuses on making gpu accelerated 2d/3d applications for Stage3D simple by creating an MVC 
container on top of existing stage3D Engines. Currently the targeted engines are Away3d and Starling in a mixed mode. Future
versions will support a dedicated starling or away3d game as well. 

This project attempts to hide a lot of the complexities and optimizations for boilerplate code. As a result this should allow
developers to much more rapidly develop applications.





```
[SWF(frameRate="60")]
public class MyApp extends Sprite
{
	
	public function MyApp()
	{
		// Create an NXUI instance that starts an Away3D and Starling Integrated project
		_engine = new Nxui(this, AwayStarlingEngine);
		// Go fullscreen if available
		_engine.fullScreen = true;
		// Push our new scene
		_engine.pushScene(Scene01);		
	}
	
}
```