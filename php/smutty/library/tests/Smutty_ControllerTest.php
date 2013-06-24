<?

class Smutty_ControllerTest extends Smutty_Test {

	function testGetSetController() {
		Smutty_Controller::setCurrentController( new Smutty_Controller() );
		$a =& Smutty_Controller::getCurrentController();
		$b =& Smutty_Controller::getCurrentController();
		$a->action = 'asd';
		$this->assertTrue( $b->action == 'asd' );
	}

	function testGetAndSet() {
		$c = new Smutty_Controller();
		$c->set( 'a', 'b' );
		$this->assertTrue( $c->get('a') == 'b' );
	}

}

?>