node {
      def app
	  stage('Clone repository'){
	     checkout scm
	  }
	  stage('Build Image'){
	   app=docker.build("proxy1506/poject1img")
      }
	  stage('Push Image'){
	    docker.withRegistry('https://registry.hub.docker.com','docker-hub') {
		app.push("${env.BUILD_NUMBER}")
		app.push("latest")
		}
	  }
}