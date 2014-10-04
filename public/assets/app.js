var k = angular.module("k", []);

k.controller("root_controller", [
  "$scope", "$http", "$interval",
  function(scope, http, interval) {

    scope.update_projects = function() {
      http({url: "/projects"}).success(function(data) {
        for (var i = 0; i < data.length; i++) {
          scope.update_project(data[i]);
        }
      });
    };

    scope.update_project_builds = function(project) {
      http({url: "/projects/" + project.id + "/builds"}).success(function(data) {
        project.builds = data;
      });
    };

    scope.update_build = function(build) {
      http({url: "/projects/" + build.project_id + "/builds/" + build.timestamp}).success(function(data) {
        angular.extend(build, data);
      });
    };

    scope.show_build = function(build) {
      scope.current_build = build;
    };

    scope.build_project = function(project) {
      http({url: "/projects/" + project.id + "/build"});
    };

    scope.load_project_builds = function(project) {
      if (project.builds) {
        project.builds = null;
      } else {
        scope.update_project_builds(project);
      }
    };

    scope.update_project = function(project) {
      if (!scope.projects) {scope.projects = {};}

      if (scope.projects[project.id]) {
        angular.extend(scope.projects[project.id], project);
      } else {
        scope.projects[project.id] = project;
      }
    };

    scope.update_all = function() {
      scope.update_projects();
    };

    scope.update_projects();
    interval(scope.update_all, 1000);
  }
]);