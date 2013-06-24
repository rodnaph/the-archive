<?

class Comment extends Smutty_Model {

	var $validate = array(
		'page_id' => INT_REQUIRED,
		'name' => STR_REQUIRED,
		'body' => STR_REQUIRED,
		'date_posted' => STR_REQUIRED
	);

}

?>