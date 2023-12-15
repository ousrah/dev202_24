<?php

include("connection.php");

echo("hello");

$collection = $client->dblp->dblp;
$cursor = $collection->find(["year"=>2011]);

// Iterate over the cursor
foreach ($cursor as $doc) {
    echo $doc->title .'<br>';
}

?>