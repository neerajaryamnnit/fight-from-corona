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
            createIssue: function (data) {
                let deferred = $q.defer();
                let url = baseUrl + '/issues/create';
                $http({
                    data: data,
                    url: url,
                    method: "POST"
                }).then(function (data) {
                    deferred.resolve(data.data);
                }, function (data) {
                    deferred.resolve(data);
                });
                return deferred.promise;
            },
        }
    }])
    .controller("issueController", ["$scope", "toaster", "IssueService", function ($scope, toaster,  IssueService) {

        $scope.trustAsHtml = function (value) {
            return $sce.trustAsHtml(value);
        };

        $scope.option_categories = [];
        $scope.loading = false;
        $scope.tryAgain = false;
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
            },(error) => {
                console.log(error)
            })
        };
        $scope.createIssue = function(){

            if ($scope.selection.category == null){
                toaster.error({title: "Missing Option", body: "Looks like you have not selected the category"});
                return;
            }
            if (!$scope.selection.name || $scope.selection.name.length === 0 ){
                toaster.error({title: "Missing Name", body: "Please tell us your issue"});
                return;
            }
            if ($scope.selection.sub_category == null){
                toaster.error({title: "Missing Option", body: "Looks like you have not selected the sub category"});
                return;
            }

            $scope.loading = true;
            $scope.tryAgain = false;
            setTimeout(function () {
                IssueService.createIssue($scope.selection).then((data) => {
                    $scope.loading = false;
                    window.location.href = '/issues/list';
                },(error) => {
                    $scope.loading = false;
                    console.log(error)
                })
            }, 500);

        };
        $scope.init();
    }
    ]);