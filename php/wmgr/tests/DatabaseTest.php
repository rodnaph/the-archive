<?

require_once 'PHPUnit/Framework.php';

class DatabaseTest extends PHPUnit_Framework_TestCase {

	public function testQuery() {
		global $db;
		$sql = " select * from users ";
		$this->assertTrue( $db->query($sql) ? true : false );
	}

	public function testUpdate() {
		global $db;
		$sql = " update users
			set name = ''
			where 0 = 1 ";
		$this->assertTrue( $db->update($sql) ? true : false );
	}

	public function testGetError() {
		global $db;
		$sql = " bad sql ";
		$db->query( $sql );
		$this->assertNotNull( $db->getError() );
	}

	public function testGetInsertID() {
		global $db;
		//$this->markTestIncomplete( 'TODO' );
	}

	public function testGetUnixTimeStamp() {
		global $db;
		$dateFunction = $db->getDateFunction();
		$timestamp = $db->getUnixTimeStamp( $dateFunction );
		$sql = " select $timestamp from users ";
		$this->assertTrue( $db->query($sql) ? true : false );
	}

	public function testGetDateFunction() {
		global $db;
		$dateFunction = $db->getDateFunction();
		$sql = " select $dateFunction from users ";
		$res = $db->query( $sql );
		$this->assertTrue( $res ? true : false );
	}

	public function testQuote() {
		global $db;
		$str = $db->quote( "a'a" );
		$sql = " select '$str' as myfield ";
		$res = $db->query( $sql );
		$this->assertTrue( $res ? true : false );
	}

	public function testQueryResults() {
		global $db;
		$sql = " select 1 union select 2 ";
		$res = $db->query( $sql );
		$this->assertTrue( $res ? true : false );
		$row = $res->fetch();
		$this->assertTrue( $row ? true : false );
	}

}

?>