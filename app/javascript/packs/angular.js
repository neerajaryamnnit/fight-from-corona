app = angular.module("FightWithCoronaApp", [
    "controller.login",
    "controller.issue",
    "controller.dashboard",
    "ngMaterial",
    "ngMessages",
    "ngSanitize",
    "ui.select",
    "toaster"
]);
app.factory("BaseService", [ "$http", "toaster", function ($http, toaster) {

    return {
        success: function(data) {
            toaster.success({title: data.title, body: data.message})
        },
        error: function(data) {
            toaster.error({title: data.title, body: data.message})
        },
        warning: function(data) {
            toaster.warning({title: data.title, body: data.message})
        },
        info: function(data) {
            toaster.info({title: data.title, body: data.message})
        },
        errorMessage: "We not able to service your request this time Error: "
    }

}
]);
app.filter("optionFilter", function () {
    return function(items, props) {
        var out = [];

        if (angular.isArray(items)) {
            var keys = Object.keys(props);

            items.forEach(function(item) {
                var itemMatches = false;

                for (var i = 0; i < keys.length; i++) {
                    var prop = keys[i];
                    var text = props[prop].toLowerCase();
                    if (item[prop].toString().toLowerCase().indexOf(text) !== -1) {
                        itemMatches = true;
                        break;
                    }
                }

                if (itemMatches) {
                    out.push(item);
                }
            });
        } else {
            // Let the output be the input untouched
            out = items;
        }

        return out;
    };
});