<?

Smutty_Main::loadClass( 'Bug_Status' );

class BugController extends Smutty_Controller {

	var $scaffold = true;

	function indexAction() {
		$this->set( 'bugs', Bug::fetchAll(
			'date_created:desc',
			array( 'bug_status_id:!=' => BUG_STATUS_CLOSED )
		));
		$this->view();
	}

	function reportAction() {
		$this->view();
	}

	function reportBugAction( $data, $session ) {

		$bug = new Bug();
		$bug->fill();
		$bug->bug_status_id = 1;
		if ( $session->user )
			$bug->user_name = $session->user->name;

		if ( $bug->save() ) {
			if ( !$sesion->user )
				$this->sendMail(
					'Smutty Bug Posted: #' . $bug->id,
					'http://smutty.pu-gh.com/bug/show/' . $bug->id
				);
			$this->redirectJs(array(
				action => 'show',
				id => $bug->id
			));
		}
		else $this->view( 'bug/errors.tpl' );

	}

	function sendMail( $subject, $message ) {
		mail(
			'rod@pu-gh.com',
			$subject,
			$message,
			'From: smutty@smutty.pu-gh.com'
		);
	}

	function showAction( $data ) {

		$id = $data->int( 'id' );

		$this->set( 'bug', Bug::find($id) );
		$this->set( 'bugStatus', Bug_Status::fetchAll() );
		$this->view( 'show.tpl' );

	}

	function commentAction( $data, $session ) {

		$id = $data->int( 'id' );
		$bug = Bug::find( $id );
		$bug->bug_status_id = $data->int( 'bug_status_id' );

		$comment = new Bug_Comment();
		$comment->fill();
		$comment->bug_id = $bug->id;

		if ( $session->user )
			$comment->user_name = $session->user->name;

		$trans = new Smutty_Model_Transaction();
		$trans->add( $comment );
		$trans->add( $bug );

		if ( $trans->save() ) {
			if ( !$session->user )
				$this->sendMail(
					'Smutty Bug Updated: #' . $bug->id,
					'http://smutty.pu-gh.com/bug/show/' . $bug->id
				);
			$this->redirectJs(array(
				action => 'show',
				id => $bug->id
			));
		}
		else {
			$this->set( 'errors', $trans->getErrors() );
			$this->view( 'errors.tpl' );
		}

	}

}

?>