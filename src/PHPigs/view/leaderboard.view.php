<?php

?>

<!doctype html>
<html lang="fr">
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="css/normalize.css">
    <link rel="stylesheet" href="css/main.css">
    <title>PIGS LEADERBOARD</title>
</head>
<body>
    <header>CLASSEMENT</header>
    <table cellspacing="0" cellpadding="0">
        <?php $i = 1; foreach($data as $record): ?>
        <tr class="row">
            <td class="col-pos"><?=$i ?>.</td>
            <td class="col-name"><?=$record['player'] ?></td>
            <td class="col-score"><?=$record['score'] ?></td>
        </tr>
        <?php $i++; endforeach; ?>
    </table>
</body>
</html>
