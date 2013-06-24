<?

class WikiController extends Smutty_Controller {

	function indexAction( $data ) {

		$name = $data->string( 'name' );
		if ( !$name ) $name = 'MainPage';

		if ( $page = $this->getPage($name) ) {
			$this->set( 'page', $page );
			$this->view();
		}

		else $this->redirect(array(
			'action' => 'edit',
			'name' => $name
		));

	}

	function editAction( $data, $session ) {

		$this->showEditForm( $data );

	}

	function getPage( $name ) {

		return Page::find( $name, 'name' );

	}

	function saveAction( $data, $session ) {

		if ( !$session->user )
			$this->showEditForm( $data, array('not logged in') );

		$name = $data->string( 'name' );
		$page = $this->getPage( $name );
		if ( !$page ) {
			$page = new Page();
			$page->name = $name;
		}

		$page->body = $data->string( 'body' );
		$page->date_edited = $data->getDate();
		$page->user_id = $session->user->id;

		if ( $page->save() )
			$this->redirect(array(
				'action' => 'index',
				'name' => $name
			));

		else $this->showEditForm( $data, $page->getErrors() );

	}

	function showEditForm( $data, $errors = array() ) {

		$name = $data->string( 'name' );

		$this->set( 'pageName', $name );
		$this->set( 'page', $this->getPage($name) );
		$this->set( 'errors', $errors );
		$this->set( 'pageBody', $data->string('body') );
		$this->view( 'wiki/edit.tpl' );
		exit();

	}

	function commentAction( $data ) {

		$this->showCommentForm( $data );

	}

	function showCommentForm( $data, $errors = false ) {

		$name = $data->string( 'name' );

		$this->set( 'errors', $errors );
		$this->set( 'page', $this->getPage($name) );
		$this->view( 'wiki/comment.tpl' );

	}

	function saveCommentAction( $data, $session ) {

		$name = $data->string( 'name' );
		$page = $this->getPage( $name );
		$nsplease = trim(strtolower( $data->string('nsplease') ));

		if ( ($page->name != 'MainPage') && ("smutty" == $nsplease) ) {

			$comment = new Comment();
			$comment->page_id = $page->id;
			$comment->name = $data->string( 'user_name' );
			$comment->email = $data->string( 'email' );
			$comment->body = $data->string( 'body' );
			$comment->date_posted = $data->getDate();

			if ( $comment->save() ) {
				mail(
					'rod@pu-gh.com',
					'Smutty Comment Posted',
					'On page: http://smutty.pu-gh.com/wiki/' . urlencode($page->name) . "\n\n"
				);
				$this->redirect(array(
					'action' => 'index',
					'name' => $name
				));
			}

			else $this->showCommentForm(
				$data, $comment->getErrors()
			);

		}

		else $this->showCommentForm(
			$data, array('comments not allowed on this page')
		);

	}

	function errorHandler( $message ) {
		echo "Error: " . $message;
		exit();
	}

}

?>
