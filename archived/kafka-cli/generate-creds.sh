cat <<EOF > client.properties
sasl.mechanism=SCRAM-SHA-512
security.protocol=SASL_SSL
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
  username="${KFK_USERNAME}" \
  password="${KFK_PASSWORD}";
EOF
