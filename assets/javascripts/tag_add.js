/*------------------------------------------------
*
*   tag_add. $ Plugin
*
*   Copyright © 2009 Maltsev Vladimir.
*
*-------------------------------------------------
*
*   Official site: www.r-ip.ru
*   Contact e-mail: stavweb@yandex.ru
*
*   GNU General Public License original source:
*   http://www.gnu.org/licenses/gpl-3.0.html
*
*-------------------------------------------------
*			//ex
*          $(document).ready(function(){
*
*	       $j(".tag_add_input").tag_add({
*
*	       								maxitem:0, // max item for out, 0-show all
*		   								minlength:3, // min length str for search tags
*		   								maxlength:25, // max length str for search tags
*		   								loadinfo: 'loadtag.php', //file - data tags
*
*		   								});
*          })
*
*
**
***
------------------------------------------------*/
(function($) {
  var tagtext = '';
  var tag_ex = [];
  var it=0;
  var selqt=0;
  var lastselectrestag='';
  var Showdgs=true;

  var selitemdef=0;
  $.fn.tag_add = function(options){

    var elem = this.get(0);
    var selecttext='';

    options = $.extend({
      loadinfo: 'loadtag.php',
      minlength: 3,
      maxlength: 25,
      maxitem:10
    },options);

    function getCaretPos(e){
      $(e).focus();
      if (e.selectionStart) {
        return e.selectionStart;
      } else if (document.selection){
        var Sel = document.selection.createRange ();
        Sel.moveStart ('character', -e.value.length);
        return Sel.text.length;
      }

      return 0;
    }

    function tagtrim ( str, charlist ) {
      charlist = !charlist ? ' \s\xA0' : charlist.replace(/([\[\]\(\)\.\?\/\*\{\}\+\$\^\:])/g, '\$1');
      var re = new RegExp('^[' + charlist + ']+|[' + charlist + ']+$', 'g');
      return str.replace(re, '');
    }

    function substr_replace(s,e,str,sbstr){
      sbstr=tagtrim(sbstr);
      return str.substr(0,s)+sbstr+str.substr((s+e),(str.length-(s+e)));
    }

    function searchtext(strtag,cpos){
      var space=true;
      var startstr=0;
      var endstr=strtag.length;
      var res = '';
      for (i=cpos;i>=0;i--){
        if (startstr==0){
          if (strtag.substr((i-1), 1)==','){
            startstr = i;
            if ( (strtag.substr((i), 1)!=' ') && (i!=strtag.length) ){
              space=false;
            }
          }
        }
      }

      for (i=cpos;i<=strtag.length;i++){
        if (endstr==strtag.length){
          if (strtag.substr(i, 1)==','){
            endstr = i;
          }
        }
      }

      if (startstr==0){ startstr=-1; }
      if (space){ tagstart =startstr+1; tagend=endstr-startstr-1;
        res = (strtag.substr((startstr+1), (endstr-startstr-1)));
      }else{tagstart =startstr; tagend=endstr-startstr;
        if (startstr==-1){ startstr=0; }
        res = (strtag.substr(startstr, (endstr-startstr)));
      }
      return res;
    }

    function go_tag_load(e,o,jo){

      if ( (e.keyCode==40)||(e.keyCode==38)||(e.keyCode==13) ){ return false; }
      selqt=0; it=0;
      var tag_text = $(o).val();

      var text_search = searchtext(tag_text,getCaretPos(o));
      text_search = text_search.toLocaleLowerCase();
      var tag_ex =tagtext.split(',');
      if ( (text_search.length >= jo.minlength) && (text_search.length <= jo.maxlength) ){
        if (tagtext!=''){
          if(tagtext.indexOf(text_search) + 1) {
            var tag_str = '';

            $(".tag_add_input_form").remove();
            var formtagselect = $('<div class="tag_add_input_form" name="tag_add_input_form_name"></div>').css('opacity','0.9').width(elem.offsetWidth);
            $(o).before(formtagselect);
            it=0;
            for (var key in tag_ex) {
              var val = tag_ex [key];
              if (key == 'each') break;
              if ((val.indexOf(text_search) + 1) && ( ((jo.maxitem-1)>=it)||(jo.maxitem==0) )) {   it++;
                var item  = $('<li id="tagselid_'+it+'">'+tagtrim(val.split(text_search).join('<b>'+text_search+'</b>'))+'</li>');
                $(item).appendTo(formtagselect);

              }
            }

            $(".tag_add_input_form li").click(function(){
              var seltext = $(this).text();

              $(o).val(substr_replace(tagstart,tagend,$(o).val(),seltext));
              $(".tag_add_input_form").remove(); selqt=0; it=0;
            });

          }else{ $(".tag_add_input_form").remove(); selqt=0; it=0; }
        }
      } else { $(".tag_add_input_form").remove(); selqt=0; it=0; }
    }

    function remove_tag_list() {
      if (($(this).attr('name')=="tag_add_input_form_name")){
        return false;
      }else{
        $(".tag_add_input_form").remove(); selqt=0; it=0;
        lastselectrestag = '';
      }
    }

    function selectrestag(e,o,jo){
      if ( !$('.tag_add_input_form').length ){return false;}
      if (e.keyCode==40){
        selqt++;
        if (selqt>it){ selqt=1; }
      } else if (e.keyCode==38){
        selqt--;
        if (selqt<1){ selqt=it; }
      } else if ((e.keyCode==13) && (lastselectrestag!='')){
        $(o).val(substr_replace(tagstart,tagend,$(o).val(),$(lastselectrestag).text()));
        $(".tag_add_input_form").remove(); selqt=0; it=0;
        return false;
      }
      if (lastselectrestag!=''){
        $(lastselectrestag).removeClass('tag_add_input_form_sel');
      }
      $("#tagselid_"+selqt).addClass('tag_add_input_form_sel');
      lastselectrestag = "#tagselid_"+selqt;
      return false;
    }

    $.get(options.loadinfo,function(data){ if (tagtext==''){ tagtext = data.toLocaleLowerCase(); } });

    var fs = true;
    this.attr("autocomplete",'off')
      .blur(function(){ fs=true; })
      .click(function(e){go_tag_load(e,elem,options); fs=false; return false; })
      .keyup(function(e){go_tag_load(e,elem,options); return false;})
      .keydown(function(e){if ((e.keyCode==40)||(e.keyCode==38)||(e.keyCode==13)){ selectrestag(e,elem,options); return false;}});

    $('form').submit(function(){ return fs; });

    $("*",document.body).click(function(){ return remove_tag_list(); });
    $("*",document.body).focus(function(){ return remove_tag_list(); });

  };
} (jQuery));
