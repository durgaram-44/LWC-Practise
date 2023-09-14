({
	getFile : function(component, event, helper) {
        helper.getS3File(component, event);
	},
    doInit: function(component, event, helper) {
        console.log('SDK loaded');
    }
})