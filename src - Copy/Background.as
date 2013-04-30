package {
	import org.flixel.*;
	
	public class Background extends FlxSprite {
		[Embed(source = "assets/bg.png")] protected var Img:Class;
		
		public function Background(x:Number, y:Number, scroll:Number) {
			super(x, y);
			loadGraphic(Img, false, false, FlxG.width, FlxG.height, false);
			scrollFactor.x = scrollFactor.y = 0;
			solid = false;
		}	
	}
}