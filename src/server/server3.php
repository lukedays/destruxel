<?php

error_reporting(~E_NOTICE);
set_time_limit(0);
 
$address = "10.5.43.167";
$port = 843;
$max_players = 10;
 
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
                    echo "Connected: $address:$port\n";
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
					socket_close($players[$i]);
					unset($players[$i]);
				}
				
				if ($input == "<policy-file-request/>\0") {
					$policy = "<?xml version=\"1.0\"?><cross-domain-policy><site-control permitted-cross-domain-policies=\"all\"/><allow-access-from domain=\"*\" to-ports=\"*\"/></cross-domain-policy>\0";
					socket_write($players[$i], $policy);
				}
			}
		}
    }
}