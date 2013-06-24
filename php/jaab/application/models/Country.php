<?

class Country extends Smutty_Model {

	var $tableName = 'tb_countries';

	var $hasOne = 'Continent.continent';

	function locationsProperty() {
		return Location::fetchAll( 'name', array(
			'country' => $this->id
		));
	}

}

?>