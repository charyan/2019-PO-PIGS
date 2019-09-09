<?php

require_once('inc/config.php');

/**
 * Open database connection
 * @return mysqli
 */
function dbConnect() {
    // Create connection
    $conn = new mysqli(DB_SERVERNAME, DB_USERNAME, DB_PASSWORD, DB_NAME);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
	
	$conn->set_charset("utf8");
	
    //echo "Connected successfully";
    return $conn;
}

/**
 * Get the best players
 * @return array
 */
function getBestPlayers() {
    $conn = dbConnect();
    $data = [];

    try {
        $result = $conn->query(SQL_SELECT_PLAYERS_QUERY);

        while($row = $result->fetch_assoc()) {
            $data[] = [
                'id' => $row['ID_util'],
                'player' => $row['NOM_util'],
                'score' => $row['SCORE_util']
            ];
        }
    } finally {
        $conn->close();
    }
    return $data;
}

/**
 * Insert a player in the database
 * @param $player
 * @param $score
 */
function insertPlayer($player, $score) {
    $conn = dbConnect();

    try {
        // We prepare the query and the parameters to avoid SQL Injections by the users
        $stmt = $conn->prepare(SQL_INSERT_PLAYER_QUERY . "NULL, ?, ?);");
        $stmt->bind_param('si',$player,$score);
        $stmt->execute();
        echo 'New record created successfully !';
    } finally {
        $conn->close();
    }
}