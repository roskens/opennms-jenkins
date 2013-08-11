OpenNMS Continuous Integration
==============================

See also [OpenNMS Continuous Integration](http://www.opennms.org/wiki/Continuous_integration).


Prerequisites / Recommendations
===============================
1. Install and configure a Maven proxy (Nexus or Artifactory)
   * [Sonatype Nexus](http://www.sonatype.org/nexus/go)
   * [OpenNMS Nexus Configuration](https://github.com/OpenNMS/opennms-nexus)

   Each CI job that runs will clean out running users maven repository
   (~/.m2/repository) as part of the cleanup at the start of the job. Also,
   the jobs are configured to have the maven repository inside the workspace,
   and those will be removed as part of a 'git clean -fdx' as part of the
   shell command. Having a local proxy will also help save network traffic,
   and speed up the builds.

2. Setup a local git repository clone of OpenNMS.

   Each CI job that runs will have its own checked out copy of the source repository. Having a local copy
   of the repository will help save netowrk traffic and speed up the builds.

3. [SonarQube ](http://www.sonarqube.org/)

   The OPENNMS-MASTER-CODEREVIEW job will run checkstyle, findbugs, pmd, and
   SonarQube analysis' against the workspace. If you are going to be running
   the SonarQube analysis long term, setup a local postgresql/mysql database
   to store its data in.

Jenkins / Hudson Setup
======================
1. Install Jenkins from http://jenkins-ci.org/, or Hudson from http://hudson-ci.org/
2. http://localhost:8080/
3. Click 'Manage Jenkins'
4. Click 'Manage Plugins'
5. Select all plugins with updates, and click 'Install without restart' button.
6. After all plugins have downloaded, click the checkbox to 'Restart Jenkins when installation is complete and no jobs are running'.
7. Manage Plugins | Setup Security
   1. Click 'Enable Security'
   2. Under 'Security Realm', check 'Jenkins’s own user database'.
   3. Under 'Authorization', check 'Logged-in users can do anything'.
   4. Click the 'Save' button.
8. Click on the 'Create an Account' link
   1. If you have an ssh public/private key:
      1. After creating your account, login, and click on your username link in the upper right corner.
      2. Click on 'Configure'
      3. Paste your public key under the 'SSH Public Keys', and click the 'Save' button.
9. Configure JDK:
   Manage Jenkins | Configure System
   1. Global Properties
      1. Check 'Environment variables'
         1. key: PATH
         2. value: /sbin:/usr/sbin:/bin:/usr/bin
      2. Check 'Prepare jobs environment', check 'Unset System Environment Variables'
   2. JDK
      1. click 'Add JDK'
         1. Name: Oracle JDK 7
         2. uncheck install automatically
         3. JAVA_HOME: /path/to/oracle7jdk
      2. Setup any other additinal JDKs you wish to compile and/or test with.
10. Download the jenkins-cli.jar
   1. wget -q http://localhost:8080/jnlpJars/jenkins-cli.jar

11. Install plugins (script: setup.sh)
   1. CLI="java -jar jenkins-cli.jar -s http://localhost:8080/"
   2. $CLI login
   3. $CLI install-plugin analysis-core
   4. $CLI install-plugin analysis-collector
   5. $CLI install-plugin build-failure-analyzer
   6. $CLI install-plugin checkstyle
   7. $CLI install-plugin envinject
   8. $CLI install-plugin findbugs
   9. $CLI install-plugin pmd
   10. $CLI install-plugin git-client
   11. $CLI install-plugin git
   12. $CLI install-plugin parameterized-trigger
   13. $CLI install-plugin shared-objects
   14. $CLI install-plugin violations
   15. $CLI install-plugin warnings
   16. $CLI restart

11. Setup Jobs (script: setup_jobs.sh)
   1. $CLI create-job OpenNMS < jobs/OpenNMS.xml
   2. $CLI create-job OPENNMS-MASTER-COMPILE < jobs/OPENNMS-MASTER-COMPILE.xml
   3. $CLI create-job OPENNMS-MASTER-CODEREVIEW < jobs/OPENNMS-MASTER-CODEREVIEW.xml
   4. $CLI create-job OPENNMS-MASTER-TEST < jobs/OPENNMS-MASTER-TEST.xml
   5. $CLI create-job OPENNMS-MASTER-JAVADOC < jobs/OPENNMS-MASTER-JAVADOC.xml

12. Configure the 'OpenNMS' job
   1. Under Configuration Matrix
      1. Choose the 'JDK' option under the 'Add axis', and enable the JDKs you have added on the system.

13. If you don't want to run any code review jobs, then edit the OpenNMS job and delete the triggered job.
