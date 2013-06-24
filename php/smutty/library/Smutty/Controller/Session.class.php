<?php

/**
 *  this class provides basic session handling functions
 *  that the user can extend so they don't have to write
 *  it themselves.
 *
 *  NB:  this does not provide any scaffolding, the user will
 *  need to write their own templates for this to work at
 *  the moment.
 *
 */

class Smutty_Controller_Session extends Smutty_Controller {

	/**
	 *  handles the login action.
	 *
	 *  @param Smutty_Data $data the data object
	 *  @param Smutty_Session $session the session object
	 *  @return nothing
	 *
	 */

	function loginAction( $data, $session ) {

		$router = Smutty_Router::getInstance();

		if ( $session->user )
			if ( $url = $data->string('return_url') )
				$this->redirectUrl( $url );
			else
				$this->redirect(array(
					'controller' => $router->getDefaultControllerName()
				));

		$this->view();

	}

	/**
	 *  handles the logout action.
	 *
	 *  @param Smutty_Data $data the data object
	 *  @param Smutty_Session $session the session object
	 *  @return nothing
	 *
	 */

	function logoutAction( $data, $session ) {

		$router = Smutty_Router::getInstance();

		if ( $session->user )
			session_destroy();

		$this->redirect(array(
			'controller' => $router->getDefaultControllerName()
		));

	}

}

?>