package {
	import org.flixel.*;
	
	public class Background extends FlxSprite {
		[Embed(source = "assets/bg.png")] protected var BackgroundImg:Class;
		
		public function Background(x:Number, y:Number, scroll:Number) {
			super(x, y);
			loadGraphic(BackgroundImg, false, false, 800, 600, false);
			scrollFactor.x = scrollFactor.y = scroll;
			solid = false;
		}	
	}
}