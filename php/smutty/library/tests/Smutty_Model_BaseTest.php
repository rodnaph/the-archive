<?

class Model extends Smutty_Model {
}

class Another_Model extends Smutty_Model {
	var $tableName = 'mytable';
}

class Smutty_Model_BaseTest extends Smutty_Test {

	function testConstructor() {
		$model = new Model();
		$this->assertNotNull( $model );
	}

	function testPopulate() {
		$model = new Model();
		$data = array( a => 1, b => 2 );
		$model->_populate( $data );
		foreach ( $data as $x => $y )
			$this->assertTrue( $data[$x] == $model->$x );
	}

	// when NO $tableName is set
	function testGetTableNotSet() {
		$table = Smutty_Model::_getTable( 'Model' );
		$this->assertTrue( $table == 'models' );
	}

	// when $tableName IS set
	function testGetTableWhenSet() {
		$table = Smutty_Model::_getTable( 'Another_Model' );
		$this->assertTrue( $table == 'mytable' );
	}

	function testGetFieldValueString() {
		$field = new stdclass;
		$field->type = 'varchar';
		$this->assertTrue( Smutty_Model::_getFieldValue($field,'asd') == 'asd' );
	}

	function testGetFieldValueInt() {
		$field = new stdclass;
		$field->type = 'int';
		$this->assertTrue( Smutty_Model::_getFieldValue($field,'1') == 1 );
		$this->assertTrue( Smutty_Model::_getFieldValue($field,'a') == '' );
	}

	function testGetFieldValueDatetime() {
		$field = new stdclass;
		$field->type = 'datetime';
		$date = '2005-08-31';
		$datetime = $date . ' 24:22:12';
		$this->assertTrue( Smutty_Model::_getFieldValue($field,$date) == $date );
		$this->assertTrue( Smutty_Model::_getFieldValue($field,$datetime) == $datetime );
		$this->assertTrue( Smutty_Model::_getFieldValue($field,'invalid-date') == '' );
	}

}

?>