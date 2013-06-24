<?

define( 'BUG_STATUS_SUBMITTED', 1 );
define( 'BUG_STATUS_OPEN', 2 );
define( 'BUG_STATUS_CLOSED', 3 );

class Bug_Status extends Smutty_Model {

	var $tableName = 'bug_status';

}

?>