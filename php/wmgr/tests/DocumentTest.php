<?

require_once 'PHPUnit/Framework.php';

class DocumentTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		global $user;
		$doc = new Document(
			1, 'MyDocument', $user, 123123, 123, 'text/plain'
		);
	}

}

?>