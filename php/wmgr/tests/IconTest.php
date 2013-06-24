<?

require_once 'PHPUnit/Framework.php';

class IconTest extends PHPUnit_Framework_TestCase {
	
	public function testConstructor() {
		$icon = new Icon( 1, 'MyIcon', 'icon_file.png' );
	}

}

?>