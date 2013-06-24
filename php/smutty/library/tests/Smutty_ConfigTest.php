<?

class Smutty_ConfigTest extends Smutty_Test {

	function testLoadLine() {
		$config = new Smutty_Config();
		$config->loadLine( 'my.var = something' );
		$this->assertTrue( $config->get('my.var') == 'something' );
	}

	function testLoadComment() {
		$config = new Smutty_Config();
		$config->loadLine( '#test.var = comment' );
		$this->assertFalse( $config->get('test.var') == 'comment' );
	}

	function testMatchWildcard() {
		$config = new Smutty_Config();
		$config->loadLine( 'foo.bar = 1' );
		$config->loadLine( 'foo.again = 2' );
		$matches = $config->get( 'foo.*' );
		$this->assertTrue( sizeof($matches) == 2 );
	}

	function testLoadConfig() {
		$config = new Smutty_Config();
		$config->loadConfig( 'library/tests/data/app-test.cfg' );
		$this->assertTrue( $config->get('test.var') == 'hello' );
	}

	function testConfigWildcard() {
		$config = new Smutty_Config();
		$config->loadLine( 'test.bar* = world' );
		$this->assertTrue( $config->get('test.bar') == 'world' );
		$this->assertTrue( $config->get('test.barNone') == 'world' );
	}

	function testNoMatch() {
		$config = new Smutty_Config();
		$this->assertTrue( $config->get('doesnt.exist') == '' );
	}

}

?>