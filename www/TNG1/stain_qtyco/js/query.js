const API = {
  list: "api_qtyco_list.asp",
  save: "api_qtyco_save.asp",
  del:  "api_qtyco_delete.asp"
};

function apiSave(row){
  console.log("[API SAVE]", row);
  return fetch(API.save, {
    method: "POST",
    headers: {"Content-Type":"application/json"},
    body: JSON.stringify(row)
  }).then(r => r.json());
}

function apiDelete(id){
  console.log("[API DELETE]", id);
  return fetch(API.del, {
    method: "POST",
    body: JSON.stringify({qtyco_idx:id})
  });
}
