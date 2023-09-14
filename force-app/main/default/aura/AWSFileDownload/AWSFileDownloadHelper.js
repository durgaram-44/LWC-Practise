({
    getS3File: function(component,event) {
        
   var action = component.get("c.getFileUrl");
    action.setParams({
      record: component.get("v.recordId")
    });
    action.setCallback(this, function(a) {
      var state = a.getState();
      if (state == "SUCCESS") {
        var url = a.getReturnValue();
        this.downloadFile(url);
      }
    });
    $A.enqueueAction(action);
    },
    downloadFile:function(url)
    {
        debugger;
        var isOpened = false;
        AWS.config.update({
            accessKeyId: "AKIAURBF7EJMUNB6MI7W", // Add Access Key
            secretAccessKey: "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", // Add Secret Key
            region_config: "us-east-1"
        });
        var s3 = new AWS.S3();
        var strFileUrl = url;
        if(strFileUrl != null && strFileUrl != ''){
            var keyindex = strFileUrl.lastIndexOf("/");
            var strKey = strFileUrl.substring(keyindex+1);
            var bcktindex = strFileUrl.indexOf("amazonaws.com/")+14;
            var strBucket = strFileUrl.substring(bcktindex,keyindex);
            strBucket = 'sfdcfileupload1';           
            s3.getSignedUrl('getObject', {Bucket: strBucket, Key: strKey}, function (err, url) {
            if (err){
                alert('error',err);
            }else{
                var xhrD;;
                if (window.XMLHttpRequest) {
                    xhrD = new XMLHttpRequest();
                }
                else {
                    xhrD = new ActiveXObject("Microsoft.XMLHTTP");
                }
                xhrD.open('get', url, true);
                
                function checkReadyState() {
                    if (xhrD.readyState === 4) {
                        if ((xhrD.status == 200) || (xhrD.status == 0)) {
                            if(! isOpened ) {
                                window.open(url,'_blank');
                                isOpened = true;
                            }
                        }else {
                            this.showToast('error','S3 File Does not exists in S3 Bucket');
                            return;
                        }
                    }
                }
                xhrD.onreadystatechange = checkReadyState;
                xhrD.send(null);
            }
        });
        }else{
            alert('error','Url is not available Please check');
        }
    }
})