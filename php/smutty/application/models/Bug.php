<?

class Bug extends Smutty_Model {

	var $hasOne = 'Bug_Status';

	var $hasMany = 'Bug_Comment';

	var $validate = array(
		'name' => STR_REQUIRED,
		'body' => STR_REQUIRED,
		'user_name' => STR_REQUIRED,
		'bug_status_id' => INT_REQUIRED,
		'date_created' => STR_REQUIRED
	);

	function validateUser_name( $value, $data, $session ) {
		if ( !$session->user )
			if ( User::fetchAll(false,array('name:like' => $value)) )
				return 'user name requires a login';
		return false;
	}

}

?>