<?

require_once 'PHPUnit/Framework.php';

class PageHistoryTest extends PHPUnit_Framework_TestCase {

	public function testConstructor() {
		global $user;
		$id = 1;
		$body = 'test body';
		$date = time();
		$hist = new PageHistory( $id, $body, $user, $date );
		$this->assertTrue( $hist ? true : false );
		$this->assertEquals( $hist->id, $id );
		$this->assertEquals( $hist->body, $body );
		$this->assertEquals( $hist->user, $user );
		$this->assertEquals( $hist->dateEdited, $date );
	}

}

?>