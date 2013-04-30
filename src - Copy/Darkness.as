package {
	import org.flixel.*;
	
	public class Darkness extends FlxSprite {				
		public function Darkness():void {
			super(0, 0);
			makeGraphic(R.map.width, R.map.height, 0xff333333);
			scrollFactor.x = scrollFactor.y = 1;
			blend = "multiply";
		}

		override public function draw():void {
			fill(0xff333333);
			stamp(R.light, R.light.x - R.light.width / 2, R.light.y - R.light.height / 2);
			super.draw();
		}
	}
}