package {
	import org.flixel.*;
	
	public class MenuState extends FlxState {
		override public function create():void {
			FlxG.bgColor = 0xffd8d7a6;
			FlxG.shake(0.01, 0.2);
			
			var text:FlxText = new FlxText(0, 50, 800, "Destruxel");
			text.setFormat(null, 72, 0x43230a, "center", 0xff000000);
			add(text);
			
			text = new FlxText(0, 500, 800, "Press any button to start");
			text.setFormat(null, 24, 0x000000, "center");
			add(text);
		}
		
		override public function update():void {
			if (FlxG.keys.any()) FlxG.switchState(new PlayState());
			super.update();
		}
	}
}