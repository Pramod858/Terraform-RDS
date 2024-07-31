#!/bin/bash

# Install Apache web server and PHP
sudo apt-get update
sudo sudo apt install -y apache2 php libapache2-mod-php
sudo apt install php-mysql -y

# Create HTML directory
sudo mkdir -p /var/www/html

# Set ownership and permissions for the HTML directory
sudo chown -R ubuntu:ubuntu /var/www/html
sudo chmod -R 755 /var/www/html

# sudo rm /var/www/html/index.html

# cat <<EOF > /var/www/html/index.html
cat << 'EOF' | sudo tee /var/www/html/index.html > /dev/null
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Database Connection</title>
    <style>
        /* CSS styles for index.html */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        form {
            margin-top: 50px;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        input[type="text"],
        input[type="password"] {
            padding: 8px;
            margin-bottom: 10px;
            width: 200px;
        }
        button[type="submit"] {
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Database Connection</h1>
    <form action="manage.php" method="post">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br>
        <label for="endpoint">Database Endpoint:</label>
        <input type="text" id="endpoint" name="endpoint" required><br>
        <label for="dbname">Database Name:</label>
        <input type="text" id="dbname" name="dbname" required><br>
        <button type="submit">Connect to Database</button>
    </form>
</body>
</html>
EOF

cat << 'EOF' | sudo tee /var/www/html/manage.php > /dev/null
<?php
session_start();

// Get form data
$_SESSION['username'] = $_POST['username'];
$_SESSION['password'] = $_POST['password'];
$_SESSION['endpoint'] = $_POST['endpoint'];
$_SESSION['dbname'] = $_POST['dbname'];

header("Location: submit-data.php");
exit();
?>
EOF

cat << 'EOF' | sudo tee /var/www/html/submit-data.php > /dev/null
<?php
session_start();

// Check if logout button is clicked
if(isset($_POST['logout'])) {
    // Destroy the session
    session_destroy();
    // Redirect to index.html
    header("Location: index.html");
    exit;
}

// If session is not set, redirect to index.html
if (!isset($_SESSION['username'])) {
    header("Location: index.html");
    exit;
}

// Get database connection parameters from session
$servername = $_SESSION['endpoint'];
$username = $_SESSION['username'];
$password = $_SESSION['password'];
$dbname = $_SESSION['dbname'];

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "Connected to database successfully!<br>";
}

// SQL query to check if the table exists
$table_check_sql = "SHOW TABLES LIKE 'employee'";
$table_result = $conn->query($table_check_sql);

// If the table does not exist, create it
if ($table_result->num_rows == 0) {
    $create_table_sql = "CREATE TABLE employee (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(30) NOT NULL,
        number INT(6) NOT NULL
    )";

    if ($conn->query($create_table_sql) === TRUE) {
        echo "Employee table created successfully!<br>";
    } else {
        echo "Error creating table: " . $conn->error . "<br>";
    }
}

// Handle form submission for adding new data
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['name']) && isset($_POST['number'])) {
    // Get form data
    $name = $_POST['name'];
    $number = $_POST['number'];

    // SQL query to insert data into table
    $insert_sql = "INSERT INTO employee (name, number) VALUES ('$name', '$number')";

    if ($conn->query($insert_sql) === TRUE) {
        echo "New record created successfully<br>";
    } else {
        echo "Error: " . $insert_sql . "<br>" . $conn->error;
    }
}

// Handle record deletion
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['delete_id'])) {
    // Get ID of record to delete
    $id = $_POST['delete_id'];

    // SQL query to delete record
    $delete_sql = "DELETE FROM employee WHERE id = '$id'";

    if ($conn->query($delete_sql) === TRUE) {
        echo "Record deleted successfully<br>";
    } else {
        echo "Error deleting record: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Data to Table</title>
    <style>
        /* CSS styles for submit-data.php */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            text-align: center;
        }
        h1 {
            color: #333;
        }
        table {
            margin: 50px auto;
            border-collapse: collapse;
            width: 80%;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #007bff;
            color: #fff;
        }
        form {
            margin-bottom: 20px;
            margin-top: 20px;
        }
        label {
            display: block;
            margin-bottom: 10px;
        }
        button[type="submit"] {
            padding: 5px 10px;
            background-color: #dc3545;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        input[type="text"],
        input[type="number"] {
            padding: 8px;
            margin-bottom: 10px;
            width: 200px;
        }
        a {
            text-decoration: none;
            color: #007bff;
        }
    </style>
</head>
<body>
    <h1>Add Data to Table</h1>
    <form action="submit-data.php" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required><br>
        <label for="number">Number:</label>
        <input type="number" id="number" name="number" required><br>
        <button type="submit">Add Data</button>
    </form>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Number</th>
            <th>Action</th>
        </tr>
        <?php
        // Display added data
        $select_sql = "SELECT * FROM employee";
        $result = $conn->query($select_sql);

        if ($result->num_rows > 0) {
            while($row = $result->fetch_assoc()) {
                echo "<tr><td>" . $row["id"] . "</td><td>" . $row["name"] . "</td><td>" . $row["number"] . "</td><td><form method='post'><input type='hidden' name='delete_id' value='" . $row["id"] . "'><button type='submit'>Delete</button></form></td></tr>";
            }
        } else {
            echo "<tr><td colspan='4'>No records found</td></tr>";
        }
        ?>
    </table>

    <form action="" method="post">
        <button type="submit" name="logout">Logout</button>
    </form>
</body>
</html>

<?php
$conn->close();
?>
EOF

# Restart Apache to apply changes
sudo service apache2 restart