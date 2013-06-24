<?

class TestController extends Smutty_Controller {

	function indexAction() {
		$this->view();
	}

	function fooAction( $data ) {
		$this->dumpVars( $data );
	}

	function dumpVars( $data ) {
		$fields = $data->getFields();
		foreach ( $fields as $field ) {
			$value = $data->object( $field );
			if ( is_array($value) ) {
				echo 'ARRAY: ' . $field . '<br />';
				$this->dumpVars( $data->data($field) );
			}
			else
				echo $field . ': ' . $data->string( $field ) . '<br />';
		}
	}

	function blankAction() {
		$this->set( 'obj', array(1,2,'23') );
		$this->view();
	}

}

?>