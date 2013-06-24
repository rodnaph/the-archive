<?

class Entry extends Smutty_Model {

	var $tableName = 'tb_entries';

	var $hasOne = 'User.user Location.location';

	var $validate = array(
		'subject' => STR_REQUIRED,
		'body' => STR_REQUIRED,
		'location' => INT_REQUIRED,
		'user' => INT_REQUIRED,
		'date' => DATE_REQUIRED
	);

	function commentsProperty() {
		return Comment::fetchAll( false, array(
			thread => $this->id
		));
	}

}

?>