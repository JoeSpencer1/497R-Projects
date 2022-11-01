#=---------------------------------------------------------------
10/31/2022
Rotor Design v2 Rotor_Design.jl
For now, the companion file for this main file is the same file
that went with the last project, Rotor Analysis.
Function outputs are efficiency, power coefficient, and rotational velocity.
I think the function arguments for adjustible variables should be: chord distribution, rotation, and twist distribution.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

# Create a standard domain. This is based on known values.
J0 = range(0.1, 0.6, length = 20) # This is an actual array. Other J values returned are pointers.
J0a, eff0, CT0, CQ0 = Compute()# This provides default data.

# This section reads in experimental data and estimates results.
Jexp1, CTexp1, CPexp1, etaexp1 = Loadexp("Rotor Optimization/Rotors/10x7_6014.txt") # This experimental data was provided by UIUC.
CQexp1 = CQCP(CPexp1) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je1p = pointer(Jexp1) # Converts Jexp1 to a pointer to pass it into the Compute() function.
J1, eff1, CT1, CQ1 = Compute(rpm = 6014, Re0 = 1e6, nJ = 24, expr = Je1p) # Based on APC10x7 propellor, no rotation.
# This function without the pointer in its argument did not work the second time I tried it.
# J1, eff1, CT1, CQ1 = Compute(10, rpm = 6014, nJ = 24, expr = Jexp1) 
CP1 = CPCQ(CQ1) # Calculate CP from CQ for use in plots later

for i in 1:1
    # Calculate error.
    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(etaexp1)
            error = error + (eff1[i] - etaexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + eff1[i] * eff1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("\neta error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CTexp1)
            error = error + (CT1[i] - CTexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + CTexp1[i] * CTexp1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("C_T error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CPexp1)
            error = error + (CP1[i] - CPexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + CPexp1[i] * CPexp1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("C_P error = ", error, "%\n") # Print in string.
    end
end
