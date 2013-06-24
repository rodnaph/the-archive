<?php

/**
 *  this class handles dispatching of requests via the correct
 *  controller and action.
 *
 */

class Smutty_Router extends Smutty_Object {

	/** the current controller */
	private $controller;

	/** the current action */
	private $action;

	/** the default controller */
	private $defController;

	/** the default action */
	private $defAction;

    // smutty config
    private $cfg;

    // smutty session
    private $sess;

    private $controllerFactory;

	/**
	 *  contructor.
	 *
	 *  @return nothing
	 *
	 */

	public function __construct( $cfg, $sess, $controllerFactory ) {

        $this->cfg = $cfg;
        $this->sess = $sess;
        $this->controllerFactory = $controllerFactory;

    }

    public function init() {

		$url = explode(  '/', Smutty_Utils::getSmuttyUrl() );
		$this->defController = 'Index';
		$this->defAction = 'index';

		// work out default route args
		if ( $defaultRoute = $this->cfg->get('route.default') ) {
			$defs = explode( '/', $defaultRoute );
			if ( $defs[0] ) $this->defController = ucfirst($defs[0]);
			if ( isset($defs[1]) ) $this->defAction = $defs[1];
		}

		// if we have a controller then we can try and do
		// some routing for it, otherwise we'll just go
		// with the default values.
		if ( Smutty_Router::isValidControllerName($url[0]) ) {

			$this->controller = ucfirst( $url[0] );

			// check controller config
			if ( $default = $this->cfg->get('controllers.'.strtolower($this->controller).'.defaultAction') )
				$this->defAction = $default;

			// try and get an action
			$action = isset($url[1]) ? $url[1] : '';
			$this->processRoute(
				$this->getRouteSpec($this->controller,$action), $url
			);

		}
		else $this->controller = $this->defController;

	}

	/**
	 *  this function process the route definition and sets
	 *  the values accordingly.  the name "action" is
	 *  special and changes the current value.
	 *
	 *  @param String $spec spec string
	 *  @param array $url array of url parts
	 *  @return nothing
	 *
	 */

	private function processRoute( $spec, $url ) {

		$parts = explode( '/', $spec );
		$data =& Smutty_Data::getInstance();
		$size = sizeof( $parts );

		for ( $i=0; $i<$size; $i++ )
			switch ( $parts[$i] ) {
				case 'action':
					// only override if the value is set, otherwise
					// we just want to use the default
					if ( isset($url[$i]) )
						$this->action = $url[$i];
					break;
				default:
					if ( isset($url[$i]) )
						$data->set( $parts[$i], urldecode($url[$i]) );
			}

	}

	/**
	 *  this function searches the application config trying
	 *  to match a route.  if none is found then the default
	 *  route will be returned.  you can specify a controller
	 *  and action to find routes bound to them.
	 *
	 *  @param String $ctl optional controller name
	 *  @param String $act optional action name
	 *  @return String the route url
	 *
	 */

	public static function getRouteSpec( $ctl = false, $act = false ) {

		$cfg = Smutty_Config::getInstance();
		$ctl = strtolower( $ctl );

		// check for action match
		if ( $spec = $cfg->get("route.$ctl.$act") )
			return "controller/action/$spec";

		// check for controller match
		elseif ( $spec = $cfg->get("route.$ctl") )
			return "controller/$spec";

		// nothing matched, return default spec
		else return 'controller/action/id';

	}

	/**
	 *  tests if a given controller name is valid
	 *
	 *  @param String $name the name to test
	 *  @return boolean indicating validity
	 *
	 */

	public static function isValidControllerName( $name ) {
		// remove valid chars, if there's anything left
		// then it's not valid
		$badChars = preg_replace( '/[A-Z]/i', '', $name );
		return ( $name && !$badChars );
	}

	/**
	 *  returns the name of the default controller
	 *
	 *  @return String default controller
	 *
	 */

	public function getDefaultControllerName() {
		return $this->defController;
	}

	/**
	 *  returns the singleton instance of this class
	 *
	 *  @return Smutty_Router the singleton
	 *
	 */

	public static function &getInstance() {
		singlemess();
	}

	/**
	 *  returns the name of the default action
	 *
	 *  @return String default action
	 *
	 */

	public function getDefaultActionName() {
		return $this->defAction;
	}

	/**
	 *  returns the name of the current controller
	 *
	 *  @return String current controller name
	 *
	 */

	public function getControllerName() {
		return $this->controller;
	}

	/**
	 *  returns the current action
	 *
	 *  @return String current action name
	 *
	 */

	public function getActionName() {
		return $this->action
			? $this->action : $this->defAction;
	}

	/**
	 *  sets the current action name
	 *
	 *  @param String $name the action name
	 *  @return nothing
	 *
	 */

	public function setActionName( $name ) {
		$this->action = $name;
	}

	/**
	 *  dispatches the request.
	 *
	 *  @return nothing
	 *
	 */

	public function dispatch() {

        $controller = $this->controllerFactory->getController( $this->controller );

        // @TODO
		$data =& Smutty_Data::getInstance();

		// make sure the method exists
        $name = $this->getActionName();
		$method = $name . 'Action';
		if ( !method_exists($controller,$method) ) {
			throw new Smutty_Error(
                ERR_ACTION_INVALID,
                'ClassSmutty_Controller',
                404,
                Smutty_Error::FATAL
            );
        }

		$this->setActionName( $name );
        $controller->actionBefore( $data, $sess );
        $controller->$method( $data, $sess );

	}

}

?>