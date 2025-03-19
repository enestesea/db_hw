WITH RECURSIVE Subordinates AS (
    SELECT 
        EmployeeID, 
        Name, 
        ManagerID, 
        DepartmentID, 
        RoleID
    FROM 
        Employees
    WHERE 
        RoleID = 1  
    UNION ALL
    SELECT 
        e.EmployeeID, 
        e.Name, 
        e.ManagerID, 
        e.DepartmentID, 
        e.RoleID
    FROM 
        Employees e
    INNER JOIN 
        Subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT 
    s.EmployeeID AS "Employee ID",
    s.Name AS "Employee Name",
    s.ManagerID AS "Manager ID",
    COALESCE(d.DepartmentName, 'NULL') AS "Department Name", 
    COALESCE(r.RoleName, 'NULL') AS "Role Name",              
    COALESCE((
        SELECT STRING_AGG(p.ProjectName, ', ') 
        FROM Projects p 
        WHERE p.DepartmentID = s.DepartmentID
    ), 'NULL') AS "Project Names",                             
    COALESCE((
        SELECT STRING_AGG(t.TaskName, ', ') 
        FROM Tasks t 
        WHERE t.AssignedTo = s.EmployeeID
    ), 'NULL') AS "Task Names", 
    (SELECT COUNT(*) 
     FROM Employees e 
     WHERE e.ManagerID = s.EmployeeID) AS "Total Subordinates"
FROM 
    Subordinates s
LEFT JOIN 
    Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN 
    Roles r ON s.RoleID = r.RoleID
WHERE 
    (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = s.EmployeeID) > 0 
ORDER BY 
    s.Name;
