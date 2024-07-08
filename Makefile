SRCS = $(wildcard rtl/*.sv) $(wildcard tb/*.sv)

.PHONY: format prevew lint clean

all: lint

format:
	verible-verilog-format --inplace $(SRCS)

preview:
	rm -rf preview
	mkdir -p preview
	$(foreach file, $(SRCS), verible-verilog-format $(file) > preview/format_$(notdir $(file)); )

lint:
	@verible-verilog-lint $(SRCS) || true

clean:
	rm -rf preview
