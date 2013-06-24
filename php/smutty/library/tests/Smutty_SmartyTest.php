<?

Smutty_Main::loadClass( 'Smutty_Smarty' );

class Smutty_SmartyTest extends Smutty_Test {

	function setUp() {
		if ( $this->smarty == null )
			$this->smarty = new Smutty_Template();
	}

	function testGetFieldName() {
		$this->assertTrue( Smutty_Smarty::getFieldName('foo.bar') == 'foo[bar]' );
		$this->assertTrue( Smutty_Smarty::getFieldName('foo_bar') == 'foo_bar' );
	}

	function testHtmlElement() {
		$elem = Smutty_Smarty::htmlElement( 'input', array(
			type => 'text',
			name => 'foo'
		), $this->smarty );
		$this->assertRegExps( $elem, array(
			'/<input/', '/type="text"/', '/name="foo"/'
		));
	}

	function testHidden() {
		$options = array(
			name => 'foo',
			value => 'bar'
		);
		$this->assertRegExps(
			Smutty_Smarty::hidden( $options, $this->smarty ),
			array_merge(
				array('/<input/'),
				$this->getRegExps($options)
			)
		);
	}

	function testButton() {
		$options = array(
			text => 'foo',
			'class' => 'bar',
			id => 'foobar'
		);
		$this->assertRegExps(
			Smutty_Smarty::button( $options, $this->smarty ),
			array_merge(
				array('/<input/','/value="foo"/'),
				$this->getRegExps(array_slice($options,1)) // skip "text" as it changes to "value"
			)
		);
	}

	function testField() {
		$options = array(
			label => 'label',
			labelClass => 'labelClass',
			name => 'qwe',
			value => 'foo',
			'class' => 'bar',
			id => 'rty',
			type => 'text',
			maxlength => 99
		);
		$this->assertRegExps(
			Smutty_Smarty::field( $options, $this->smarty ),
			array_merge(
				array('/<input/','/<label/','/for="qwe"/','/class="labelClass"/'),
				$this->getRegExps(array_slice($options,2))
			)
		);
	}

	function testLabel() {
		$options = array(
			text => 'fo&o',
			'for' => 'qwe',
			'class' => 'rty'
		);
		$this->assertRegExps(
			Smutty_Smarty::label( $options, $this->smarty ),
			array_merge(
				array( '/<label/','/<\/label>/', '/>fo&amp;o</' ),
				$this->getRegExps(array_slice($options,1))
			)
		);
	}

	function testPassword() {
		$this->assertRegExps(
			Smutty_Smarty::password( $options, $this->smarty ),
			array( '/type="password"/', '/<input/' )
		);
	}

	function testSubmit() {
		$options = array(
			text => 'foo',
			type => 'submit'
		);
		$this->assertRegExps(
			Smutty_Smarty::submit( $options, $this->smarty ),
			array_merge(
				array( '/<input/', '/value="foo"/' ),
				$this->getRegExps(array_slice($options,1))
			)
		);
	}

	function testTextarea() {
		$options = array(
			label => 'foo',
			labelClass => 'bar',
			value => 'fo&o',
			name => 'foo',
			'class' => 'bar',
			id => 'fb'
		);
		$this->assertRegExps(
			Smutty_Smarty::textarea( $options, $this->smarty ),
			array_merge(
				array( '/<textarea/', '/<\/textarea>/', '/>fo&amp;o</' ),
				$this->getRegExps(array_slice($options,3))
			)
		);
	}

	function getRegExps( $options ) {
		$array = array();
		foreach ( $options as $key => $value )
			$array[] = "/$key=\"$value\"/";
		return $array;
	}

}

?>