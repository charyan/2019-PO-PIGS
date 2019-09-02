<?php

require_once('inc/config.php');
require_once(MODEL_DIR . 'users.php');

if(isset($_POST['player']) and isset($_POST['score'])) {
    $player = filter_input(INPUT_POST, 'player', FILTER_SANITIZE_STRING);
    $score = filter_input(INPUT_POST, 'score', FILTER_SANITIZE_NUMBER_INT);

    insertPlayer($player, $score);

} else {
    echo 'ERROR: POST REQUEST MISSING PARAMETERS player AND/OR score';
    echo '<br>';
    var_dump($_POST);
}
