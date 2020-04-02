angular.module("controller.login", [])
    .controller("loginController", ["$scope", function ($scope) {
        $scope.showPhone = false;
        $scope.showOtp = false;
        $scope.isLoggedIn = false;
        $scope.currentLength = {
            "name": 0,
            "phone": 0,
            "otp": 0
        };
        $scope.user = {};
        $scope.init = function (isLoggedIn) {
            $scope.isLoggedIn = isLoggedIn
        };

        $scope.lengthCount = function (e, type) {
            $scope.currentLength[type] = $scope.user[type]? $scope.user[type].length : 0
        }

        $scope.formValidate = function (form) {
            return false;
        }
    }
    ]);