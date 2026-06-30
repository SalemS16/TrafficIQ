<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Junction</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
</head>

<body>

<div class="container mt-5">

    <h2 class="text-center mb-4">
        🚦 Add New Junction
    </h2>

    <form action="addJunction" method="post">

        <div class="mb-3">
            <label class="form-label">Junction Name</label>
            <input type="text"
                   name="junctionName"
                   class="form-control"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Area</label>
            <input type="text"
                   name="area"
                   class="form-control"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Total Lanes</label>
            <input type="number"
                   name="totalLanes"
                   class="form-control"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Status</label>

            <select name="status"
                    class="form-select">

                <option value="ACTIVE">
                    ACTIVE
                </option>

                <option value="INACTIVE">
                    INACTIVE
                </option>

            </select>
        </div>

        <button class="btn btn-success">
            Save Junction
        </button>

        <a href="junctions"
           class="btn btn-secondary">
            Cancel
        </a>

    </form>

</div>

</body>
</html>