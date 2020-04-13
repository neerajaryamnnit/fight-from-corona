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
    .controller("dashboardController",["$scope", "toaster", "IssueService","dashboardService", "BaseService" ,function ($scope, toaster, IssueService,dashboardService,BaseService){
        $scope.option_category = [];
        $scope.sub_categories = [];
        $scope.selection = {};
        $scope.issues = [];
        $scope.page = 1;
        $scope.offset = 0;
        $scope.limit = 4;
        $scope.length;


        $scope.onCategoryChange = function () {
            console.log($scope.selection.category);
            IssueService.sub_categories($scope.selection.category).then((data) => {
                $scope.sub_categories = data.data;
            }, (error) => {
                BaseService.error(error)
            })
        };

        $scope.get_category = function(id){
            for (let category of $scope.option_category){
                if( category.id === id)
                {
                    return category.name;
                    break;
                }
            }
        };

        $scope.init = function () {
            console.log("here")
            IssueService.categories().then((data) => {
                console.log("working",data.data)
                $scope.option_category = data.data;
            }, (error) => {
                BaseService.error(error)
            })
        };

        $scope.clear = function(){
            window.location.reload();
        }

        $scope.getIssues = function () {
            dashboardService.getIssues($scope.selection).then((data) => {
            console.log($scope.selection,"this is sent");
            $scope.issues = data.data;
             console.log($scope.issues,"Received");
            }, (error) => {
                BaseService.error(error)
        })};

        $scope.next = function () {
            $scope.offset = $scope.offset+4;
            if ($scope.offset < $scope.length)
            {
            $scope.page = $scope.page + 1;
            $scope.getIssues();
            }
            else{
                toaster.error({title: "No More Data", body: "Can not go forward"})
            }
        };

        $scope.prev = function () {
            if ($scope.offset >> 0){
                $scope.offset = $scope.offset - 4;
                $scope.page = $scope.page-1;
                $scope.getIssues();
            }
            else {
                toaster.error({title: "No More Data", body: "Can not go back"})
            }

        };

        $scope.init();

    }]);