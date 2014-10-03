var k = angular.module("k", []);

k.controller("root_controller", [
  "$scope", "$http",
  function(scope, http) {
    http({url: "/projects"}).success(function(data) {
      scope.projects = data;
    });

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
        http({url: "/projects/" + project.id + "/builds"}).success(function(data) {
          project.builds = data;
        });
      }
    };
  }
]);