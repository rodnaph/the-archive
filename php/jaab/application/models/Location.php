<?

class Location extends Smutty_Model {

	var $tableName = 'tb_locations';

	var $hasOne = 'Country.country';

}

?>