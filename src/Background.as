package {
	import org.flixel.*;
	
	public class Background extends FlxSprite {
		[Embed(source = "assets/bg2.png")] protected var Img:Class;
		
		public function Background(x:Number, y:Number, scroll:Number) {
			super(x, y);
			loadGraphic(Img, false, false, R.map.width, R.map.height, false);
			scrollFactor.x = scrollFactor.y = 1;
			solid = false;
		}	
	}
}