<?

class Bug_Comment extends Smutty_Model {

	var $validate = array(
		'body' => STR_REQUIRED,
		'user_name' => STR_REQUIRED,
		'date_posted' => STR_REQUIRED,
		'bug_id' => INT_REQUIRED
	);

	function validateUser_name( $value, $data, $session ) {
		if ( !$session->user )
			if ( User::fetchAll(false,array('name:like' => $value)) )
				return 'user name requires a login';
		return false;
	}

}

?>