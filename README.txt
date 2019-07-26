Eurofighter Typhoon JSBSim conversion and rewrite
Credit to the FGUK guys for an awesome job.
Currently very alpha

--- Contributing ---
Contributions are welcome.

Quick guideline:
Use 4 spaces for your tabs.

All jsbsim property initalizations should go in ./Systems/jsbsim-props-init.xml

All nasal property io should use ./Nasal/prop_io.nas.
    getprop() and setprop(), and props.nas outside of ./Nasal/prop_io.nas is strongly discouraged, but will be considered on a case by case basis.