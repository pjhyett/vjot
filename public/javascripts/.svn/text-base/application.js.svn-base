var Container = Class.create();
Container.prototype = {  
  initialize: function(user_id, jots) {
    this.user_id = user_id;
    this.jots = jots;
    this.refresh_list(this.jots);
  },
  
  set_current: function(jot) {
    if($('saved').visible()) $('saved').hide();
    $$('.jot').each(function(jot){ jot.removeClassName('clicked') });
    $('title').value = jot.title;
    $('body').value = jot.body;
    $('jot-' + jot.id).addClassName('clicked');
    $('body').disabled = false;
    $('body').focus();
    this.current = jot;
  },
  
  update_current: function() {
    if($('saved').visible()) $('saved').hide();
    this.current.body = $F('body');
    $('jot-' + this.current.id).innerHTML = this.jot_title(this.current);
  },

  search: function(query) {
    $('body').value = '';
    $('jots').innerHTML = '';
    var re = new RegExp(query, "i");
    var results = this.jots.findAll(function(jot){
      return jot.title.match(re);
    }.bind(this));
    
    if(results.length > 0){
      this.refresh_list(results);
      $('jots').show();
    }
  },
  
  add_jot: function(jot) {
    $('jots').innerHTML = '';
    jot = jot.to_json();
    this.jots.push(jot);
    this.refresh_list([jot]);
    $('jots').show();
    this.set_current(jot);
  },
  
  jot_title : function(jot) {
    var title = (jot.title + ' -- ' + jot.body).substring(0, 32);
    if(title.length == 32) title += "...";
    return title;
  },
  
  jot_li: function(jot) {
    attrs = { class:"jot", id:"jot-" + jot.id, onclick:"jot_clicked('" + jot.id + "'); return false" };
    var li = $li(attrs, this.jot_title(jot));
    $('jots').appendChild(li);
  },
  
  refresh_list: function(jots) {
    jots.each(function(jot){ this.jot_li(jot) }.bind(this));    
  },
  
  clear: function() {
    $('jots').hide();
    $('jots').innerHTML = '';
    $('title').value = '';
    $('body').value  = '';
    this.refresh_list(this.jots);
  }, 
  
  sync: function() {
    new Ajax.Request('/users/' + this.user_id + '/jots', { method:'put', postBody:'jots=' + JSON.stringify(this.jots) });
    $('body').focus();
  }
}

var Jot = Class.create();
Jot.prototype = {
  initialize: function(user_id, title, body) {
    this.user_id = user_id;
    this.title = title;
    this.body  = body;
    this.json  = JSON.stringify(this);
  },
  
  to_json: function() {
    var id    = 'id: "s' + new Date().getTime() + '"';
    var user  = ', user_id: ' + this.user_id;
    var body  = ', body: '  + JSON.stringify(this.body);
    var title = ', title: ' + JSON.stringify(this.title);
    return eval('({' + id + user + body + title + '})');
  },
}

String.prototype.escapeHTML = function () {                                        
  return(                                                                 
    this.replace(/&/g,'&amp;').                                         
        replace(/>/g,'&gt;').                                           
        replace(/</g,'&lt;').                                           
        replace(/"/g,'&quot;')                                         
  );                                                                      
};
