// -- =========================================================

// -- Name: Karan Salunkhe
// -- Roll No: TEAD23173
// -- Class: TE AI & DS
// -- Practical No: 3
// -- Title: MongoDB Queries using CRUD operations.

// -- =========================================================

// use DYPIEMR


//-----------------------------------------------
// 2️⃣ Create Collections and Insert Sample Data
//-----------------------------------------------
db.createCollection("Teachers")
db.createCollection("Students")

db.Teachers.insertMany([
  { Tname: "Praveen", dno: 1, dname: "COMP", experience: 8, salary: 12000, date_of_joining: "2017-05-12" },
  { Tname: "Sneha", dno: 2, dname: "IT", experience: 5, salary: 9500, date_of_joining: "2019-06-20" },
  { Tname: "Rahul", dno: 3, dname: "E&TC", experience: 7, salary: 11000, date_of_joining: "2018-01-10" },
  { Tname: "Aarti", dno: 4, dname: "COMP", experience: 10, salary: 15000, date_of_joining: "2015-03-18" }
])

db.Students.insertMany([
  { Sname: "Karan", roll_no: 1, class: "TE" },
  { Sname: "XYZ", roll_no: 2, class: "BE" },
  { Sname: "Rohit", roll_no: 3, class: "SE" }
])


//-----------------------------------------------
// 3️⃣ Find the information about all teachers
//-----------------------------------------------
db.Teachers.find().pretty()


//-----------------------------------------------
// 4️⃣ Find the information about all teachers of computer department
//-----------------------------------------------
db.Teachers.find({ dname: "COMP" }).pretty()


//-----------------------------------------------
// 5️⃣ Find the information about all teachers of computer, IT, and E&TC department
//-----------------------------------------------
db.Teachers.find({ dname: { $in: ["COMP", "IT", "E&TC"] } }).pretty()


//-----------------------------------------------
// 6️⃣ Find teachers of computer, IT, and E&TC dept having salary ≥ 10000
//-----------------------------------------------
db.Teachers.find({
  dname: { $in: ["COMP", "IT", "E&TC"] },
  salary: { $gte: 10000 }
}).pretty()


//-----------------------------------------------
// 7️⃣ Find student info having roll_no = 2 OR Sname = 'xyz'
//-----------------------------------------------
db.Students.find({
  $or: [{ roll_no: 2 }, { Sname: "xyz" }]
}).pretty()


//-----------------------------------------------
// 8️⃣ Update experience of teacher 'Praveen' to 10 years
// If not present, insert as new entry (upsert)
//-----------------------------------------------
db.Teachers.updateOne(
  { Tname: "Praveen" },
  { $set: { experience: 10 } },
  { upsert: true }
)


//-----------------------------------------------
// 9️⃣ Update department of all teachers in IT dept to COMP
//-----------------------------------------------
db.Teachers.updateMany(
  { dname: "IT" },
  { $set: { dname: "COMP" } }
)


//-----------------------------------------------
// 🔟 Find teacher name and experience only
//-----------------------------------------------
db.Teachers.find(
  {},
  { _id: 0, Tname: 1, experience: 1 }
).pretty()


//-----------------------------------------------
// 1️⃣1️⃣ Insert one entry in Department collection using save()
//-----------------------------------------------
db.createCollection("Department")

db.Department.save({
  dno: 5,
  dname: "Mechanical",
  hod: "Vikas"
})


//-----------------------------------------------
// 1️⃣2️⃣ Change department of teacher 'Praveen' to IT using save()
//-----------------------------------------------
var t = db.Teachers.findOne({ Tname: "Praveen" })
t.dname = "IT"
db.Teachers.save(t)


//-----------------------------------------------
// 1️⃣3️⃣ Delete all teachers having IT dept
//-----------------------------------------------
db.Teachers.deleteMany({ dname: "IT" })


//-----------------------------------------------
// 1️⃣4️⃣ Display first 3 documents in ascending order with pretty()
//-----------------------------------------------
db.Teachers.find().sort({ Tname: 1 }).limit(3).pretty()
