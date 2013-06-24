<?

Smutty_Main::loadClass( 'Smutty_GPG_SignedMessage' );

class Smutty_GPGSignedMessageTest extends Smutty_Test {

	var $message, $msgBody;

	function setUp() {
		$this->msgBody = 'foo=bar&what=ever';
		$this->message = "-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

$this->msgBody

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Some Comment Stuff

ThisIsJustRandomTextThisIsJustRandomTextThisIsJustRandomTextThis
IsJus
-----END PGP SIGNATURE-----";
	}

	function testIsValidHeader() {
		// valid header
		$this->assertTrue(
			Smutty_GPG_SignedMessage::isValidHeader( 'Hash', 'SHA1' )
		);
		// invalid header
		$this->assertFalse(
			Smutty_GPG_SignedMessage::isValidHeader( 'BadBad', 'SHA1' )
		);
	}

	function testCreate() {
		$msg = new Smutty_GPG_SignedMessage( $this->message );
		$this->assertTrue(
			$msg->getMessageBody() == $this->msgBody
		);
	}

}

?>