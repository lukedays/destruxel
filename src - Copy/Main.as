package {
	import org.flixel.*;	
	[SWF(width = "1200", height = "600", backgroundColor = "#000000")]
	
	public class Main extends FlxGame {
		public function Main() {
			super(1200, 600, MenuState, 1, 60, 60);
			forceDebugger = true;
		}
	}
}