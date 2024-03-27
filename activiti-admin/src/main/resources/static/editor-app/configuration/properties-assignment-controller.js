/*
 * Activiti Modeler component part of the Activiti project
 * Copyright 2005-2014 Alfresco Software, Ltd. All rights reserved.
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

/*
 * Assignment
 */
var loginName = [];
var roleName= [];
var KisBpmAssignmentCtrl = [ '$scope', '$modal','$http', function($scope, $modal, $http) {
	console.log("KisBpmAssignmentCtrl运行")
    // Config for the modal window
    var opts = {
        template:  'editor-app/configuration/properties/assignment-popup.html?version=' + Date.now(),
        scope: $scope
    };
    $modal(opts);

}];

var KisBpmAssignmentPopupCtrl = [ '$scope', function($scope) {
	console.log("KisBpmAssignmentPopupCtrl运行")
	// 新增代码块
	// var loginName = [];
	// var roleName= [];
	jQuery.ajax({
		url: "/system/user/queryAll",
		type: "Get",
		success: function(data) {
			// data = jQuery.parseJSON(data);  //dataType指明了返回数据为json类型，故不需要再序列化
			console.log("queryAll成功")
			console.log(data)
			loginName = []
			for (let i = 0; i < data.length; i++) {
				loginName.push(data[i].loginName);
			}
			// select1();
			// select2();
			console.log(loginName);
			$scope.assignment.assignee = loginName[0];
			$scope.assignment.loginName1 = loginName;
			$scope.$apply();
		}
	});
	jQuery.ajax({
		url: "/system/role/list/all",
		type: "Get",
		success: function(data) {
			// data = jQuery.parseJSON(data);  //dataType指明了返回数据为json类型，故不需要再序列化
			console.log("all成功")
			console.log(data)
			roleName = []
			for (let i = 0; i < data.length; i++) {
				roleName.push(data[i].roleName);
			}
			console.log(roleName);
			// select3();
			$scope.assignment.roleName1 = roleName;
			$scope.$apply();

		}
	});

	// $scope.assignment.loginName = loginName;
	// $scope.assignment.roleName = roleName;
	// $scope.assignment.assignee = loginName[0];
	// $scope.assignment.loginName1 = loginName;
	console.log("$scope：",$scope)
	console.log("$scope.property：",$scope.property)



    // Put json representing assignment on scope
    if ($scope.property.value !== undefined && $scope.property.value !== null
        && $scope.property.value.assignment !== undefined
        && $scope.property.value.assignment !== null)
    {
		console.log("执行了")
        $scope.assignment = $scope.property.value.assignment;
    } else {
        $scope.assignment = {};
    }

    if ($scope.assignment.candidateUsers == undefined || $scope.assignment.candidateUsers.length == 0)
    {
    	$scope.assignment.candidateUsers = [{value: ''}];
    }

    // Click handler for + button after enum value
    var userValueIndex = 1;
    $scope.addCandidateUserValue = function(index) {
        $scope.assignment.candidateUsers.splice(index + 1, 0, {value: 'value ' + userValueIndex++});
    };

    // Click handler for - button after enum value
    $scope.removeCandidateUserValue = function(index) {
        $scope.assignment.candidateUsers.splice(index, 1);
    };

    if ($scope.assignment.candidateGroups == undefined || $scope.assignment.candidateGroups.length == 0)
    {
    	$scope.assignment.candidateGroups = [{value: ''}];
    }

    var groupValueIndex = 1;
    $scope.addCandidateGroupValue = function(index) {
        $scope.assignment.candidateGroups.splice(index + 1, 0, {value: 'value ' + groupValueIndex++});
	};

    // Click handler for - button after enum value
    $scope.removeCandidateGroupValue = function(index) {
        $scope.assignment.candidateGroups.splice(index, 1);

    };

    $scope.save = function() {
		console.log("save确定");
        $scope.property.value = {};
        handleAssignmentInput($scope);
        $scope.property.value.assignment = $scope.assignment;
		console.log($scope.assignment);
        $scope.updatePropertyInModel($scope.property);
        $scope.close();
    };

    // Close button handler
    $scope.close = function() {
		console.log("close关闭");
    	handleAssignmentInput($scope);
    	$scope.property.mode = 'read';
    	$scope.$hide();
    };

	// 清空下拉框
	$scope.cleanAss = function (){
		$scope.assignment.assignee =  '';
	}

	$scope.cleanCandidateUser = function (index){
		$scope.assignment.candidateUsers[index].value = '';
	}

	$scope.cleanCandidateGroup = function (index){
		$scope.assignment.candidateGroups[index].value = '';
	}

    var handleAssignmentInput = function($scope) {
    	if ($scope.assignment.candidateUsers)
    	{
	    	var emptyUsers = true;
	    	var toRemoveIndexes = [];
	        for (var i = 0; i < $scope.assignment.candidateUsers.length; i++)
	        {
	        	if ($scope.assignment.candidateUsers[i].value != '')
	        	{
	        		emptyUsers = false;
	        	}
	        	else
	        	{
	        		toRemoveIndexes[toRemoveIndexes.length] = i;
	        	}
	        }

	        for (var i = 0; i < toRemoveIndexes.length; i++)
	        {
	        	$scope.assignment.candidateUsers.splice(toRemoveIndexes[i], 1);
	        }

	        if (emptyUsers)
	        {
	        	$scope.assignment.candidateUsers = undefined;
	        }
    	}

    	if ($scope.assignment.candidateGroups)
    	{
	        var emptyGroups = true;
	        var toRemoveIndexes = [];
	        for (var i = 0; i < $scope.assignment.candidateGroups.length; i++)
	        {
	        	if ($scope.assignment.candidateGroups[i].value != '')
	        	{
	        		emptyGroups = false;
	        	}
	        	else
	        	{
	        		toRemoveIndexes[toRemoveIndexes.length] = i;
	        	}
	        }

	        for (var i = 0; i < toRemoveIndexes.length; i++)
	        {
	        	$scope.assignment.candidateGroups.splice(toRemoveIndexes[i], 1);
	        }

	        if (emptyGroups)
	        {
	        	$scope.assignment.candidateGroups = undefined;
	        }
    	}
    };

}];
