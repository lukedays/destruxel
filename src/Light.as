package {
	import org.flixel.*;
	
	public class Light extends FlxSprite {
		[Embed(source = "assets/light.png")] protected var Img:Class;
				
		public function Light(x:Number, y:Number):void {
			super(x, y);
			loadGraphic(Img, true, true, 200, 200);
			blend = "screen";
			scale = new FlxPoint(12, 12);
			addAnimation("light", [2, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1], 10);
		}

		override public function draw():void {
			play("light");
		}
	}
}