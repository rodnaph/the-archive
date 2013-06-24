
{include file="setup/header.tpl" title="Setup"}

<h1>Work Manager - Setup</h1>

<p>You are seeing this page because we can't find a config file so assume
that you need to setup the application.  To do this just read the instructions that
follow.</p>

{if !$configWritable || !$cacheWritable}
	<h2>Permissions</h2>
{/if}

{if !$configWritable}
	<h3 class="Error">ERROR :: The config directory (config/) is not writable!</h3>
	<p>The config directory is not currently writable, this means
	that the installation cannot go ahead, you need to correct
	this problem immediately.</p>
{/if}

{if !$cacheWritable}
	<h3 class="Error">ERROR :: The cache directory is not writable!</h3>
	<p>The smarty directory (cache/) is not currently
	writable, this means that while setup can continue, when it's
	complete you will get an error message telling you this directory cannot
	be written to, it's best to resolve this now.</p>
{/if}

{if $configWritable && $cacheWritable}

<h2>Creating a Database</h2>

<p>The first step is to provide either the information the database.  If you have
already created a blank database ready us to use then just put that information
into the form below.  If you have not created a database then you can specify
an administrator account so that setup will do this all for you.</p>


<form method="post" action="create.php">

	<fieldset>

		<legend>Required Information</legend>

		<p>Here you need to specify the login details for the database (which either
		already exists, or will be created for you by giving admin account info below).</p>

		<input type="hidden" name="todo" value="{$todo}" />
	
		<label for="dbtype">Type:</label>
		<select name="dbtype">
			<option value="{$DB_MYSQL}">MySQL 5+</option>
			<option value="{$DB_MSSQL}">SQL Server</option>
		</select>
	
		<label for="dbhost">Host:</label>
		<input type="text" name="dbhost" value="localhost" />
	
		<label for="username">User:</label>
		<input type="text" name="username" />
	
		<label for="password">Pass:</label>
		<input type="password" name="password" />

		<label for="dbname">DB Name:</label>
		<input type="text" name="dbname" />
		
	</fieldset>
	
	<fieldset>
	
		<legend>Administrator Account</legend>
	
		<p>Leave these fields blank if the database already exists.</p>

		<label for="admin-username">Admin User:</label>
		<input type="text" name="admin-username" />
	
		<label for="admin-password">Admin Pass:</label>
		<input type="password" name="admin-password" />

	</fieldset>

	<fieldset>

		<input type="submit" value="Proceed" />

	</fieldset>

</form>


{/if}


{include file="setup/footer.tpl"}
