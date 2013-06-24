<?

class Smutty_DataTest extends Smutty_Test {

	function setUp() {
		// set up the post data
		$_POST = array(
			foo => bar,
			bar => foo,
			int => 123,
			string => 'mystr',
			hash => array (
				foo => 'bar'
			),
			object => new stdclass()
		);
		$_SERVER['REQUEST_METHOD'] = 'POST';
	}

	function testPostData() {
		$data = new Smutty_Data();
		foreach ( $_POST as $key => $value )
			$this->assertTrue( $data->string($key) == $value );
	}

	function testInt() {
		$data = new Smutty_Data();
		$this->assertTrue( $data->int('int') == 123 );
		$this->assertTrue( $data->int('string') == '' );
	}

	function testString() {
		$data = new Smutty_Data();
		$this->assertTrue( $data->string('foo') == 'bar' );
	}

	function testData() {
		$data = new Smutty_Data();
		$hash = $data->data( 'hash' );
		$this->assertTrue( $hash->string('foo') == 'bar' );
	}

	function testObject() {
		$data = new Smutty_Data();
		$this->assertTrue( $data->object('object') == new stdclass() );
	}

	function testProcessPostData() {
		$post = 'more=less';
		Smutty_Data::processPostData( $post );
		$data = new Smutty_Data();
		$this->assertTrue( $data->string('more') == 'less' );
	}

	function testGetPostData() {
		$field = rand();
		$_POST = array( foo => $field );
		$data = Smutty_Data::getPostData();
		$this->assertTrue( $data->string('foo') == $field );
	}

	function testGetGetData() {
		$field = rand();
		$_GET = array( foo => $field );
		$data = Smutty_Data::getGetData();
		$this->assertTrue( $data->string('foo') == $field );
	}

	function testGetServerData() {
		$field = rand();
		$_SERVER = array( foo => $field );
		$data = Smutty_Data::getServerData();
		$this->assertTrue( $data->string('foo') == $field );
	}

	function testSet() {
		$field = rand();
		$data = new Smutty_Data();
		$data->set( 'foo', $field );
		$this->assertTrue( $data->string('foo') == $field );
	}

	function testGetInt() {
		$this->assertTrue( Smutty_Data::getInt('123') == 123 );
		$this->assertTrue( Smutty_Data::getInt('abc') == '' );
	}

	function testIntPad() {
		$data = new Smutty_Data();
		$data->set( 'int1', '2' );
		$data->set( 'int2', '10' );
		$this->assertTrue( $data->intPad('int1') == '02' );
		$this->assertTrue( $data->intPad('int2') == '10' );
	}

	function testGetFields() {
		$_POST = array(
			foo => 'bar',
			bar => 'foo'
		);
		$data = new Smutty_Data();
		$fields = $data->getFields();
		$this->assertTrue( sizeof($fields) == sizeof($_POST) );
		foreach ( $_POST as $key => $value )
			$this->assertTrue( $data->string($key) == $_POST[$key] );
	}

	function testGetDate() {
		$data = new Smutty_Data();
		$this->assertNotNull( $data->getDate() );
	}

	function testExists() {
		$_POST = array(
			foo => 'bar'
		);
		$data = new Smutty_Data();
		$this->assertTrue( $data->exists('foo') );
		$this->assertFalse( $data->exists('bar') );
	}

	function testIsSigned() {
		// TODO - need to work out how to
		// redirect from php://input
	}

	function testIsVerified() {
		// TODO - see above
	}

}

?>