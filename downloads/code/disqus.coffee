Template.disqus.rendered = ->
  ###
  # We don't want to load Disqus until the first time the template is
  # rendered, since it requires the #disqus_thread div
  # Triggers Deps.autorun (below)
  ###
  Session.set("loadDisqus", true)

  ###
  # OPTIONAL: Only include the part below if you're using
  # Disqus single-sign on
  # Generate the disqusSignon variable appropriately from your server
  ###
  disqusSignon = Session.get("disqusSignon")
  if Meteor.user() and disqusSignon
    window.disqus_config = ->
      this.page.remote_auth_s3 = "#{disqusSignon.auth}"
      this.page.api_key = "#{disqusSignon.pubKey}"
      # ... other Disqus configs 
      
    ###
    # Whenever the template is rendered, trigger a Disqus reset.
    # This will find the correct thread for the current page URL.
    # See http://help.disqus.com/customer/portal/articles/472107-using-disqus-on-ajax-sites
    ###
    DISQUS?.reset(
       reload: true
       config: ->
    )

 
Deps.autorun(->
  # Load the Disqus embed.js the first time the `disqus` template is rendered
  # but never more than once
  if Session.get("loadDisqus") && !window.DISQUS
    # Below is the Disqus Universal Code
    # (in Coffeescript, backticks escape Javascript code)
    `
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'YOUR_SHORTNAME'; // required: replace example with your forum shortname

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
     var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
     dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
     (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
     })();
     `
)
