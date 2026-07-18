package expense_transaction

import (
	_ "embed"
)

//go:embed get_all.sql
var GetAll string

//go:embed create.sql
var Create string