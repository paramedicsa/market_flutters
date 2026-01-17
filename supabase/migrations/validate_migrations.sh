#!/bin/bash
# =====================================================
# SQL Syntax Validation Script
# Tests the migration files for syntax errors
# =====================================================

echo "🔍 Validating SQL Migration Files..."
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track overall status
all_valid=true

# Function to validate a SQL file
validate_sql_file() {
    local file=$1
    echo "Checking: $file"
    
    # Basic syntax checks
    
    # Check for balanced parentheses
    open_parens=$(grep -o "(" "$file" | wc -l)
    close_parens=$(grep -o ")" "$file" | wc -l)
    
    if [ "$open_parens" -ne "$close_parens" ]; then
        echo -e "${RED}❌ ERROR: Unbalanced parentheses${NC}"
        echo "   Open: $open_parens, Close: $close_parens"
        all_valid=false
        return 1
    fi
    
    # Check for SQL keywords
    if ! grep -q -i "CREATE TABLE\|CREATE POLICY\|CREATE INDEX" "$file"; then
        echo -e "${YELLOW}⚠️  WARNING: No CREATE statements found${NC}"
    fi
    
    # Check for potential syntax issues
    if grep -q ";;;" "$file"; then
        echo -e "${RED}❌ ERROR: Triple semicolon detected${NC}"
        all_valid=false
        return 1
    fi
    
    # Check for incomplete statements
    if grep -q "CREATE TABLE.*(" "$file"; then
        if ! grep -q ");" "$file"; then
            echo -e "${RED}❌ ERROR: Potentially unclosed CREATE TABLE statement${NC}"
            all_valid=false
            return 1
        fi
    fi
    
    echo -e "${GREEN}✅ Syntax looks good${NC}"
    echo ""
    return 0
}

# Validate each migration file
cd "$(dirname "$0")"

for file in 0000*.sql; do
    if [ -f "$file" ]; then
        validate_sql_file "$file"
    fi
done

# Validate combined migration
if [ -f "run_all_migrations.sql" ]; then
    echo "Checking: run_all_migrations.sql (combined)"
    validate_sql_file "run_all_migrations.sql"
fi

# Final status
echo "========================================="
if [ "$all_valid" = true ]; then
    echo -e "${GREEN}✅ All migration files passed validation!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Copy the contents of run_all_migrations.sql"
    echo "2. Paste into Supabase SQL Editor"
    echo "3. Execute the migration"
    echo ""
    echo "Or run individual files in order:"
    echo "   00001_create_profiles.sql"
    echo "   00002_create_artist_subscription_packages.sql"
    echo "   00003_create_artist_subscriptions.sql"
    exit 0
else
    echo -e "${RED}❌ Some migration files have issues${NC}"
    echo "Please review the errors above and fix them."
    exit 1
fi
