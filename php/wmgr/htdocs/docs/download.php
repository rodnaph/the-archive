<?

chdir( '../../' );

include 'include/web.inc.php';

// try and fetch the document
if ( $doc = Document::load($_GET['id']) ) {

	$name = addSlashes( $doc->name );

	// headers
	header( "Content-Disposition: attachment; filename=\"$name\";" );
	header( "Content-Length: $doc->binSize" );
	header( "Content-Type: $doc->binType" );

	echo $doc->getData();

}

else Error::fatal( 'invalid document id' );

?>