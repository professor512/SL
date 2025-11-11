// Name: Karan Salunkhe
// Roll No: TEAD23173
// Class: TE AI & DS
// Practical No: 7
// Title: MySQL Database Connectivity using JDBC
// Filename: student.java

import java.awt.*;
import java.awt.event.*;
import java.sql.*;
import javax.swing.*;

public class student extends JFrame implements ActionListener {
    JFrame f;
    JLabel l1, l2, l3, l4;
    JTextField t1, t2, t3;
    JButton b1, b2, b3, b5;
    Connection c;
    Statement s;
    ResultSet r;

    student() {
        try {
            // Frame setup
            f = new JFrame("Student Management System");
            f.setLayout(null);
            f.setVisible(true);
            f.setSize(700, 500);

            l4 = new JLabel("Student Management System");
            l4.setBounds(150, 30, 400, 30);
            l4.setForeground(Color.blue);
            l4.setFont(new Font("Serif", Font.BOLD, 30));
            f.add(l4);

            // Labels
            l1 = new JLabel("Stud_RollNo");
            l1.setBounds(50, 100, 100, 30);
            f.add(l1);

            l2 = new JLabel("Stud_Name");
            l2.setBounds(50, 150, 100, 30);
            f.add(l2);

            l3 = new JLabel("Stud_Dept");
            l3.setBounds(50, 200, 100, 30);
            f.add(l3);

            // Text fields
            t1 = new JTextField();
            t1.setBounds(150, 100, 100, 30);
            f.add(t1);

            t2 = new JTextField();
            t2.setBounds(150, 150, 100, 30);
            f.add(t2);

            t3 = new JTextField();
            t3.setBounds(150, 200, 100, 30);
            f.add(t3);

            // Buttons
            b1 = new JButton("ADD");
            b1.setBounds(200, 300, 75, 50);
            f.add(b1);
            b1.addActionListener(this);

            b2 = new JButton("EDIT");
            b2.setBounds(300, 300, 75, 50);
            f.add(b2);
            b2.addActionListener(this);

            b3 = new JButton("DELETE");
            b3.setBounds(400, 300, 100, 50);
            f.add(b3);
            b3.addActionListener(this);

            b5 = new JButton("EXIT");
            b5.setBounds(520, 300, 75, 50);
            f.add(b5);
            b5.addActionListener(this);

            // Database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            c = DriverManager.getConnection("jdbc:mysql://localhost:3306/info", "root", "root");
            s = c.createStatement();

        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Action events for buttons
    public void actionPerformed(ActionEvent ae) {
        try {
            if (ae.getSource() == b1) {
                // Add new record
                String s1 = "INSERT INTO result(stud_RollNo, stud_Name, stud_Dept) VALUES(" +
                        t1.getText() + ", '" + t2.getText() + "', '" + t3.getText() + "')";
                s.executeUpdate(s1);
                JOptionPane.showMessageDialog(f, "Record Added Successfully!");
            } else if (ae.getSource() == b2) {
                // Edit record
                String s2 = "UPDATE result SET stud_Name='" + t2.getText() + "', stud_Dept='" + t3.getText() +
                        "' WHERE stud_RollNo=" + t1.getText();
                s.executeUpdate(s2);
                JOptionPane.showMessageDialog(f, "Record Updated Successfully!");
            } else if (ae.getSource() == b3) {
                // Delete record
                String s3 = "DELETE FROM result WHERE stud_RollNo=" + t1.getText();
                s.executeUpdate(s3);
                JOptionPane.showMessageDialog(f, "Record Deleted Successfully!");
            } else if (ae.getSource() == b5) {
                System.exit(0);
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(f, "Error: " + e.getMessage());
        }
    }

    public static void main(String args[]) {
        new student();
    }
}
