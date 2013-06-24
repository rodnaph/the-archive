<?php

/**
 *  this is the base class for all smutty controllers.  it defines
 *  a lot of required functionality and helper methods for classes
 *  that inherit from it.
 *
 */

class Smutty_Controller extends Smutty_Object {

	/** stores data to use for the view */
	private $_viewData = array();

    // current database
    private $db;

	/** current controller */
	private static $currentController = null;

    public function setDatabase( $db ) {
        $this->db = $db;
    }
    
    public function getDatabase() {
        return $this->db;
    }

	/**
	 *  a static method to return the current controller
	 *
	 *  @return Smutty_Controller the current controller
	 *
	 */

	public static function &_getCurrentController() {
		return Smutty_Controller::_setCurrentController( $I_DONT_EXIST );
	}

	/**
	 *  sets and/or returns a controller
	 *
	 *  @param Smutty_Controller $controller optional controller to set
	 *  @return Smutty_Controller the current controller
	 *
	 */

	public static function &_setCurrentController( &$ctlr ) {
		if ( self::$currentController == null )
			self::$currentController = $ctlr;
		return self::$currentController;
	}

	/**
	 *  shows the view file using the specified template class
	 *
	 *  @param String $viewFile path to view file
	 *  @param Smutty_Template $template instance of templace class to use
	 *  @return nothing
	 *
	 */

	private function _view( $viewFile, $template ) {
		foreach ( $this->_viewData as $key => $value )
			$template->assign( $key, $value );
		$template->display( $viewFile );
	}

	/**
	 *  show the view file using the smutty template class
	 *
	 *  @param String $viewFile the file to view
	 *  @return nothing
	 *
	 */

	public function smuttyView( $viewFile ) {
		$this->_view( $viewFile, new Smutty_Template_Smutty() );
	}

	/**
	 *  show the specified file with the standard user
	 *  template class.  if the view file is not specifed
	 *  then it is assumed to be located as "views/controller/action.tpl"
	 *
	 *  @param String $viewFile the file to view
	 *  @return nothing
	 *
	 */

	protected function view( $viewFile = false ) {
		if ( !$viewFile ) {
			$router = Smutty_Router::getInstance();
			$viewFile = $router->getActionName() . '.tpl';
		}
		$this->_view( $viewFile, new Smutty_Template() );
	}

	/**
	 *  sets a variable for use by the template
	 *
	 *  @param String $name name of the variable to set
	 *  @param mixed $value the value to set
	 *  @return nothing
	 *
	 */

	public function set( $name, $value ) {
		$this->_viewData[ $name ] = $value;
	}

	/**
	 *  returns the value of a template var
	 *
	 *  @param String $name var name
	 *  @return String value
	 *
	 */

	public function get( $name ) {
		return isset($this->_viewData[$name])
			? $this->_viewData[$name] : '';
	}

	/**
	 *  this function pushes a value onto the named array,
	 *  if the array doesn't exist then it's created.
	 *
	 *  @param String $name name of array
	 *  @param String $value value to add
	 *  @return nothing
	 *
	 */

	public function push( $name, $value ) {

		$array = $this->get( $name );
		if ( !is_array($array) )
			$array = array();

		array_push( $array, $value );

		$this->set( $name, $array );

	}

	/**
	 *  redirects the user to the application url specified.  the
	 *  url must be absolute from the base of the app.
	 *
	 *  @param String $url the url to redirect to
	 *  @return nothing
	 *
	 */

	protected function redirectUrl( $url ) {

		$base = Smutty_Utils::getBaseUrl();

		header( 'Location: ' . $base . $url );
		Smutty_Main::completeRequest();
		exit();

	}

	/**
	 *  redirects the user to the given url.  the parameter array
	 *  should be a hash of name value pairs.  the names being anything
	 *  set up for the route.
	 *
	 *  @param array $params array of parameters
	 *  @param array $args query string args
	 *  @return nothing
	 *
	 */

	protected function redirect( $params = false, $args = false ) {
		if ( !$params ) {
			$router = Smutty_Router::getInstance();
			$params = array(
				'controller' => $router->getDefaultControllerName(),
				'action' => $router->getDefaultActionName()
			);
		}
		$url = Smutty_Utils::getUrl( $params, $args );
		$base = Smutty_Utils::getBaseUrl();
		$this->redirectUrl( substr($url,strlen($base)) );
	}

	/**
	 *  this function takes the same arguments as the normal
	 *  redirect function, but prints out javascript code
	 *  to do the redirect itself.  this can be useful when
	 *  doing ajax callbacks with forms.
	 *
	 *  it would be nice if i could think of a way to merge these
	 *  two methods and have it "know" which one to do, but that
	 *  seems a bit impossible i think?
	 *
	 *  @param array $params params for the redirect
	 *  @return nothing
	 *
	 */

	protected function redirectJs( $params ) {
		$url = Smutty_Utils::getUrl( $params );
		echo '<script type="text/javascript">self.location.href=\'' . $url . '\';</script>';
		exit();
	}

	/**
	 *  this function is called before an action.  it has no
	 *  implementation here but can be over-rided by sub-classes
	 *  if they want to use it.
	 *
	 *  @param Smutty_Data $data the data object
	 *  @param Smutty_Session $session the session object
	 *  @return nothing
	 *
	 */

	public function actionBefore( $data, $session ) {}

	/**
	 *  adds errors to the current controller
	 *
	 *  @param array $errors array of errors
	 *  @return nothing
	 *
	 */

	public static function addErrors( $errors ) {

		// set errors on current controller
		$curr =& Smutty_Controller::_getCurrentController();
		if ( !isset($curr->_viewData['errors']) || !is_array($curr->_viewData['errors']) )
			$curr->_viewData['errors'] = array();

		$curr->_viewData['errors'] = array_merge(
			$curr->_viewData['errors'],
			$errors
		);

	}

	/**
	 *  adds an error to this controller
	 *
	 *  @param String $message error message
	 *  @return nothing
	 *
	 */

	public function addError( $message ) {

		if ( !isset($this->_viewData['errors']) )
			$this->_viewData['errors'] = array();

		array_push( $this->_viewData['errors'], $message );

	}

}

?>