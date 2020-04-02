angular.module("controller.issue", [])
    .factory('IssueService', ["$http", "$q", "$location", function ($http, $q, $location) {
        var baseUrl = $location.$$url;
        return {
            categories: function () {
                let deferred = $q.defer();
                let url = baseUrl + '/issues/categories';
                $http({
                    url: url,
                    method: "GET"
                }).then(function (data) {
                    deferred.resolve(data.data);
                }, function (data) {
                    deferred.resolve(data);
                });
                return deferred.promise;
            },
            sub_categories: function (id) {
                let deferred = $q.defer();
                let url = baseUrl + '/issues/sub_categories?category_id='+ id;
                $http({
                    url: url,
                    method: "GET"
                }).then(function (data) {
                    deferred.resolve(data.data);
                }, function (data) {
                    deferred.resolve(data);
                });
                return deferred.promise;
            },
        }
    }])
    .controller("issueController", ["$scope", "IssueService", function ($scope, IssueService) {

        $scope.option_categories = [];
        $scope.sub_categories = [];
        $scope.selection = {
        };
        $scope.itemArray = [
            {id: 1, name: 'first'},
            {id: 2, name: 'second'},
            {id: 3, name: 'third'},
            {id: 4, name: 'fourth'},
            {id: 5, name: 'fifth'},
        ];

        $scope.category_select = function(category ){
            IssueService.sub_categories(category.id).then((data) => {
                $scope.sub_categories = data;
            }, (error) => {
                console.log(error)
            })
        };

        $scope.init = function () {
            IssueService.categories().then((data) => {
                $scope.option_categories = data.data;
                console.log($scope.option_categories);
            },(error) => {
                console.log(error)
            })
        };
        $scope.init();
    }
    ]);