//= require "./form2object"
//= require "./jquery.toObject"
function form_to_json(e){
  e.preventDefault();
  return $(e.currentTarget).toObject({rails: true});
}
