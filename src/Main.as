package {
	import org.flixel.*;
	
	[SWF(width = "1200", height = "680", backgroundColor = "#000000")]
	
	public class Main extends FlxGame {
		public function Main() {
			super(1200, 680, PlayState, 1, 60, 60);
			forceDebugger = true;
		}
	}
}