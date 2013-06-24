<?

class Page extends Smutty_Model {

	var $hasMany = 'Comment';

	var $validate = array(
		'name' => STR_REQUIRED,
		'body' => STR_REQUIRED,
		'user_id' => INT_REQUIRED,
		'date_edited' => STR_REQUIRED
	);

	var $rss = array(
		'id' => 'name',
		'url' => array(
			'controller' => 'wiki',
			'action' => 'index',
			'name' => 'name'
		),
		'order' => 'date_edited:desc'
	);

}

?>