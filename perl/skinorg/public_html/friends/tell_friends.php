<?php

  include "../../include/stdheader.php";

  // the message to send
  $message = <<<EOT

http://www.skinflowers.org

fine awkward rock. free mp3s and ogg audio, rm video
stuff, the free skinmail email service (get yourself
a user\@skinmail.co.uk email account) and randomness
galore at the skinflowers message board. take a look.

EOT;

  // send email to people aslong as info there
  for ( $i=0; $i<sizeof($friend_name); $i++ ) {

    if ( ($name = $friend_name[$i]) && ($email = $friend_email[$i]) ) {
      mail( $email, 'recommending skinflowers.org', $message,
            "From: " . $your_email . "\nReply-To: " . $your_name . "\n"
          );
    }

  }

?>

<center>

 <h1>thanks :D</h1>

 <p>message sent. you can close this window now ...</p>

</center>

<?php

  include "../../include/stdfooter.php";

?>