 # copyright (c) 2020 ASandip
 #This program is free software: you can redistribute it and/or 
 # modify it under the terms of the GNU General Public License as 
 # published by the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.



#!/bin/bash

#Source EOF library environment
. $HOME/EOF-Library/etc/bashrc

#Source OpenFoam environment
source ~/openfoam6/etc/bashrc


#Compile EOF Library
eofCompile >> log.out 2>&1

#Compile the chosen solver for the test; for example, mhdInterFoam6
wmake ../Solvers/mhdInterFoam6 >> log.out 2>&1 


#Copy Elmer and OpenFoam case files to Dakota Gui workspace
cp -r ../casebase/* .

#Prepare test
setFields  >> log.out 2>&1
decomposePar >> log.out 2>&1
ElmerGrid 2 2 meshElmer -metis 2


#Run openFoam on n processes and Elmer on n processes, define n
mpirun --allow-run-as-root  -np n mhdInterFoam -parallel : -np n ElmerSolver_mpi case.sif >> log.out 2>&1
