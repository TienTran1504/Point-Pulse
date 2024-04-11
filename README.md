# Point-Pulse

---

# How to Run Frontend and Backend

This is a guide on how to run both the Frontend and Backend of the Point-Pulse project.

## Backend (API)

### Step 1: Install Dependencies

Open a terminal and run the following command to install the backend dependencies:

```
mix deps.get
```

### Step 2: Configure the Database

Make sure you have configured the PostgreSQL database in the `config/dev.exs` file. Change the username, password, and database name if necessary.

### Step 3: Create and Migrate the Database

Run the following command to create and migrate the database:

```
mix ecto.setup
```

Or Run this command to reset all database

```
mix ecto.reset
```

### Step 4: Run the Server

Use the following command to run the server:

```
mix phx.server
```

The server will start on `http://localhost:4000`.

## Frontend

### Step 1: Navigate to the Frontend Directory

Open a terminal and navigate to the directory containing the frontend of the project:

```
cd client
```

### Step 2: Install Dependencies

Run the following command to install the frontend dependencies:

```
npm install
```

### Step 3: Run the Application

After installing the dependencies, use the following command to run the application:

```
npm start
```

The frontend application will start on `http://localhost:3000`.

## Conclusion

Now you know how to run both the Frontend and Backend of the Point-Pulse project. Enjoy the development journey! 🚀
