<?php

require_once('inc/config.php');
require_once('model/users.php');

$data = getBestPlayers();

include(VIEW_DIR . 'leaderboard.view.php');