var table;

document.addEventListener("DOMContentLoaded", function(){

table = new Tabulator("#qtyco-table", {
  ajaxURL: "api_qtyco_list.asp",
  layout: "fitColumns",
  selectable: true,
  history: true,

  columns: [
    {title:"번호", field:"QTYNo", editor:"input"},
    {title:"판재명", field:"QTYNAME", editor:"input"},
    {title:"회사명", field:"QTYcoNAME", editor:"input"},
    {title:"타입", field:"unittype_qtyco_idx", editor:"input"},
    {title:"사용", field:"QTYcostatus", editor:"input"},
    {title:"단가(Kg)", field:"kg", editor:"input"},
    {title:"가로", field:"sheet_w", editor:"input"},
    {title:"세로", field:"sheet_h", editor:"input"},
    {title:"두께", field:"sheet_t", editor:"input"},
    {title:"코일", field:"coil_cut", editor:"input"},
    {title:"수정자", field:"mename"},
    {title:"수정일", field:"QTYcoewdate"}
  ],

  cellEdited:function(cell){
    const row = cell.getRow().getData();

    apiSave(row).then(res=>{
      if(res.qtyco_idx){
        cell.getRow().update({qtyco_idx:res.qtyco_idx});
      }
    });
  },

  rowContextMenu:[
    {
      label:"삭제",
      action:function(e, row){
        if(confirm("삭제?")){
          apiDelete(row.getData().qtyco_idx);
          row.delete();
        }
      }
    }
  ]
});

});
