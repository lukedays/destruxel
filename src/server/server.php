<?php

error_reporting(~E_NOTICE);
set_time_limit(0);
 
$address = "10.5.43.167";
$port = 1148;
$max_players = 2;
 
$sock = socket_create(AF_INET, SOCK_STREAM, 0);
socket_bind($sock, $address, $port);
socket_listen($sock, $max_players);

$players = array();
$read = array();
 
while (true) {
    $read = array();
    $input = array();
    $read[0] = $sock;
     
    for ($i = 0; $i < $max_players; $i++) {
        if ($players[$i] != null) {
            $read[$i+1] = $players[$i];
        }
    }
	
    socket_select($read, $write, $except, null);
	
    if (in_array($sock, $read)) {
        for ($i = 0; $i < $max_players; $i++) {
            if ($players[$i] == null) {
                $players[$i] = socket_accept($sock);
                 
                if (socket_getpeername($players[$i], $address, $port)) {
                    echo "Client $address : $port is now connected to us.\n";
                }
				
				// Broadcast data
				for ($j = 0; $j < $max_players; $j++) {
					if ($players[$j] != null) {
						$message = array("login" => true, "player" => ($i + 1));
						socket_write($players[$j], json_encode($message));
					}
				}
				
                break;
            }
        }
    }
	
    for ($i = 0; $i < $max_players; $i++) {
		if ($players[$i] != null) {
			if (in_array($players[$i], $read)) {
				$input = socket_read($players[$i], 1024);
				 
				if ($input == null) {
					unset($players[$i]);
					socket_close($players[$i]);
				}
				
				// Send to the other player
				if ($i == 0) {
					$j = 1;
				}
				else {
					$j = 0;
				}
				
				
				$input = json_decode($input);
				if ($input->block) {
					$message = array("block" => true, "x" => (string)$input->x, "y" => (string)$input->y, "tile" => (string)$input->tile);
					socket_write($players[$j], json_encode($message));
				}
				else if ($input->x && $input->y) {
					$message = array("x" => (string)$input->x, "y" => (string)$input->y);
					socket_write($players[$j], json_encode($message));
				}
			}
		}
    }
}