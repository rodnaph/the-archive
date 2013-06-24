<?php

// required data types
define( 'STR_REQUIRED', 1 );
define( 'INT_REQUIRED', 2 );
define( 'DATE_REQUIRED', 3 );
// optional data types
define( 'INT_OPTIONAL', 4 );
define( 'STR_OPTIONAL', 5 );
define( 'DATE_OPTIONAL', 6 );

/**
 *  this is the base class for all Smutty models.  it provides
 *  many methods and utilities which (hopefully) make using
 *  models the joy it should be.
 *
 */

class Smutty_Model extends Smutty_Object {

	/** model data */
	private $_data;

	/** cache for properties */
	private $_propertyCache;

	/** the name of this models table, defaults to false so it will be
		worked out dynamically, but you can set it to the actual table
		name if needed. */
	public $tableName = false;

	/** allows specifying dependent models by their name.  the related
		field is assumed to be {model}_id, but you can specify it if
		you need to by using dot notation like so:
			var $hasOne = 'User.myuservar';
		multiple entries should be space seperated. */
	public $hasMany = '';
	public $hasOne = '';
	public $hasRelation = '';

	/** this property should be used to specify how data is to
		be validated.  it should be a hash of the name of the
		property and then a constant indicating it's type and
		it's "requiredness" */
	public $validate = array();

	/** keeps track of changes to the model so we know whether we
		need to go expend the overhead of actually validating */
	private $_needsValidating;

	/** enable rss output for this model */
	public $rss = '';

	/** any errors on this model */
	private $errors = array();

	/**
	 *  constructor
	 *
	 *  @return nothing
	 *
	 */

	public function __construct() {
		$this->_data = new stdclass();
		$this->_propertyCache = array();
		$this->errors = array();
		$this->_needsValidating = true;
	}

	/**
	 *  this method tries to automatically fill a
	 *  model with data that has been passed to
	 *  the application.
	 *
	 *  @return nothing
	 *
	 */

	public function fill() {

		$class = get_class( $this );
		$db = Smutty_Database::getInstance();
		$data = Smutty_Data::getInstance();
		$session = Smutty_Session::getInstance();
		$hash = $data->data( strtolower($class) );
		$fields = $this->getFields();

		foreach ( $fields as $field ) {

			$name = $field->name;

			// try and fill field with data
			if ( $value = $hash->string($field->name) )
				$this->$name = $value;

			// maybe it's a date field?
			elseif ( preg_match('/^date/',$field->type) ) {
				// see if we have special smutty date fields
				if ( $data->exists($field->name . '_year') ) {
					$year = $data->string( $field->name . '_year' );
					$month = $data->string( $field->name . '_month' );
					$day = $data->string( $field->name . '_day' );
					// only set field if we have all the data
					if ( $year && $month && $day )
						$this->$name = date(
							$db->getDateFormat(),
							strtotime("$year-$month-$day")
						);
				}
				else $this->$name = $data->getDate();
			}

			// otherwise a user field?
			elseif ( $session->user && ($field->name == 'user_id') )
				$this->$name = $session->user->id;

		}

	}

	/**
	 *  populates the model with data from the array
	 *
	 *  @param hash $data a hash of name/value pairs
	 *  @return nothing
	 *
	 */

	private function _populate( $data ) {
		foreach ( $data as $key => $value )
			$this->$key = $value;
	}

	/**
	 *  returns the name of the table this model is
	 *  associated with.
	 *
	 *  @return String table name
	 *
	 */

	private function getTable() {

            $class = get_called_class();
            $model = class_exists( $class )
                ? new $class()
                : new stdclass();

            return ( $model->tableName )
                ? $model->tableName
                : Smutty_Inflector::tableize( $class );

	}

	/**
	 *  returns an array of this models fields and their types
	 *
	 *  @param String $class the class to fetch fields for
	 *  @return array fields for this model
	 *
	 */

	public function getFields() {

		static $cache;
		if ( $cache == null )
			$cache = array();

                $class = get_called_class();
		$cacheId = $class;
		if ( !isset($cache[$cacheId]) ) {

			$tblName = $this->getTable();
			$sql = $this->_db->getFieldsSql( $tblName );
			$res = $this->_db->query( $sql );
			$array = array();

			while ( $row = $res->fetch() ) {
				$field = new stdclass();
				$field->name = $row[ 0 ];
				$field->nullable = ( strtolower($row[2]) == 'yes' );
				// strip field sizes, just want the basic type
				$field->type = preg_replace( '/^(.*)\(.*$/', '$1', $row[1] );
				$array[] = $field;
			}

			$cache[$cacheId] = $array;

		}

		return $cache[ $cacheId ];

	}

	/**
	 *  returns the total number of records for the model
	 *
	 *  @param String $class class to fetch for
	 *  @return int total records
	 *
	 */

	public static function getTotal( $class ) {

		$db = Smutty_Database::getInstance();
		$table = Smutty_Model::_getTable( $class );
		$sql = " select count(*) as total
				from `$table` ";
		if ( !$res = $db->query($sql) )
			Smutty_Error::fatal( $db->getError(), 'ClassSmutty_Database' );
		$row = $res->fetchObject();

		return $row->total;

	}

	/**
	 *  returns a reference to the "find cache"
	 *
	 *  @return hashRef reference to find cache hash
	 *
	 */

	private static function &_getFindCache() {
		static $cache;
		if ( $cache == null )
			$cache = array();
		return $cache;
	}

	/**
	 *  this function allows searching for a record by
	 *  it's unique id.  if it is found then an instance
	 *  of it's model object will be returned, otherwise
	 *  you'll get false.
	 *
	 *  @param String $class the model class to search
	 *  @param String $id the id to find
	 *  @param String $field the field to find on (default='id')
	 *  @return Smutty_Model the model found
	 *
	 */

	public static function find( $class, $id, $field = 'id' ) {

		$cache =& self::_getFindCache();
		$cacheId = strtolower($class) . $id;

		if ( !isset($cache[$cacheId]) ) {

			$db = Smutty_Database::getInstance();
			$tblName = Smutty_Model::_getTable( $class );
			$id = $db->escape( $id );
			$field = $db->escape( $field );
			$sql = " select *
					from `$tblName`
					where `$field` = '$id' ";
			if ( !$res = $db->query($sql) )
				Smutty_Error::fatal( $db->getError(), 'ClassSmutty_Model' );
			if ( $row = $res->fetchAssoc() ) {
				$model = new $class();
				$model->_populate( $row );
				$cache[$cacheId] =& $model;
			}
			else $cache[$cacheId] = false;

		}

		return $cache[ $cacheId ];

	}

	/**
	 *  returns all the records for this model
	 *
	 *  @param String $class the class to search
	 *  @param String $order order the results by eg. "field:desc"
	 *  @param array $params name/value pairs for fields to match
	 *  @param String $limit how to limit results eg. "start:count"
	 *  @param array $joins array or string of model joins to make
	 *  @return array Model objects
	 *
	 */

	public static function fetchAll( $class, $order = false, $params = array(), $limit = false, $whereSql = '', $joins = array() ) {

		$model = new $class();
		$db = Smutty_Database::getInstance();

		// specify an order by?
		$orderSql = '';
		if ( $order ) {
			$parts = explode( ':', $order );
			$orderSql = " order by `$class`.`$parts[0]` " .
				( isset($parts[1]) ? " $parts[1] " : 'asc' );
		}

		// limit results?
		$limitSql = '';
		if ( $limit ) {
			$parts = explode( ':', $limit );
			$limitSql = isset($parts[1])
				? " limit $parts[0], $parts[1] "
				: " limit $parts[0] ";
		}

		// other params
		$whereSql = $whereSql ? " and $whereSql " : '';
		if ( is_array($params) )
			foreach ( $params as $key => $value ) {
				$ops = explode( ':', $key );
				$name = preg_replace( '/\./', '`.`', $ops[0] );
				$op = isset($ops[1]) ? $ops[1] : '=';
				$value = $db->escape( $value );
				switch ( $op ) {
					case 'contains':
						$whereSql = " and ( match ($name) against ('$value') ) ";
						break;
					case 'like':
					default:
						$whereSql .= " and ( `$name` $op '$value' ) ";
				}
			}
		$whereSql = substr( $whereSql, 4 );
		if ( $whereSql ) $whereSql = " where $whereSql ";

		// work out joins
		$joinSql = '';
		$joins = is_array($joins) ? $joins : explode( ' ', $joins );
		foreach ( $joins as $join )
			$joinSql .= self::getJoinSql( $class, $join );

		// generate sql for query
		$tblName = Smutty_Model::_getTable( $class );
		$sql = " select `$class`.*
				from `$tblName` `$class`
				$joinSql
				$whereSql
				$orderSql
				$limitSql ";
		if ( !$res = $db->query($sql) )
			Smutty_Error::fatal( $db->getError(), 'ClassSmutty_Model' );

		// put results in array ready to return
		$array = array();
		while ( $row = $res->fetchAssoc() ) {
			$model = new $class();
			$model->_populate( $row );
			$array[] = $model;
		}

		return $array;

	}

	/**
	 *  returns the sql to do a join to the dot seperated
	 *  list of models specified.  an inner join is used.
	 *
	 *  eg. getJoinSql( 'Post', 'User.UserType' );
	 *
	 *  @param String $fromAlias the alias to join from
	 *  @param String $joins dot seperated string of models
	 *
	 */

	private static function getJoinSql( $fromAlias, $joins ) {

		$joinSql = '';
		$parts = explode( '.', $joins );
		$alias = array_shift( $parts );

		if ( $alias ) {

			$table = self::_getTable( $alias );
			$field = w( $parts, 1, strtolower($alias.'_id') );

			$joinSql = " inner join `$table` `$alias` " .
					" on `$alias`.`id` = `$fromAlias`.`$field` " .
					self::getJoinSql( $alias, implode('.',$parts) );

		}

		return $joinSql;

	}

	/**
	 *  this function checks if the models data is currently in a
	 *  valid state to be saved.  this means that all validation
	 *  criteria that have been specified need to be met.
	 *
	 *  errors are stored in $this->errors and can be accessed
	 *  by using the $this->getErrors() function.
	 *
	 *  @return boolean indicates validity
	 *
	 */

	public function isValid() {

		$errors = array();
		$fields = Smutty_Model::getFields( get_class($this) );

		foreach ( $fields as $field ) {

			$name = $field->name;
			$value = is_object($this->$name) ? $this->$name->id : $this->$name;

			// check requiredness from db
			if ( ($name != 'id') && (!isset($value) && !$field->nullable) )
				array_push( $errors, " $name " . ERR_VALIDATE_REQUIRED );

			// try validate array
			elseif ( $rules = v($this->validate,$name) ) {

				$rules = is_array($rules) ? $rules : array( 'type' => $rules );

				// check by type
				if ( $type = v($rules,'type') )
					switch ( $type ) {
						case DATE_REQUIRED:
							if ( !$value )
								array_push( $errors, " $name " . ERR_VALIDATE_REQUIRED );
							break;
						case STR_REQUIRED:
							if ( !$value )
								array_push( $errors, " $name " . ERR_VALIDATE_REQUIRED );
							break;
						case INT_REQUIRED:
							$value = Smutty_Data::getInt( $value );
							if ( !$value )
								array_push( $errors, " $name " . ERR_VALIDATE_REQUIRED );
							break;
					}

				// check by regexp
				if ( $regexp = v($rules,'regexp') )
					if ( !preg_match($regexp,$value) )
						array_push( $errors, " $name is in an invalid format" );

				// check by max length
				$length = strlen( $value );
				if ( $max = v($rules,'maxlength') )
					if ( $length > $max )
						array_push( $errors, " $name is too long" );

				// check for min length
				if ( $min = v($rules,'minlength') )
					if ( $length < $min )
						array_push( $errors, " $name is too short" );

			}

			// is there a validate method defined?
			$method = 'validate' . ucfirst($name);
			if ( method_exists($this,$method) ) {
				$data = Smutty_Data::getInstance();
				$session =& Smutty_Session::getInstance();
				if ( $error = $this->$method($value,$data,$session) )
					array_push( $errors, $error );
			}

		}

		// set errors on current controller
		Smutty_Controller::addErrors( $errors );

		$this->errors = $errors;
		$this->_needsValidating = ( $errors );
		return ( !$this->_needsValidating );

	}

	/**
	 *  returns an array containing any errors that were encountered the
	 *  last time the model was validated.
	 *
	 *  @return array array of error strings
	 *
	 */

	public function getErrors() {

		return $this->errors;

	}

	/**
	 *  determines if a record with the specified id
	 *  currently exists in this models table
	 *
	 *  @param String $id the id to search for
	 *  @return boolean indicates if id exists
	 *
	 */

	public function exists( $id ) {
		$db = Smutty_Database::getInstance();
		$table = Smutty_Model::_getTable( get_class($this) );
		$id = $db->escape( $id );
		$sql = " select 1
				from `$table`
				where id = '$id' ";
		$res = $db->query( $sql );
		return ( $res->fetch() );
	}

	/**
	 *  returns the sql for UPDATING this models record
	 *
	 *  @return String the sql
	 *
	 */

	private function _getUpdateSql() {

		$class = get_class( $this );
		$db = Smutty_Database::getInstance();
		$table = Smutty_Model::_getTable( $class );
		$sql = '';
		$fields = Smutty_Model::getFields( $class );

		foreach ( $fields as $field ) {
			$name = $field->name;
			if ( $name == 'id' )
				continue;
			$value = is_object($this->$name) ? $this->$name->id : $this->$name;
			$value = $db->escape( $value );
			$sql .= ", `$name` = '$value' ";
		}

		$sql = substr( $sql, 1 );
		$id = $db->escape( $this->id );
		$sql = " update `$table`
			 	set $sql
			 	where id = '$id' ";

		return $sql;

	}

	/**
	 *  returns a value properly formatted for the specified field type
	 *
	 *  @param String $field a field (name/value) object
	 *  @param String $value the desired field value
	 *  @return String the field value
	 *
	 */

	private function _getFieldValue( $field, $value ) {
		$db = Smutty_Database::getInstance();
		if ( !$db ) Smutty_Error::fatal( ERR_DB_NO_CONN, 'ClassSmutty_Database' );
		switch ( $field->type ) {
			case 'int':
				return (int) $value;
				break;
			case 'datetime':
				//check date
				if ( !(preg_match('/^\d{4}-\d{2}-\d{2}$/',$value) || preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/',$value)) )
					return '';
				// fall through...
			default:
				return $db->escape( $value );
		}
	}

	/**
	 *  returns the sql for inserting a new record with this
	 *  models data.
	 *
	 *  @return String the sql
	 *
	 */

	private function _getInsertSql() {

		$class = get_class( $this );
		$db = Smutty_Database::getInstance();
		$sqlFields = '';
		$sqlValues = '';
		$fields = Smutty_Model::getFields( $class );
		$table = Smutty_Model::_getTable( $class );

		foreach ( $fields as $field ) {
			$name = $field->name;
			if ( $name == 'id' )
				continue;
			$value = is_object($this->$name) ? $this->$name->id : $this->$name;
			$value = $this->_getFieldValue( $field, $value );
			$sqlFields .= ", $field->name";
			$sqlValues .= ", '$value' ";
		}

		$sqlFields = substr( $sqlFields, 1 );
		$sqlValues = substr( $sqlValues, 1 );
		$sql = " insert into `$table`
			 	( $sqlFields )
			 	values ( $sqlValues ); ";

		return $sql;

	}

	/**
	 *  this function saves a models data, it returns a boolean
	 *  indicating if the save went ahead ok or not.
	 *
	 *  @return boolean if save succeeded
	 *
	 */

	public function save() {

		$class = get_class( $this );
		$db = Smutty_Database::getInstance();
		$sql = null;

		// first we need to do any data validation that is required
		if ( $this->_needsValidating && !$this->isValid() )
			return false;

		// existing record or new one?
		if ( $this->id && $this->exists($this->id) )
			$sql = $this->_getUpdateSql();
		else
			$sql = $this->_getInsertSql();

		if ( $db->update($sql) ) {
			// auto-set an id?
			if ( !$this->id )
				$this->id = $db->getInsertId( $this->_getTable($class) );
			// as this model has been edited we need
			// to remove it from the find() cache
			$cache =& self::_getFindCache();
			unset( $cache[get_class($this).$this->id] );
			return true;
		}
		else return false;

	}

	/**
	 *  deletes the current model from the database
	 *
	 *  @return boolean if delete succeeded
	 *
	 */

	public function delete() {

		$db = Smutty_Database::getInstance();
		$class = get_class( $this );
		$table = Smutty_Model::_getTable( $class );
		$sql = " delete from `$table`
				where `id` = '$this->id' ";
		return $db->update( $sql );

	}

	/**
	 *  this method allows deleting of multiple records
	 *
	 *  @param String $class the class to delete for
	 *  @param array $params assoc array of where params
	 *  @return nothing
	 *
	 */

	public static function deleteWhere( $class, $params ) {

		$db = Smutty_Database::getInstance();
		$table = Smutty_Model::_getTable( $class );
		$whereSql = '';

		// create where sql
		foreach ( $params as $name => $value )
			$whereSql .= ' and ( `' . $name . '` = \'' . $db->escape($value) . '\' ) ';
		$whereSql = substr( $whereSql, 4 );
		if ( $whereSql )
			$whereSql = ' where ' . $whereSql;

		// do the delete
		$sql = " delete from `$table`
				$whereSql ";
		return $db->update( $sql );

	}

	/**
	 *  checks the model for a custom property handler for
	 *  the specifed property name, if it's found then it's
	 *  executed and it's result returned.
	 *
	 *  @param String $name name of property
	 *  @return mixed property value
	 *
	 */

	private function _tryPropertyHandler( $name ) {

		// first check for a custom property handler
		$propertyMethod = $name . 'Property';

		if ( method_exists($this,$propertyMethod) ) {

			// set properties on model directly, we need to do
			// a little trickery...  this is pretty messy but
			// i can't think of a better way to do it right now.
			foreach ( $this->_data as $key => $value )
				$this->$key = $value;
			// now call property handler
			$result = $this->$propertyMethod();
			// then remove the properties we set (otherwise
			// they won't trigger __get() calls)
			foreach ( $this->_data as $key => $value )
				unset( $this->$key );

			return $result;

		}

		return null;

	}

	/**
	 *  checks the $hasOne property to see if there is
	 *  a mapping defined that matches the current property
	 *  that we're looking for.
	 *
	 *  @param String $name name of the property
	 *  @return String property value
	 *
	 */

	private function _tryHasOneMapping( $name ) {

		if ( !$this->hasOne ) return;

		$parts = explode( ' ', $this->hasOne );

		foreach ( $parts as $part ) {
			$names = explode( '.', $part );
			$modelName = $names[0];
			$tableName = strtolower( $modelName );
			$propName = w( $names, 2, $tableName );
			// have we found a related field we need to load?
			if ( $name == $propName ) {
				$fieldName = w( $names, 1, $tableName . '_id' );
				$id = isset($this->_data->$fieldName) ? $this->_data->$fieldName : '';
				$model = false;
				if ( class_exists($modelName) )
					$model = Smutty_Model::find( $modelName, $id );
				return $model;
			}
		}

		return null;

	}

	/**
	 *  checks the $hasMany property to see if there is
	 *  a mapping defined that matches the current property
	 *  that we're looking for.
	 *
	 *  @param String $name name of the property
	 *  @return mixed property value
	 *
	 */

	private function _tryHasManyMapping( $name ) {

		if ( !$this->hasMany ) return;

		$parts = explode( ' ', $this->hasMany );
		foreach ( $parts as $part ) {
			$names = explode( '.', $part );
			$modelName = $names[ 0 ];
			$fieldName = w( $names, 1, strtolower(get_class($this)) . '_id' );
			$orderBy = w( $names, 2, 'id:asc' );
			$plural = Smutty_Inflector::pluralize(
				strtolower($modelName)
			);
			if ( $name == $plural ) {
				$id = $this->_data->id;
				$models = false;
				if ( class_exists($modelName) )
					$models = Smutty_Model::fetchAll(
						$modelName, $orderBy, array( $fieldName => $id )
					);
				return $models;
			}
		}

		return null;

	}

	/**
	 *  checks the model to see if there are any "relation" mapping
	 *  defined.  these are mapping that use a relation table to
	 *  define many/many relations/
	 *
	 *  @param String $name name of property
	 *  @return mixed array of models
	 *
	 */

	private function _tryHasRelationMapping( $name ) {

		$relations = split( ' ', $this->hasRelation );

		foreach ( $relations as $relation ) {
			// get relation info
			$parts = split( '\.', $relation );
			$model = v( $parts, 0 );
			$modelPlural = Smutty_Inflector::pluralize( strtolower($model) );
			// have we found a relation match?
			if ( $name == $modelPlural ) {

				$db = Smutty_Database::getInstance();
				$class = strtolower(get_class($this));
				$table = $class . '_' . $modelPlural;

				// query for id's from relation table
				$idString = ' -1 ';
				$fromId = $class . '_id';
				$toId = strtolower($model) . '_id';
				$sql = " select $toId
						from $table
						where $fromId = '" . $this->_data->id . "' ";
				$res = $db->query( $sql );
				while ( $row = $res->fetch() )
					$idString .= " , '" . $db->escape($row[0]) . "' ";

				// then query for models using id's
				return Smutty_Model::fetchAll(
					$model,
					false,
					array(),
					false,
					" id in ( $idString ) "
				);

			}
		}

	}

	/**
	 *  handles access to model variables, needs to check the
	 *  relations (hasOne,hasMany) that have been defined
	 *  to give automagic access.
	 *
	 *  @param String $name the property name
	 *  @return String the property value
	 *
	 */

	public function __get( $name ) {

		$props = array( 'PropertyHandler', 'HasOneMapping',
			'HasManyMapping', 'HasRelationMapping' );

		foreach ( $props as $try ) {
			$handler = "_try$try";
			$value = $this->$handler( $name );
			if ( isset($value) ) {
				$this->_propertyCache[$name] = $value;
				return $value;
			}
		}

		// direct cache hit?
		if ( isset($this->_propertyCache[$name]) )
			return $this->_propertyCache[$name];

		// direct property hit?
		elseif ( isset($this->_data->$name) )
			return is_object( $this->_data->$name )
					 ? $this->_data->$name->id
					 : $this->_data->$name;

		return '';

	}

	/**
	 *  handles storing of model properties
	 *
	 *  @param String $name the name of the property
	 *  @param String $value the properties value
	 *  @return nothing
	 *
	 */

	public function __set( $name, $value ) {
		if ( isset($this->_data->$name) && is_object($this->_data->$name) )
			$this->_data->$name->id = $value;
		else
			$this->_data->$name = $value;
		$this->_needsValidating = true;
	}

}

?>
