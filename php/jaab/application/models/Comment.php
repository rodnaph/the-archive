<?

class Comment extends Smutty_Model {

	var $tableName = 'tb_comments';

	var $validate = array(
		'subject' => STR_REQUIRED,
		'thread' => INT_REQUIRED,
		'body' => STR_REQUIRED,
		'date' => DATE_REQUIRED
	);

	function repliesProperty() {
		$replies = Comment::fetchAll( false, array(
			'thread' => $this->thread,
			'date:>' => $this->date
		));
		return $replies;
	}

}

?>