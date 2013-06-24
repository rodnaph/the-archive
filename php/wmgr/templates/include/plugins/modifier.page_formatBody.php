<?

// safehtml includes
define( 'XML_HTMLSAX3', 'libs/safehtml/' );
include_once 'libs/safehtml/safehtml.php';

function smarty_modifier_page_formatBody_header( $matches ) {

	$size = strlen( $matches[1] );

	return "<h$size>" . smarty_modifier_escape($matches[2]) . "</h$size>";

}

/**
 *  this plugin is for formatting the body text of a wiki page
 *
 */

function smarty_modifier_page_formatBody( $page ) {

	$body = $page->getBody();
	$safe = new safehtml();

	// include sections
	$body = preg_replace_callback( '/\(\((.*?)\)\)/',
		create_function(
			'$matches',
			'$page = Page::loadByName($matches[1],' . $page->group->id . ');' .
			'return $page ? $page->body : \'\';'
		),
		$body );

	// page links
	$body = preg_replace_callback( '/\[\[(.*?)\]\]/', 
		create_function(
			'$matches',
			'$parts = preg_split( \'/\|/\', $matches[1] );' .
			'$name = $parts[0] ? $parts[0] : $matches[1];' .
			'$text = $parts[1] ? $parts[1] : $name;' .
			'return \'<a href="' . URL_BASE . '/pages/view.php?' .
				'name=\' . urlencode($name) . \'' .
				'&group_id=' . $page->group->id .
				'&from=' . $page->id  . '">\' . smarty_modifier_escape($text) . \'</a>\';'
		),
		$body );

	$body = $safe->parse( $body );

	return $body;

}

?>
