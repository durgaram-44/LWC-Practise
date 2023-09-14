({
  requestFiledata: function(component, event) {
    //**dataURL to blob**
    function dataURLtoBlob(dataurl) {
      var arr = dataurl.split(","),
        mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]),
        n = bstr.length,
        u8arr = new Uint8Array(n);
      while (n--) {
        u8arr[n] = bstr.charCodeAt(n);
      }
      return new Blob([u8arr], { type: mime });
    }

    //**blob to dataURL**
    function blobToDataURL(blob, callback) {
      var a = new FileReader();
      a.onload = function(e) {
        callback(e.target.result);
      };
      a.readAsDataURL(blob);
    }
    var action = component.get("c.GetS3FileUsingFileId");
    action.setParams({
      recordId: component.get("v.recordId")
    });
    action.setCallback(this, function(a) {
      var state = a.getState();
      if (state == "SUCCESS") {
        var res = a.getReturnValue();
        component.set('v.showFileLink',true);
        var blobData = "data:" + res.ContentType + ";base64," + res.Content;
        component.set("v.data", blobData);
      }
    });
    $A.enqueueAction(action);
  }
});