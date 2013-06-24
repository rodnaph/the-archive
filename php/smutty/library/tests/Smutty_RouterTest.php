<?

class Smutty_RouterTest extends Smutty_Test {

	function testCreate() {
		$router = Smutty_Router::getInstance();
		$this->assertNotNull( $router );
	}

	function testIsValidControllerName() {
		$this->assertTrue( Smutty_Router::isValidControllerName('Foo') );
		$this->assertFalse( Smutty_Router::isValidControllerName('1Foo') );
	}

}

?>