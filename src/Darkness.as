package {
	import org.flixel.*;
	public class Darkness extends FlxSprite {				
		public function Darkness():void {
			super(0, 0);
			makeGraphic(FlxG.width, FlxG.height, 0xff222222);
			scrollFactor.x = scrollFactor.y = 0;
			blend = "multiply";
		}

		override public function draw():void {
			fill(0xff222222);
			stamp(R.light, R.light.x - R.light.width / 2, R.light.y - R.light.height / 2);
			super.draw();
		}
	}
}