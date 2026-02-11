<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "speedfast_db";

// Connect to MySQL (no DB yet)
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Read SQL file
$sql = file_get_contents("speedfast_db.sql");

// Execute SQL
if ($conn->multi_query($sql)) {
    echo "Database and tables created successfully!";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
