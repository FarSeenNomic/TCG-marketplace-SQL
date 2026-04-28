import os
import psycopg2

# Set your PostgreSQL URL here
DATABASE_URL = "postgresql://user:password@localhost:5432/dbname"

MIGRATIONS_DIR = "migrations"

def run_migrations():
    print("Connecting to database...")
    
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(DATABASE_URL)
        # Enable autocommit or use manual commit to ensure state is saved
        conn.autocommit = True
        cursor = conn.cursor()
        
        # Check if the migrations directory exists
        if not os.path.exists(MIGRATIONS_DIR):
            print(f"Error: Directory '{MIGRATIONS_DIR}' not found.")
            return

        # Get all .sql files from the migrations directory
        migration_files = [f for f in os.listdir(MIGRATIONS_DIR) if f.endswith('.sql')]
        # Sort files to ensure they run in alphabetical/numerical order (001_..., 002_...)
        migration_files.sort()

        if not migration_files:
            print("No migration files found in the migrations directory.")
            return

        for filename in migration_files:
            filepath = os.path.join(MIGRATIONS_DIR, filename)
            print(f"Reading migration file: {filename}")
            
            with open(filepath, 'r', encoding='utf-8') as file:
                sql_content = file.read()
                
            print(f"Executing {filename}...")
            try:
                # Execute the SQL commands in the file
                cursor.execute(sql_content)
                print(f"Successfully executed: {filename}\n")
            except Exception as e:
                print(f"Error while executing {filename}:")
                # When an error occurs, it's best to stop the deployment and address it
                raise e

    except psycopg2.Error as e:
        print(f"Database connection error: {e}")
    finally:
        if 'cursor' in locals() and cursor:
            cursor.close()
        if 'conn' in locals() and conn:
            conn.close()
        print("Migration process finished.")

if __name__ == '__main__':
    run_migrations()
