<?

class CodeController extends Smutty_Controller {

	private $classBase = 'library/Smutty';

	function browseAction( $data ) {

		$type = $data->string( 'type' );

		switch ( $type ) {
			case 'classes':
				$this->loadClasses();
				break;
			case 'plugins':
				$this->loadPlugins();
				break;
			default:
				$this->loadClasses();
				$this->loadPlugins();
		}

		// sort classes
		if ( $classes = $this->get('classes') ) {
			sort( $classes );
			$this->set( 'classes', $classes );
		}

		$this->view();

	}

	function loadClasses( $dir = false ) {

		if ( !$dir ) $dir = $this->classBase;

		$d = opendir( $dir );

		while ( $file = readdir($d) ) {
			if ( !preg_match('/^\./',$file) ) {
				$path = "$dir/$file";
				if ( is_dir($path) )
					$this->loadClasses( $path );
				else {
					$class = substr( $path, strlen($this->classBase) + 1 );
					$class = 'Smutty_' . preg_replace( '/\//', '_', $class );
					$class = preg_replace( '/\.class\.php/', '', $class );
					$this->push( 'classes', $class );
				}
			}
		}

		closedir( $d );

	}

	function loadPlugins() {

		$d = opendir( 'library/smarty/plugins' );

		while ( $file = readdir($d) )
			if ( preg_match('/\.php$/',$file) ) {
				$type = preg_replace( '/^(\w+)\..*/', '$1', $file );
				$name = preg_replace( '/^\w+\.(\w+)\..*/', '$1', $file );
				$display = $file;
				$this->push( 'plugins', array($type,$name,$display) );
			}

		closedir( $d );

	}

	function viewPluginAction( $data ) {

		$type = $data->string( 'type' );
		$name = $data->string( 'name' );
		$path = 'library/smarty/plugins/' . $type . '.' . $name . '.php';

		$this->showFile( "$type.$name", $path );

	}

	function viewClassAction( $data ) {

		$class = $data->string('name');
		$path = 'library/' . preg_replace('/_/', '/',$class) . '.class.php';

		if ( preg_replace('/([A-Za-z_])/','',$class) || !file_exists($path) )
			die( 'error' );

		$this->showFile( $class, $path );

	}

	function showFile( $name, $path ) {

		$this->set( 'name', $name );
		$this->set( 'lines', file($path) );
		$this->view( 'code/file.tpl' );

	}

}

?>