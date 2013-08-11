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
  a. Click 'Enable Security'
  b. Under 'Security Realm', check 'Jenkins’s own user database'.
  c. Under 'Authorization', check 'Logged-in users can do anything'.
  d. Click the 'Save' button.
8. Click on the 'Create an Account' link
  a. If you have an ssh public/private key:
    i. After creating your account, login, and click on your username link in the upper right corner.
    ii. Click on 'Configure'
    iii. Paste your public key under the 'SSH Public Keys', and click the 'Save' button.
9. Configure JDK:
  Manage Jenkins | Configure System
  a. Global Properties
    i. Check 'Environment variables'
      a. key: PATH
      b. value: /sbin:/usr/sbin:/bin:/usr/bin
    ii. Check 'Prepare jobs environment', check 'Unset System Environment Variables'

  b. JDK
     i. click 'Add JDK'
        a. Name: Oracle JDK 7
        b. uncheck install automatically
        c. JAVA_HOME: /path/to/oracle7jdk
     ii. Setup any other additinal JDKs you wish to compile and/or test with.

10. Download the jenkins-cli.jar
  a. wget -q http://localhost:8080/jnlpJars/jenkins-cli.jar

11. Install plugins
  a. CLI="java -jar jenkins-cli.jar -s http://localhost:8080/"
  b. $CLI login
  c. $CLI install-plugin analysis-core
  d. $CLI install-plugin analysis-collector
  e. $CLI install-plugin build-failure-analyzer
  f. $CLI install-plugin checkstyle
  g. $CLI install-plugin envinject
  h. $CLI install-plugin findbugs
  i. $CLI install-plugin pmd
  j. $CLI install-plugin git-client
  k. $CLI install-plugin git
  l. $CLI install-plugin parameterized-trigger
  m. $CLI install-plugin shared-objects
  n. $CLI install-plugin violations
  o. $CLI install-plugin warnings
  p. $CLI restart

11. Setup Jobs
  a. $CLI create-job OpenNMS < jobs/OpenNMS.xml
  b. $CLI create-job OPENNMS-MASTER-COMPILE < jobs/OPENNMS-MASTER-COMPILE.xml
  c. $CLI create-job OPENNMS-MASTER-CODEREVIEW < jobs/OPENNMS-MASTER-CODEREVIEW.xml
  d. $CLI create-job OPENNMS-MASTER-TEST < jobs/OPENNMS-MASTER-TEST.xml
  e. $CLI create-job OPENNMS-MASTER-JAVADOC < jobs/OPENNMS-MASTER-JAVADOC.xml

12. Configure the 'OpenNMS' job
  1. Under Configuration Matrix
     b. Choose the 'JDK' option under the 'Add axis', and enable the JDKs you have added on the system.

13. If you don't want to run any code review jobs, then edit the OpenNMS job
    and delete the triggered job.
