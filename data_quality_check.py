"""A small data-quality checker using only Python's standard library."""

import csv
from pathlib import Path

REQUIRED_COLUMNS = {"customer_id", "customer_name", "email", "order_amount"}


def validate_csv(file_path: str) -> dict:
    path = Path(file_path)
    if not path.exists():
        raise FileNotFoundError(f"Input file not found: {path}")

    with path.open("r", newline="", encoding="utf-8") as file:
        reader = csv.DictReader(file)
        columns = set(reader.fieldnames or [])
        missing_columns = sorted(REQUIRED_COLUMNS - columns)

        if missing_columns:
            return {
                "rows_checked": 0,
                "missing_columns": missing_columns,
                "invalid_rows": [],
            }

        invalid_rows = []
        rows_checked = 0

        for row_number, row in enumerate(reader, start=2):
            rows_checked += 1
            problems = []

            if not row["customer_id"].strip():
                problems.append("missing customer_id")
            if not row["customer_name"].strip():
                problems.append("missing customer_name")
            if "@" not in row["email"] or "." not in row["email"].split("@")[-1]:
                problems.append("invalid email")
            try:
                amount = float(row["order_amount"])
                if amount < 0:
                    problems.append("negative order_amount")
            except (TypeError, ValueError):
                problems.append("order_amount is not numeric")

            if problems:
                invalid_rows.append({
                    "row": row_number,
                    "problems": problems,
                })

    return {
        "rows_checked": rows_checked,
        "missing_columns": [],
        "invalid_rows": invalid_rows,
    }


if __name__ == "__main__":
    # Create a small sample input so the script can be tested immediately.
    sample = Path("sample_customers.csv")
    if not sample.exists():
        with sample.open("w", newline="", encoding="utf-8") as file:
            writer = csv.writer(file)
            writer.writerow(["customer_id", "customer_name", "email", "order_amount"])
            writer.writerow([1, "Aarav Sharma", "aarav@example.com", 1250.50])
            writer.writerow([2, "Meera Patel", "invalid-email", 800])
            writer.writerow([3, "", "isha@example.com", -25])

    report = validate_csv(str(sample))
    print("Data quality report")
    print(f"Rows checked: {report['rows_checked']}")
    print(f"Missing columns: {report['missing_columns']}")
    print(f"Invalid rows: {len(report['invalid_rows'])}")
    for issue in report["invalid_rows"]:
        print(f"  Row {issue['row']}: {', '.join(issue['problems'])}")
