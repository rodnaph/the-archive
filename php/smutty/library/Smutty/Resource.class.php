<?php

/**
 *  this class handles access to "resources".  which in Smutty
 *  is basically anthing in the "public" directory.
 *
 */

class Smutty_Resource extends Smutty_Object {

	/**
	 *  this function can be used to output a resource to the user.
	 *  it will try and set http headers correctly for appropriate
	 *  caching, and getting the mime type right, etc...
	 *
	 *  @param String $path path of resource to output
	 *  @return nothing
	 *
	 */

	public static function output( $path ) {

		// don't allow parent dir access
		$path = preg_replace( '/\.\./' , '', $path );

		$dateFormat = 'D, d M Y G:i:s \G\M\T';
		$data = file_get_contents( $path );
		$length = filesize( $path );
		$mime = Smutty_Resource::getMimeType( $path );
		$info = stat( $path );
		$modified = date( $dateFormat, $info[9] );
		$expires = date( $dateFormat, (time() + (3600 * 24)) );
		$date = date( $dateFormat );

		header( "HTTP/1.1 200 Ok" );
		header( "Date: $date" );
		header( "Server: Smutty" );
		header( "Content-Type: $mime" );
		header( "Last-Modified: $modified" );
		header( "Cache-Control: public" );
		header( "Pragma: public" );
		header( "Content-Length: $length" );
		header( "Expires: $expires" );

		echo $data;
		exit();

	}

	/**
	 *  returns the mime type for a specific file, determined by
	 *  it's extension.  the path to the file doesn't have to be
	 *  readable from the filesystem, it's just used as a string
	 *  to extract the extension.
	 *
	 *  @param String $path path to the file
	 *  @return String mime type
	 *
	 */

	public static function getMimeType( $path ) {

		static $mimes;

		$ext = strtolower(preg_replace( '/^.*\.(\w*)/', '$1', $path ));
		if ( $mimes == null ) {
			$cfg = Smutty_Config::getInstance();
			if ( $types = $cfg->get('mime.*') )
				foreach ( $types as $name => $value )
					$mimes[ strtolower(substr($name,5)) ] = $value;
		}

		return isset($mimes[$ext]) ? $mimes[$ext] : 'text/plain';

	}

}

?>