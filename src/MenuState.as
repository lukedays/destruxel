package {
	import org.flixel.*;
	import flash.display.*;
	import flash.utils.*;
	
	public class MenuState extends FlxState {
		override public function create():void {
			FlxG.bgColor = 0xffd8d7a6;
			FlxG.shake(0.01, 0.2);
			
			var text:FlxText = new FlxText(0, 50, FlxG.width, "Destruxel");
			text.setFormat(null, 72, 0x43230a, "center", 0xff000000);
			add(text);
			
			text = new FlxText(0, 500, FlxG.width, "Press any button to start");
			text.setFormat(null, 24, 0x000000, "center");
			add(text);
			
			R.textPlayerNumber1 = new FlxText(2, 2, FlxG.width, "Player 1 Offline");
			R.textPlayerNumber1.setFormat(null, 15, 0x000000, "left");
			R.textPlayerNumber1.color = 0xFF0000;
			add(R.textPlayerNumber1);
			
			R.textPlayerNumber2 = new FlxText(2, 20, FlxG.width, "Player 2 Offline");
			R.textPlayerNumber2.setFormat(null, 15, 0x000000, "left");
			R.textPlayerNumber2.color = 0xFF0000;
			add(R.textPlayerNumber2);
			
			R.socket = new CustomSocket("localhost", 1135);
		}
		
		override public function update():void {
			if (FlxG.keys.any()) FlxG.switchState(new PlayState());
			
			super.update();
		}
	}
}