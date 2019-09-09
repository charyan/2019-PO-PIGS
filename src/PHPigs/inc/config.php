<?php

// This project contains a functionning input system with sanitized inputs to avoid XSS and SQL Injections
// The LEADERBOARD is working, the number of players displayed can be modified with the\
//      NUM_PLAYERS_LEADERBOARD const variable

const HOME_DIR      = __DIR__ . '/../';
const MODEL_DIR     = HOME_DIR . 'model/';
const VIEW_DIR      = HOME_DIR . 'view/';
const MEDIA_DIR     = HOME_DIR . 'media/';

const DB_SERVERNAME = 'localhost';
const DB_USERNAME   = 'admin';
const DB_PASSWORD   = 'Admlocal1';
const DB_NAME       = 'pigs';
const DB_TABLE      = 'utilisateur';

// Number of player records displayed on the leaderboard
const NUM_PLAYERS_LEADERBOARD = 20;

const SQL_SELECT_PLAYERS_QUERY = "SELECT ID_util, NOM_util, SCORE_util FROM " . DB_TABLE . " ORDER BY SCORE_util DESC LIMIT " . NUM_PLAYERS_LEADERBOARD;
const SQL_INSERT_PLAYER_QUERY = "INSERT INTO " . DB_TABLE . " (ID_util, NOM_util, SCORE_util) VALUES (";
