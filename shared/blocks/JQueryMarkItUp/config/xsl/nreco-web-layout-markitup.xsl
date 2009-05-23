<xsl:stylesheet version='1.0' 
				xmlns:e="urn:schemas-nreco:nreco:entity:v1"
				xmlns:l="urn:schemas-nreco:nreco:web:layout:v1"
				xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
				xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
				xmlns:Dalc="urn:remove"
				xmlns:NReco="urn:remove"
				xmlns:asp="urn:remove"
				exclude-result-prefixes="msxsl">

	<xsl:output method='xml' indent='yes' />

	<xsl:template match="l:field[l:editor/l:markitup]" mode="form-view-editor">
		<xsl:param name="mode"/>
		<xsl:variable name="uniqueId"><xsl:value-of select="@name"/>_<xsl:value-of select="$mode"/>_<xsl:value-of select="generate-id(.)"/></xsl:variable>
		<asp:TextBox id="{@name}" runat="server" Text='@@lt;%# Bind("{@name}") %@@gt;' TextMode="multiline" OnLoad="markitupEditor_{$uniqueId}_onLoad">
			<xsl:if test="l:editor/l:markitup/@rows">
				<xsl:attribute name="Rows"><xsl:value-of select="l:editor/l:markitup/@rows"/></xsl:attribute>
			</xsl:if>
		</asp:TextBox>
		<script language="c#" runat="server">
		protected void markitupEditor_<xsl:value-of select="$uniqueId"/>_onLoad(object sender, EventArgs e) {
			var scriptName = "js/markitup/jquery.markitup.pack.js";
			var scriptTag = "@@lt;s"+"cript language='javascript' src='"+scriptName+"'@@gt;@@lt;/s"+"cript@@gt;";
			if (!Page.ClientScript.IsStartupScriptRegistered(Page.GetType(), scriptName)) {
				Page.ClientScript.RegisterStartupScript(Page.GetType(), scriptName, scriptTag, false);
			}
			// one more for update panel
			System.Web.UI.ScriptManager.RegisterClientScriptInclude(Page, Page.GetType(), scriptName, "ScriptLoader.axd?path="+scriptName);
		}
		</script>
		<link rel="stylesheet" type="text/css" href="js/markitup/skins/simple/style.css" />
		<link rel="stylesheet" type="text/css" href="js/markitup/sets/default/style.css" />
		
		<script language="javascript">
		jQuery('#@@lt;%# Container.FindControl("<xsl:value-of select="@name"/>").ClientID %@@gt;').markItUp(
			{	
				root : 'js/markitup/',
				onShiftEnter:  	{keepDefault:false, replaceWith:'@@lt;br /@@gt;\n'},
				onCtrlEnter:  	{keepDefault:false, openWith:'\n@@lt;p@@gt;', closeWith:'@@lt;/p@@gt;'},
				onTab:    		{keepDefault:false, replaceWith:'    '},
				markupSet:  [ 	
					{name:'Bold', key:'B', openWith:'(!(@@lt;strong@@gt;|!|<b>)!)', closeWith:'(!(@@lt;/strong@@gt;|!|</b>)!)', className: "markItUpButtonBold" },
					{name:'Italic', key:'I', openWith:'(!(@@lt;em@@gt;|!|@@lt;i@@gt;)!)', closeWith:'(!(@@lt;/em@@gt;|!|@@lt;/i@@gt;)!)', className: "markItUpButtonItalic"  },
					{name:'Stroke through', key:'S', openWith:'@@lt;del@@gt;', closeWith:'@@lt;/del@@gt;', className: "markItUpButtonStroke" },
					{separator:'---------------' },
					{name:'Picture', className: "markItUpButtonInsPicture", key:'P', replaceWith:'@@lt;img src="[![Source:!:http://]!]" alt="[![Alternative text]!]" /@@gt;' },
					{name:'Link', className: "markItUpButtonInsLink", key:'L', openWith:'@@lt;a href="[![Link:!:http://]!]"(!( title="[![Title]!]")!)@@gt;', closeWith:'@@lt;/a@@gt;', placeHolder:'Your text to link...' },
					{separator:'---------------' },
					{name:'Clean', className: "markItUpButtonClean", replaceWith:function(markitup) { return markitup.selection.replace(/@@lt;(.*?)@@gt;/g, "") } },		
					{name:'Preview', className:'preview',  call:'preview'}
				]
			}
		);
		</script>
	</xsl:template>
	
</xsl:stylesheet>