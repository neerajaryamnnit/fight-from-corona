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
                    deferred.reject(data);
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
    .controller("issueController", ["$scope", "$sce", "IssueService", function ($scope,$sce, IssueService) {

        $scope.trustAsHtml = function (value) {
            return $sce.trustAsHtml(value);
        };
        $scope.option_categories = [];
        $scope.sub_categories = [];
        $scope.selection = {
        };

        $scope.onCategoryChange = function() {
            console.log($scope.selection.category);
            IssueService.sub_categories($scope.selection.category).then((data) => {
                $scope.sub_categories = data.data;
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