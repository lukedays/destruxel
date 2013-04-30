package {
	import org.flixel.*;
	
	public class MenuState extends FlxState {
		[Embed(source = "assets/song2.mp3")] private var Song2:Class;
		protected var _host:String = "128.238.56.208";
		protected var _port:int = 1165;
		
		override public function create():void {
			FlxG.bgColor = 0xffd8d7a6;
			FlxG.shake(0.01, 0.2);
			
			addBasicUI();
			addNetworkUI();
			
			R.socket1 = new CustomSocket(_host, _port); // For login and player's positions
			R.socket2 = new CustomSocket(_host, _port + 1); // For block creation/destruction
			
			FlxG.play(Song2, 0.08, true);
		}
		
		public function addBasicUI():void {
			var text:FlxText = new FlxText(0, 50, FlxG.width, "Destruxel");
			text.setFormat(null, 80, 0xAA0000, "center", 0xff000000);
			add(text);
			
			text = new FlxText(0, 250, FlxG.width, "Objective -> drop the opponent!\nW, A, D -> move and jump\nMouse -> aim and hold to destroy\nSHIFT -> hold to build");
			text.setFormat(null, 35, 0x000000, "center", 0xff000000);
			add(text);
		}
		
		public function addNetworkUI():void {
			var text:FlxText = new FlxText(0, 32, FlxG.width, "Server  " + _host);
			text.setFormat(null, 14, 0x000000, "left");
			add(text);
			
			text = new FlxText(0, 47, FlxG.width, "Port  " + _port);
			text.setFormat(null, 14, 0x000000, "left");
			add(text);
			
			R.textPlayer1Number = new FlxText(2, 2, FlxG.width, "Player 1 Offline");
			R.textPlayer1Number.setFormat(null, 14, 0x000000, "left");
			R.textPlayer1Number.color = 0xAA0000;
			add(R.textPlayer1Number);
			
			R.textPlayer2Number = new FlxText(2, 17, FlxG.width, "Player 2 Offline");
			R.textPlayer2Number.setFormat(null, 14, 0x000000, "left");
			R.textPlayer2Number.color = 0xAA0000;
			add(R.textPlayer2Number);
		}
		
		override public function update():void {
			if (FlxG.keys.any()) FlxG.switchState(new PlayState());
			super.update();
		}
	}
}