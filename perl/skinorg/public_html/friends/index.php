<?php

  include "../../include/stdheader.php";

  define( 'TO_TELL', 4 );

?>

<h1>tell your friends...</h1>

<center>
you can use this form to tell your friends about skinflowers.org. enter
your e-mail address and your friend's e-mail address, and click submit ...
</center>

<form method="post" action="tell_friends.php">
 <input type="hidden" name="send" value="yes" />
 <table align="center" cols="2">
  <tr>
   <td>
    your name:<br />
    <input type="text" name="your_name" value="" />
   </td>
   <td>
    your email:<br />
    <input type="text" name="your_email" value="" />
   </td>
  </tr>
  <?php for ( $i=0; $i<TO_TELL; $i++ ) { ?>
  <tr>
   <td>
    friend #<?php echo $i+1 ?>'s name:<br />
    <input type="text" name="friend_name[<?php echo $i ?>]" value="" />
   </td>
   <td>
    friend #<?php echo $i+1 ?>'s email:<br />
    <input type="text" name="friend_email[<?php echo $i ?>]" value="" />
   </td>
  </tr>
  <?php } ?>
  <tr>
   <td colspan="2" align="center">
    <input type="submit" value="tell them!" />
    <input type="reset" value="reset" />
   </td>
  </tr>
 </table>
</form>

<?php

  include "../../include/stdfooter.php";

?>