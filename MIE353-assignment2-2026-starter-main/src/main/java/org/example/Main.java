package org.example;

// General Helper Imports
import manifold.sql.rt.api.Dependencies.*;
import java.sql.SQLException;
import java.util.List;
import static java.lang.System.out;
import java.nio.file.*;


// Import all defined queries
import org.example.queries.*;

// Import schema classes
import org.example.schema.CMS;
import org.example.schema.CMS.*;

//Observations/Pipeline
//CMS -> cms-ddl.sql -> creates the schema, has the 5 tables + primary and foreign keys for each
//The example queries are run via java methods in Main.java, but each individual query is written in SQL
//1. Run maven from project directory with JDK21
//Maven reads pom.xml to compile the project and enable Manifold. Manifold allows Java to call the SQL query files.
//2. Maven launches in Main.java and loads the CMS data using loadCMSData()
//This loads the 5 CSV files into DuckDB database, creating the tables and populating them with data
//DuckDB - in memory database that actually executes SQL, Java just calls the method that rusn the query
//3. Java saves a CSV file writes results to data file so that the manipulated table can be accessed 

public class Main {
    public static void main(String[] args) {

      try {
        // Load in all the data from CSV files in to in-memory DuckDB
        loadCMSData();

        // Example: fetch a student by ID and print their email
        Student s = Student.fetch(9002);
        out.println(s.getEmail());
        // Example: fetch the same student using a parameterized SQL query
        //Runs the FindStudent query in FindStudent.sql - queries aren't written here directly in the Main.java
        Student s2 = FindStudent.fetchOne(9002);
        out.println(s2.getEmail());

        //Example: saving a table to CSV
        CMS.addSqlChange(ctx -> {
          SaveStudents.execute(ctx);
        });
        CMS.commit();

        saveGradCourses();
        
        // EXTRA MAIN FUNCTION CALLS CAN GO BELOW:


        
      }
      catch (Exception e) {
        e.printStackTrace();
      }


  }

  public static void loadCMSData() throws SQLException {
    loadStudentData();
    loadProfessorData();
    loadCourseData();
    loadTranscriptData();
    loadTeachesData(); //Addition: actually run the SQL file after professors and courses are loaded because of foreign keys
    //without this additional call the sql file never runs
  }

  public static void loadStudentData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadStudents.execute(ctx);
    });
    CMS.commit();
  }

  public static void loadProfessorData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadProfessors.execute(ctx);
    });
    CMS.commit();
  }

  public static void loadCourseData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadCourses.execute(ctx);
    });
    CMS.commit();
  }

  public static void saveGradCourses() throws SQLException {
    CMS.addSqlChange(ctx -> {
      SaveGradCourses.execute(ctx);
    });
    CMS.commit();
  }

  public static void loadTranscriptData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadTranscript.execute(ctx);
    });
    CMS.commit();
  }

  // Loads teaches.csv (which professor teaches which course) into the teaches table
  public static void loadTeachesData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadTeaches.execute(ctx);
    });
    CMS.commit();
  }
}