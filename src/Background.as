package {
	import org.flixel.*;
	
	public class Background extends FlxSprite {
		[Embed(source = "assets/bg.png")] protected var Img:Class;
		
		public function Background(x:Number, y:Number, scroll:Number) {
			super(x, y);
			if (R.map) loadGraphic(Img, false, false, R.map.width, R.map.height, false); // Play
			else { // Menu
				loadGraphic(Img, false, false, FlxG.width, FlxG.height, false);
				alpha = 0.4;
			}
			scrollFactor.x = scrollFactor.y = 1;
			solid = false;
		}	
	}
}