FROM jboss/wildfly

USER root

ENV JBOSS_BIND_ADDRESS 0.0.0.0
ENV KIE_REPOSITORY https://repository.jboss.org/nexus/content/groups/public-jboss
ENV KIE_VERSION 7.0.0.Final
ENV KIE_CLASSIFIER wildfly10
ENV KIE_CONTEXT_PATH jbpm-console
ENV JAVA_OPTS -Xms256m -Xmx512m -Djava.net.preferIPv4Stack=true
ENV KIE_SERVER_PROFILE standalone-full-jbpm
RUN $JBOSS_HOME/bin/add-user.sh admin test --silent
#RUN $JBOSS_HOME/bin/add-user.sh -a -u 'kie' -p 'test' -ro 'kie-server'

#ADD jbpm-app.ear $JBOSS_HOME/standalone/deployments/jbpm-app.ear

ADD jbpm-app.ear /root/jbpm-app.ear
RUN ls -l /root
RUN unzip -q /root/jbpm-app.ear -d $JBOSS_HOME/standalone/deployments/jbpm-app.ear
RUN touch $JBOSS_HOME/standalone/deployments/jbpm-app.ear.dodeploy
RUN rm -rf /root/jbpm-app.ear

ADD standalone-full-jbpm.xml $JBOSS_HOME/standalone/configuration/standalone-full-jbpm.xml
ADD jbpm-users.properties $JBOSS_HOME/standalone/configuration/jbpm-users.properties
ADD jbpm-roles.properties $JBOSS_HOME/standalone/configuration/jbpm-roles.properties
ADD start_jbpm-wb.sh $JBOSS_HOME/bin/start_jbpm-wb.sh

# Added files are chowned to root user, change it to the jboss one.
USER root
RUN chown jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full-jbpm.xml && \
chown jboss:jboss $JBOSS_HOME/standalone/configuration/jbpm-users.properties && \ 
chown jboss:jboss $JBOSS_HOME/standalone/configuration/jbpm-roles.properties

# Switchback to jboss user
USER jboss

####### RUNNING JBPM-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_jbpm-wb.sh"]

