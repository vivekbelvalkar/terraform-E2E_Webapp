package com.ems.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.secretsmanager.*;
import software.amazon.awssdk.services.secretsmanager.model.*;

import java.nio.charset.StandardCharsets;
import java.sql.*;
import org.json.JSONObject;

public class DbBootstrapHandler implements RequestHandler<Object, String> {

    @Override
    public String handleRequest(Object input, Context context) {
        try {
            SecretsManagerClient client = SecretsManagerClient.create();

            String secretArn = System.getenv("DB_MASTER_SECRET_ARN");
            
            String appUser   = System.getenv("APP_DB_USER");
            String appPass   = System.getenv("APP_DB_PASS");
            String dbName    = System.getenv("DB_NAME");
            String host = System.getenv("DB_HOST");
            String port = System.getenv("DB_PORT");
            String bucket = System.getenv("SQL_BUCKET");
            String sql_key    = System.getenv("SQL_KEY");

            GetSecretValueResponse secret =
                    client.getSecretValue(GetSecretValueRequest.builder()
                            .secretId(secretArn)
                            .build());

            JSONObject json = new JSONObject(secret.secretString());

            String user = json.getString("username");
            String pass = json.getString("password");

            String jdbcUrl = "jdbc:mysql://" + host + ":" + port + "/";

            Connection conn = DriverManager.getConnection(jdbcUrl, user, pass);
            Statement stmt = conn.createStatement();

            stmt.execute("CREATE DATABASE IF NOT EXISTS " + dbName);
            stmt.execute("CREATE USER IF NOT EXISTS '" + appUser + "'@'%' IDENTIFIED BY '" + appPass + "'");
            stmt.execute("GRANT ALL PRIVILEGES ON " + dbName + ".* TO '" + appUser + "'@'%'");
            stmt.execute("FLUSH PRIVILEGES");

            stmt.close();

            S3Client s3 = S3Client.create();

            GetObjectRequest request = GetObjectRequest.builder()
                .bucket(bucket)
                .key(sql_key)
                .build();

            ResponseInputStream<GetObjectResponse> s3Object = s3.getObject(request);

            String sql = new String(s3Object.readAllBytes(), StandardCharsets.UTF_8);

            String[] statements = sql.split(";");

            Statement statement = conn.createStatement();

            for (String stmts : statements) {
                if (!stmts.trim().isEmpty()) {
                statement.execute(stmts);
                }
            }

            statement.close();

            conn.close();

            return "DB bootstrap successful";

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
