({
    openModal: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    closeModal: function(component, event, helper) {
        alert('here in parent');
        component.set("v.isOpen", false);
    }
})