({
	handleTextChange : function(component, event, helper) {
        var x = $A.get('e.c:SearchKeyChange'); // var x= component.getEvent('searchevent');
        x.setParams({ "searchKey": event.target.value });
        x.fire();
        component.set("v.searchParameter", document.getElementById('searchText'));
	}
})