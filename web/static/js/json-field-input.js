function jinput(keyname, valuename) {
  let result = `<div class="row">
    <div class= "col-sm-4">
      <input class="form-control input-sm" name= ${keyname} type= "text">
    </div>
    <div class= "col-sm-4">
      <input class= "form-control input-sm" name= ${valuename} type= "text">
    </div>
    <div class= "col-sm-4">
      <a class= "json-input-remove btn btn-sm btn-link" href="javascript:void(0)">remove</a>
    </div>
  </div>`
  return result;
}

export default jinput
