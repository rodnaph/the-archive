
{include file="include/header.tpl" title="Enigform Demo Login" enableAjax="true"}

<h2>Enigform Demo</h2>

{tabgroup pages={ loginTab="Login" registerTab="Add Public Key" } class="tabgroup" }

{tabpage id="loginTab" default="yes" class="tabpage"}

<p>If you don't already have the Enigform extension installed then you can
<a href="http://enigform.mozdev.org/">download it from here</a>.  Before trying
the login you'll have to add your public key, click on the next tab to do this.
The login is done via {link url={ controller="wiki" name="SmuttyAjax" } text="Ajax"}.</p>

{form url={ action="efLogin" } update="LoginResult" feedback="LoginResult" gpgSigned="true"}

	<fieldset>

	{field name="name" label="Name:"}

	{submit text="Try Login"}

	</fieldset>

{form_end}

<h3 id="LoginResult"></h3>

{tabpage_end}

{tabpage id="registerTab" class="tabpage"}

<p>To register your name and public key, just enter them into the
form below and click the submit button.</p>

{form url={ action="efRegister" } feedback="RegisterResult"
	update="RegisterResult" }

	<fieldset>

	{field name="name" label="Name:"
		url={ action="efCheckName" } update="NameCheck"}
		
	&nbsp; <span id="NameCheck"></span>

	{textarea name="public_key" label="Public Key:"}

	{submit text="Register"}

	</fieldset>

{form_end}

<h3 id="RegisterResult"></h3>

{tabpage_end}

<p><a href="javascript:;" onclick="Effect.SlideDown('source');">Show Me The Source!</a></p>
<div id="source" style="display:none;">
<pre>
#
#  views/demo/enigform.tpl
#
{ldelim}form url={ldelim} action="efLogin" {rdelim} update="LoginResult"
	feedback="LoginResult" gpgSigned="true"{rdelim}

	{ldelim}field name="name" label="Name:"{rdelim}

	{ldelim}submit text="Try Login"{rdelim}

{ldelim}form_end{rdelim}

&lt;div id="LoginResult"&gt;&lt;/div&gt;

{ldelim}form url={ldelim} action="efRegister" {rdelim} feedback="RegisterResult"
	update="RegisterResult" {rdelim}

	{ldelim}field name="name" label="Name:"
		url={ldelim} action="efCheckName" {rdelim} update="NameCheck"{rdelim}

	&lt;span id="NameCheck"&gt;&lt;/span&gt;

	{ldelim}textarea name="public_key" label="Public Key:"{rdelim}

	{ldelim}submit text="Register"{rdelim}

{ldelim}form_end{rdelim}

&lt;div id="RegisterResult"&gt;&lt;/div&gt;

#
#  controllers/DemoController.php
#
class DemoController extends Smutty_Controller {ldelim}

	function efLoginAction( $data ) {ldelim}
		if ( $key = $data->isVerified() ) {ldelim}
			$user = EnigformUser::find( $key->getKeyId(), 'gpgkeyid' );
			if ( $user->name == $data->string('name') ) {ldelim}
				echo 'Welcome back ' . $user->name;
				return;
			{rdelim}
		{rdelim}
		echo 'Verification failed...';
	{rdelim}

	function efRegisterAction( $data ) {ldelim}
		// check name isn't already taken
		if ( !EnigformUser::find($data->string('name'),'name') ) {ldelim}
			$gpg = new Smutty_GPG();
			// try and import the public key
			if ( $key = $gpg->import($data->string('public_key')) ) {ldelim}
				$user = new EnigformUser();
				$user->name = $data->string( 'name' );
				$user->gpgkeyid = $key->getKeyId();
				if ( $user->save() )
					echo 'Registration Complete!';
				else
					echo 'could not save user';
			{rdelim}
			else echo 'invalid public key';
		{rdelim}
		else echo 'username is already taken';
	{rdelim}

	function efCheckNameAction( $data ) {ldelim}
		if ( $name = $data->string('id') ) {ldelim}
			echo EnigformUser::fetchAll( false, array(
				'name' => $name
			)) ? 'Sorry, name taken...' : 'Username available!';
		{rdelim}
	{rdelim}

{rdelim}
</pre>
</div>

{include file="include/sidebar.tpl"}
{include file="include/footer.tpl"}
