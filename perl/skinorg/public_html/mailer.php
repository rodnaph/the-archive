<html>
<head>
<title>Mailer</title>

</head>

<body>

<?php

  if ( $sendmail ) {

    while ( $reciever = array_pop($recievers) ) {

      mail( $reciever , 'Skinflowers SiteMail', "$message\n\n\n----------------\n\nDate: date\nEmail: $email\nName: $name\n",
            "From: " . $email . "\nReply-To: " . $name . "\n" );

    }

  }
  else {

?>

<p>Sending an email...</p>

<?php

  }

?>
</body>
</html>