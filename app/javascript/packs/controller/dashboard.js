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
        $scope.option_category = [];
        $scope.sub_categories = [];
        $scope.selection = {};
        $scope.issues = [];
        $scope.page = 1;
        $scope.offset = 0;
        $scope.limit = 3;
        $scope.length;
        $scope.download_obj;


        $scope.onCategoryChange = function () {
            console.log($scope.selection.category);
            IssueService.sub_categories($scope.selection.category).then((data) => {
                $scope.sub_categories = data.data;
            }, (error) => {
                toaster.error(error)
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
            IssueService.categories().then((data) => {
                $scope.option_category = data.data;
            }, (error) => {
                toaster.error(error)
            })
        };

        $scope.clear = function(){
            window.location.reload();
        }

        $scope.getIssues = function () {
            dashboardService.getIssues(angular.merge({offset:$scope.offset,limit:$scope.limit},$scope.selection)).then((data) => {
            $scope.issues = data.data;
            $scope.length = data.length;
            }, (error) => {
            toaster.error(error);
        })};

        $scope.next = function () {

            if ($scope.offset+3 < $scope.length)
            {$scope.offset = $scope.offset+3;
            $scope.page = $scope.page + 1;
            $scope.getIssues();
            }
            else{
                toaster.error({title: "No More Data", body: "Can not go forward"})
            }
        };

        $scope.prev = function () {
            if ($scope.offset >> 0){
                $scope.offset = $scope.offset - 3;
                $scope.page = $scope.page-1;
                $scope.getIssues();
            }
            else {
                toaster.error({title: "No More Data", body: "Can not go back"})
            }

        };

        $scope.download = function () {
            dashboardService.getIssues(angular.merge({csv: true},$scope.selection)).then((data) => {
                $scope.download_obj = data.data;
                console.log($scope.download_obj);
                let blob = new Blob([$scope.download_obj], {type: 'text/csv'});
                let url = window.URL || window.webkitURL;
                let fileUrl = url.createObjectURL(blob);
                let element = document.createElement('a');
                element.href = fileUrl;
                element.setAttribute('download', 'issues.csv');
                element.click();
            }, (error) => {
                toaster.error({title:"Failed",data: "Unable to Download CSV"});
            })
        };
        $scope.init();

    }]);