<?php

/**
 *  this is a controller for the built-in Smutty functionality
 *  like the model manager, clearing cache, etc...
 *
 */

class Smutty_Controller_Smutty extends Smutty_Controller {

	/**
	 *  index action, shows the home page
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function indexAction( $data, &$session ) {

		$this->smuttyView( 'smutty/index.tpl' );

	}

	/**
	 *  shows the tests that have been created for this
	 *  application.
	 *
	 *  @return nothing
	 *
	 */

	function testsAction() {

		$tests = array();
		$d = opendir( 'application/tests' );

		while ( $file = readdir($d) )
			if ( preg_match('/(.*).php$/',$file,$matches) )
				$tests[] = $matches[1];

		$this->set( 'tests', $tests );
		$this->smuttyView( 'smutty/tests.tpl' 	);

	}

	/**
	 *  runs a specific test case
	 *
	 *  @param Smutty_Data $data the request data
	 *  @return nothing
	 *
	 */

	function testRunAction( $data ) {

		$name = $data->string( 'file' );
		$name = preg_replace( '/^(\w*).*/', '$1', $name );
		$file = "application/tests/$name.php";
		$test = null;

		if ( file_exists($file) ) {
			require $file;
			$test = new $name();
			$reporter = new Smutty_Test_Reporter();
			$test->run( $reporter );
			$this->set( 'results', $reporter->getResults() );
		}

		$this->set( 'testCase', $name );
		$this->smuttyView( 'smutty/testRun.tpl' );

	}

	/**
	 *  checks if the user is allowed to access to this section
	 *
	 *  @param Smutty_Data $data the data object
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function actionBefore( $data, $session ) {

		// only check login for some pages
		$router = Smutty_Router::getInstance();
		$action = $router->getActionName();
		$toCheck = array( 'login', 'logout', 'rss', 'resource' );
		if ( in_array($action,$toCheck) )
			return;

		$cfg = Smutty_Config::getInstance();

		// first check the manager is enabled
		if ( $cfg->get('manager') != 'true' )
			Smutty_Error::fatal( 'smutty manager not enabled', 'SmuttyManager' );

		// is anonymous access enabled?
		if ( $cfg->get('manager.allowAnonymous') == 'true' )
			return true;

		// if we have a user check if they are allowed
		// to access this section
		elseif ( $session->user ) {
			if ( $userString = $cfg->get('manager.users') ) {
				$users = explode( ',', $userString );
				foreach ( $users as $user )
					if ( trim($user) == $session->user->name )
						return true;
				Smutty_Error::fatal( 'your account has not been allowed access', 'SmuttyManager' );
			}
		}

		// no anon, require login
		else $this->redirect(array(
			'action' => 'login'
		));

	}

	/**
	 *  deletes a model
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function modelDeleteAction( $data, &$session ) {

		$modelClass = $data->string( 'smutty_modelClass' );
		$modelId = $data->int( 'smutty_modelId' );
		$confirm = $data->string( 'confirmCode' );

		if ( $confirm && ($confirm == $session->confirmCode) ) {
			$model = Smutty_Model::find( $modelClass, $modelId );
			$model->delete();
			$this->redirect(array(
				'action' => 'modelBrowse',
				'smutty_modelClass' => $modelClass
			));
		}

		else {
			$session->confirmCode = rand();
			$this->set( 'modelClass', $modelClass );
			$this->set( 'modelId', $modelId );
			$this->set( 'confirmCode', $session->confirmCode );
			$this->smuttyView( 'smutty/modelDelete.tpl' );
		}

	}

	/**
	 *  displays the current models
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function modelsAction( $data, &$session ) {

		// load valid models
		$models = array();
		$dir = opendir( 'application/models/' );
		while ( $file = readdir($dir) )
			if ( preg_match('/(.*)\.php/',$file,$matches) ) {
				$modelClass = $matches[ 1 ];
				$models[ $modelClass ] = Smutty_Model::getTotal( $modelClass );
				//array_push( $models, $matches[1] );
			}

		ksort( $models );

		$this->set( 'models', $models );
		$this->smuttyView( 'smutty/models.tpl' );

	}

	/**
	 *  displays a listing of the models records (paged)
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function modelBrowseAction( $data, &$session ) {

		$modelClass = $data->string( 'smutty_modelClass' );
		$models = false;
		$fields = false;
		$total = Smutty_Model::getTotal( $modelClass );

		// order
		$order = "id:asc";
		if ( $field = $data->string('order') ) {
			$order = $field;
			if ( $direction = $data->string('dir') )
				$order = "$order:$direction";
		}

		// paging
		$perPage = 10;
		$limit = $perPage + 1;
		$start = $data->int( 'start' );
		$limit = $start ? "$start:$limit" : $limit;
		$more = false;
		$less = ( $start > 0 );
		$this->set( 'perPage', $perPage );
		$this->set( 'start', $start );
		$this->set( 'total', $total );

		$models = Smutty_Model::fetchAll( $modelClass, $order, false, $limit );
		$fields = Smutty_Model::getFields( $modelClass );

		if ( sizeof($models) > $perPage ) {
			array_pop( $models );
			$more = true;
		}

		$this->set( 'more', $more );
		$this->set( 'less', $less );
		$this->set( 'modelClass', $modelClass );
		$this->set( 'models', $models );
		$this->set( 'fields', $fields );
		$this->set( 'relatedModels', $this->getRelatedModels($modelClass) );
		$this->smuttyView( 'smutty/modelBrowse.tpl' );

	}

	/**
	 *  displays a specific record for a model
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function modelShowAction( $data, &$session ) {

		$modelClass = $data->string( 'smutty_modelClass' );
		$modelId = $data->int( 'smutty_modelId' );
		$model = false;
		$fields = false;

		$model = Smutty_Model::find( $modelClass, $modelId );
		$fields = Smutty_Model::getFields( $modelClass );

		$this->set( 'modelClass', $modelClass );
		$this->set( 'modelId', $modelId );
		$this->set( 'model', $model );
		$this->set( 'fields', $fields );
		$this->set( 'relatedModels', $this->getRelatedModels($modelClass) );
		$this->smuttyView( 'smutty/modelShow.tpl' );
		
	}

	/**
	 *  shows the page for editing/creating a new model
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function modelEditAction( $data, &$session ) {

		$modelClass = $data->string( 'smutty_modelClass' );
		$modelId = $data->int( 'smutty_modelId' );
		$model = $data->object( 'model' ); // maybe passed through from save?
		$fields = false;

		if ( !$model )
			$model = Smutty_Model::find( $modelClass, $modelId );
		$fields = Smutty_Model::getFields( $modelClass );

		if ( !$model ) $model = new $modelClass();

		$this->set( 'model', $model );
		$this->set( 'fields', $fields );
		$this->set( 'modelClass', $modelClass );
		$this->set( 'modelId', $modelId );
		$this->smuttyView( 'smutty/modelEdit.tpl' );

	}

	/**
	 *  saves changes to a model
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function modelSaveAction( &$data, &$session ) {

		$modelClass = $data->string( 'smutty_modelClass' );
		$modelId = $data->string( 'smutty_modelId' );

		$model = new $modelClass();
		$model->fill();
		$model->id = $modelId;

		if ( $model->save() )
			$this->redirect(array(
				'action' => 'modelShow',
				'smutty_modelClass' => $modelClass,
				'smutty_modelId' => $model->id
			));

		else {
			$data->set( 'model', $model );
			$this->action( 'modelEdit' );
		}

	}

	/**
	 *  fetches an array of model names which are
	 *  "related" to the specifed model class
	 *
	 *  @param String $modelClass class related to
	 *  @return array related model names
	 *
	 */

	function getRelatedModels( $modelClass ) {

		$model = new $modelClass();
		$related = array();
		$added = array();

		// check out the has strings
		$hasStrings = explode( ' ', $model->hasOne . ' ' . $model->hasMany . ' ' . $model->hasRelation );
		foreach ( $hasStrings as $hasString ) {
			$parts = explode( '.', $hasString );
			if ( ($class = $parts[0]) && !isset($added[strtolower($class)]) ) {
				$related[] = $class;
				$added[ strtolower($class) ] = 1;
			}
		}

		// now look for fields that could match
		$fields = Smutty_Model::getFields( $modelClass );
		foreach ( $fields as $field )
			if ( substr($field->name,-3) == '_id' ) {
				$class = ucfirst(substr( $field->name, 0, strlen($field->name)-3 ));
				if ( class_exists($class) && !isset($added[strtolower($class)]) ) {
					$related[] = $class;
					$added[ strtolower($class) ] = 1;
				}
			}

		return $related;

	}

	/**
	 *  displays one of the smutty resources
	 *
	 *  @param Smutty_Data $data request data
	 *  @return nothing
	 *
	 */

	function resourceAction( $data ) {

		$path = 'library/public/' .
			$data->string('folder') . '/' .
			$data->string('file');

		if ( file_exists($path) )
			Smutty_Resource::output( $path, true );

	}

	/**
	 *  this method provides built-in syndication for all models
	 *
	 *  @param Smutty_Data $data request data
	 *  @return nothing
	 *
	 */

	function rssAction( $data ) {

		$class = $data->string( 'model' );
		$class = ucfirst( $class );

		if ( class_exists($class) ) {

			$model = new $class();
			if ( !$model->rss )
				Smutty_Error::fatal( 'rss not valid for model', 'SmuttySyndication' );

			$order = w( $model->rss, 'order', false );
			$models = Smutty_Model::fetchAll( $class, $order, false, 10 );

			$tpl = new Smutty_Template_Smutty();
			$tpl->assign( 'modelName', $class );
			$tpl->assign( 'model', $model );
			$tpl->assign( 'models', $models );

			$tpl->display( 'syndication/rss-2.0.tpl' );

		}

	}

	/**
	 *  draws the login page for the user depending on the
	 *  current authentication method set up
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function loginAction( $data, $session ) {

		if ( $session->user )
			$this->redirect(array(
				'action' => 'index'
			));

		$cfg = Smutty_Config::getInstance();
		$type = $cfg->get( 'auth.type' );
		$file = "smutty/login-$type.tpl";

		switch ( $type ) {
			case 'standard':
				$name = $cfg->get('auth.standard.nameParam');
				$pass = $cfg->get('auth.standard.passParam');
				if ( !$name ) $name = 'username';
				if ( !$pass ) $pass = 'password';
				$this->set( 'nameParam', $name );
				$this->set( 'passParam', $pass );
				break;
			default:
				Smutty_Error::fatal( 'known auth type', 'ClassSmutty_Config' );
		}
		$this->smuttyView( $file );

	}

	/**
	 *  logs the user out
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function logoutAction( $data, &$session ) {

		if ( $session->user )
			$session->user->logout();

		$this->redirect(array(
			'action' => 'login'
		));

	}

	/**
	 *  clears the smarty cache
	 *
	 *  @param Smutty_Data $data request data
	 *  @param Smutty_Session $session current session
	 *  @return nothing
	 *
	 */

	function clearCacheAction( $data, $session ) {

		system( 'rm -rf library/smarty/cache/application/*' );
		system( 'rm -f library/smarty/cache/smutty/*' );
		echo 'Cache Cleared';

	}

}

?>