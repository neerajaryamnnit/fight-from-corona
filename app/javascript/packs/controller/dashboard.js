angular.module("controller.dashboard", [])
    .factory('dashboardService',["$http", "$q", "$location", function ($http, $q, $location) {
        var baseUrl = $location.$$url;
        return{
            getIssues: function (filters) {
                let deferred = $q.defer();
                let url = baseUrl + '/issues/getIssues';
                $http({
                    data: filters,
                    url: url,
                    method: "POST"
                }).then(function (data) {
                    deferred.resolve(data.data);
                }, function (data) {
                    deferred.reject(data);
                });
                return deferred.promise;

            }
        }

    }])
    .controller("dashboardController",["$scope", "toaster", "IssueService","dashboardService" ,function ($scope, toaster, IssueService,dashboardService){
        $scope.optionCategory = [];
        $scope.sub_categories = [];
        $scope.selection = {};
        $scope.issues = [];

        $scope.onCategoryChange = function () {
            console.log($scope.selection.category);
            IssueService.sub_categories($scope.selection.category).then((data) => {
                $scope.sub_categories = data.data;
            }, (error) => {
                console.log(error)
            })
        };
        $scope.init = function () {
            IssueService.categories().then((data) => {
                $scope.optionCategory = data.data;
            }, (error) => {
                console.log(error)
            })
        };

        $scope.getIssues = function () {
            dashboardService.getIssues($scope.selection).then((data) => {
            console.log($scope.selection,"this is sent");
            $scope.issues = data.data;
             console.log($scope.issues,"Received");
            }, (error) => {
            console.log(error)
        })};
        $scope.init();

    }]);