angular.module("controller.login", [])
    .factory("LoginService", ["$http", "$q", "$location", function ($http, $q, $location) {

        var baseUrl = $location.$$url;
        return {
            resend_otp: function (data) {
                let deferred = $q.defer();
                let url = baseUrl + '/resend_otp';
                $http({
                    data: data,
                    url: url,
                    method: "POST"
                }).then(function (data) {
                    deferred.resolve(data.data);
                }, function (data) {
                    deferred.reject(data.data);
                });
                return deferred.promise;
            },
        }
    }])
    .controller("loginController", ["$scope", "LoginService","BaseService", function ($scope, LoginService, BaseService) {
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
            if (isLoggedIn === "false"){
                $scope.isLoggedIn = false;
            }else{
                $scope.isLoggedIn = true;
            }
        };

        $scope.lengthCount = function (e, type) {
            $scope.currentLength[type] = $scope.user[type]? $scope.user[type].length : 0
        };

        $scope.formValidate = function (form) {
            return false;
        };

        $scope.resendOTP = function (phone, token, auth) {
            let data =  {
                phone: phone,
                token: token,
                authenticity_token: auth
            };
            LoginService.resend_otp(data).then(
                (result) => {
                    BaseService.success(result);
                },
                (error) => {
                    BaseService.error(error);
                }
            );
        }


    }
    ]);