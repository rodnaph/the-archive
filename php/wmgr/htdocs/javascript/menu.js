
var M_hideTimeout = null;
var M_menus = new Array();


/**
 *  this function will hide all menus on the page
 *
 */

function M_hideMenus() {
	M_hideClear();
	for ( var i=0; i<M_menus.length; i++ )
		M_menus[i].hide();
}

/**
 *  clears the timeout set to hide the menus
 *
 */

function M_hideClear() {
	if ( M_hideTimeout != null )
		clearTimeout( M_hideTimeout );
	M_hideTimeout = null;
}

/**
 *  sets a timeout to check if it's time to hide menus
 *
 */

function M_hideCheck() {
	M_hideClear();
	M_hideTimeout = setTimeout( M_hideMenus, 300 );
}

/**
 *  this is the Menu object that represents a menu on the main menubar. Menu's
 *  and menu items are considered to be the same thing.  If no sAction is passed
 *  then nothing will happen when the menu/item is clicked.
 *
 *  @param [sText] the text to display for the item
 *  @param [sAction] (optional) the action to perform when this item is clicked.
 *  @param [sIcon] (optional) name of an icon file to use
 *
 */

function Menu( sText, sAction, sIcon ) {

	var sText = new String(sText);	// the text to display
	var sAction = sAction;		// an action to perform when the menu item is clicked
	var sIcon = sIcon;		// icon file to use (optional)
	var oParent = null;		// a link to the parent menu
	var aChildren = new Array();	// an array of child menus
	var oSelf = this;		// this
	var eItem = null;		// the menu item element
	var eChildren = null;		// element to contain menu's children
	var iWidth = null;		// optional menu width in pixels

	/**
	 *  returns the menu items DOM element
	 *
	 */

	this.getElement = function() {
		return eItem;
	};

	/**
	 *  sets this menus parent
	 *
	 *  @param [oNewParent] the menus new parent
	 *
	 */

	this.setParent = function( oNewParent ) {
		oParent = oNewParent;
	};

	/**
	 *  returns this menus parent
	 *
	 */

	this.getParent = function() {
		return oParent;
	};

	/**
	 *  adds a child to this menu
	 *
	 */

	this.add = function( oMenu ) {
		oMenu.setParent( oSelf );
		aChildren.push( oMenu );
	};

	/**
	 *  sets the menus width
	 *
	 *  NB! this must be done before the menu is created!
	 *
	 *  @param [width] the width to set in pixels
	 *
	 */

	this.setWidth = function( iNewWidth ) {
		iWidth = iNewWidth;
	}

	/**
	 *  this should be called once on the root menu for this tree
	 *  when it is time to draw it.
	 *
	 */

	this.init = function() {
		var eNav = document.getElementById( 'NavWrap' );
		oSelf.draw( eNav );
		M_menus.push( oSelf );
	};

	/**
	 *  draws the menu on the page.  this is done once when the
	 *  root of this menu tree it initialised.
	 *
	 *  @param [eContainer] the container to draw the menu in
	 *
	 */

	this.draw = function( eContainer, iMenuWidth ) {

		// create the menu item
		eItem = document.createElement( 'a' );
		eItem.className = oSelf.getClassName();
		eItem.onmouseover = oSelf.show;
		eItem.onmouseout = M_hideCheck;
		if ( iMenuWidth )
			eItem.style.width = iMenuWidth + 'px';

		if ( oSelf.getParent() || sIcon ) {
			var eImg = document.createElement( 'img' );
			eImg.src = URL_BASE + '/images/12x12/' + ( sIcon ? sIcon : 'empty.png' );
			eItem.appendChild( eImg );
		}

		var charCount = iMenuWidth ? iMenuWidth / 9 : 13;
		eItem.appendChild( document.createTextNode(
			sText.length > charCount ? sText.substring(0,charCount) + '...' : sText
		));
		eContainer.appendChild( eItem );
		eItem.href = sAction ? URL_BASE + sAction : 'javascript:;';
		eItem.onclick = M_hideMenus;

		// then create any children
		if ( aChildren.length > 0 ) {
			eChildren = document.createElement( 'div' );
			for ( var i=0; i<aChildren.length; i++ )
				aChildren[i].draw( eChildren, iWidth );
			eChildren.className = 'MenuChildren';
			eContainer.appendChild( eChildren );
		}

	};

	/**
	 *  makes the menu visible and positions it correctly.
	 *
	 */

	this.show = function() {

		M_hideClear();

		// if we're at the top of the tree hide another other
		// menus that may currently be displayed.
		if ( !oSelf.getParent() ) M_hideMenus();
		// otherwise hide any other menus that may be being shown
		// from this menus parent.
		else oSelf.getParent().hide( true );

		// position the child menu
		if ( eChildren != null ) {
			oSelf.getElement().className += ' MenuExpanded';
			eChildren.style.top = oSelf.getParent()
				? (oSelf.getElement().offsetTop - 1) + 'px'
				: (getYPos(oSelf.getElement()) + 20) + 'px';
			eChildren.style.left = oSelf.getParent()
				? oSelf.getElement().clientWidth + 'px'
				: getXPos(oSelf.getElement()) + 'px';
			eChildren.style.display = 'block';
		}

	};

	/**
	 *  returns the class name/s to use for this menu
	 *
	 */

	this.getClassName = function() {
		return oSelf.getParent()
			? aChildren.length ? 'MenuItem MenuParent' : 'MenuItem'
			: 'MenuRoot'
	};

	/**
	 *  hides this menu and it's children.  the bOnlyChildren parameter is
	 *  a special switch which means that only the menus children
	 *  will be hidden and not this menu itself
	 *
	 *  @param [bOnlyChildren]
	 *
	 */

	this.hide = function( bOnlyChildren ) {
		if ( eChildren != null && !bOnlyChildren ) {
			oSelf.getElement().className = oSelf.getClassName();
			eChildren.style.display = 'none';
		}
		for ( var i=0; i<aChildren.length; i++ )
			aChildren[i].hide();
	};

}

/**
 *  handles the return of the query for the users own menu data, then
 *  builds the users menu for it.
 *
 *  @param [oRequest] the request object
 *
 */

function M_myMenuHandler( oRequest ) {

	var xml = oRequest.responseXML;
	var root = xml.documentElement;
	var menu = new Menu( 'Mine', null, 'user.png' );

	// add users tasks if they have any
	var aTasks = root.getElementsByTagName( 'task' );
	if ( aTasks.length > 0 ) {
		var mTasks = new Menu( 'Tasks', null, 'task.png' );
		for ( var i=0; i<aTasks.length; i++ ) {
			var id = aTasks[ i ].getAttribute( 'id' );
			var name = getChildValue( aTasks[i], 'name' );
			var eStatus = getChild( aTasks[i], 'status' );
			var eIcon = getChild( eStatus, 'icon' );
			var sFile = getChildValue( eIcon, 'filename' );
			mTasks.add( new Menu('#'+id+': '+name,'/tasks/view.php?id='+id,sFile) );
		}
		mTasks.setWidth( 200 );
		menu.add( mTasks )
	}

	// add users projects if they have any
	var aProjects = root.getElementsByTagName( 'project' );
	if ( aProjects.length > 0 ) {
		var mProjects = new Menu( 'Projects', null, 'project.png' );
		for ( var i=0; i<aProjects.length; i++ ) {
			var id = aProjects[ i ].getAttribute( 'id' );
			var name = getChildValue( aProjects[i], 'name' );
			mProjects.add( new Menu(name,'/projects/view.php?id='+id) );
		}
		menu.add( mProjects )
	}

	// add users groups if they have any
	var aGroups = root.getElementsByTagName( 'group' );
	if ( aGroups.length > 0 ) {
		var mGroups = new Menu( 'Groups', null, 'group.png' );
		for ( var i=0; i<aGroups.length; i++ ) {
			var id = aGroups[ i ].getAttribute( 'id' );
			var name = getChildValue( aGroups[i], 'name' );
			mGroups.add( new Menu(name,'/groups/view.php?id='+id) );
		}
		menu.add( mGroups )
	}


	menu.init();

}

/**
 *  create the sites menus!
 *
 */

if ( user ) {

	var create = new Menu( 'Create' );
	create.add( new Menu('Task','/tasks/create.php','task.png') );
	create.add( new Menu('Page','/pages/edit.php','page.png') );
	create.add( new Menu('Project','/projects/create.php','project.png') );
	create.add( new Menu('Group','/groups/create.php','group.png') );

	var explore = new Menu( 'Explore' );
	explore.add( new Menu('Projects','/projects/','project.png') );
	explore.add( new Menu('Pages','/pages/','page.png') );

	var main = new Menu( 'Main', null, 'main.png' );
	main.add( create );
	main.add( explore );
	main.add( new Menu('Profile','/users/view.php?id='+user.id,'profile.png') );
	main.add( new Menu('Home','/','home.png') );
	main.add( new Menu('Logout','/users/logout.php','logout.png') );
	main.init();

	var url = URL_BASE + '/xml/users/myMenu.xml.php';
	setTimeout( function() {
		xmlQuery( url, M_myMenuHandler );
	}, 500 );

} else {

	var home = new Menu( 'Home', '/', 'home.png' );
	home.init();

	var login = new Menu( 'Login', '/users/login.php', 'login.png' );
	login.init();

	var register = new Menu( 'Register', '/users/register.php', 'profile.png' );
	register.init();

}