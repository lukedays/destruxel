package {
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
	import flash.errors.*;
	import com.adobe.serialization.json.JSON;

	public class CustomSocket extends Socket {
		public var response:String;

		public function CustomSocket(host:String, port:uint) {
			super();
			configureListeners();
			if (host && port)  {
				super.connect(host, port);
			}
		}

		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		public function write(str:String):void {
			try {
				writeUTFBytes(str);
			}
			catch(e:IOError) {
				trace(e);
			}
		}
		
		private function readResponse():void {
			response = readUTFBytes(bytesAvailable);
			
			// Responses sometimes come in batch
			var split:Array = response.split("}");
			for (var i:int = 0; i < split.length - 1; ++i) {
				
				var obj:Object = JSON.decode(split[i] + "}");
				if (obj.login) {
					if (!R.playerNumber) R.playerNumber = obj.player;
						
					if (obj.player >= 1) {
						R.textPlayer1Number.text = "Player 1 Online";
						R.textPlayer1Number.color = 0x00AA00;
					}
					
					if (obj.player >= 2) {
						R.textPlayer2Number.text = "Player 2 Online";
						R.textPlayer2Number.color = 0x00AA00;
					}
				}
				else if (obj.block) {
					if (obj.x && obj.y) {
						R.map.setTile(parseInt(obj.x), parseInt(obj.y), parseInt(obj.tile));
						R.shadows.updateVertices();
					}
				}
				else if (obj.x && obj.y) {
					if (R.player2) {
						R.player2.x = parseFloat(obj.x);
						R.player2.y = parseFloat(obj.y);
					}
				}
			}
		}

		private function closeHandler(event:Event):void {
			trace("closeHandler: " + event);
			trace(response.toString());
		}

		private function connectHandler(event:Event):void {
			trace("connectHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			//trace("socketDataHandler: " + event);
			readResponse();
		}
	}
}
