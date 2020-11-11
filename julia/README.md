###  experiments in math

Follow along as I try to keep up with Steve Brunton ( https://www.youtube.com/c/Eigensteve ), and
his classes *Beginning Scientific Computing* (AMATH 301) and *Engineering Mathematics* (ME 564).  He does
the assignments in Matlab, but I attempt to do them in Julia/Pluto.

You can also follow along for the AMATH course with these notes:
http://courses.washington.edu/am301/docs/pdf/301.pdf

Also some benchmarking extrapolated from the julia tutorials.

Warmup with

    using Pluto ;  using Plots ;  using JLD ;  using JSON ; 
    using Statistics ;  using LinearAlgebra ;  using ODE ;  using Random ;
    Pluto.run()

I haven't found an example of Phase Planes in Julia yet, so for now I'm relying on the web page:
https://aeb019.hosted.uark.edu/pplane.html

