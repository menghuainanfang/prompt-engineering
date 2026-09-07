# FEALPy Module Catalog (v3.4.0)

Complete listing of all modules under `fealpy/`. Source base: `~/fealpy/fealpy/`

## Core modules (most commonly used)

### `fealpy.mesh` — Mesh data structures
All mesh types and file parsers.

| Class | Dim | Description |
|-------|-----|-------------|
| `IntervalMesh` | 1D | 1D interval mesh |
| `TriangleMesh` | 2D | Triangle mesh (simplex) |
| `QuadrangleMesh` | 2D | Quadrilateral mesh (tensor) |
| `PolygonMesh` | 2D | General polygon mesh |
| `HalfEdgeMesh2d` | 2D | Half-edge data structure |
| `TetrahedronMesh` | 3D | Tetrahedron mesh (simplex) |
| `HexahedronMesh` | 3D | Hexahedron mesh (tensor) |
| `PrismMesh` | 3D | Prism/wedge mesh |
| `TensorPrismMesh` | 3D | Tensor-product prism mesh |
| `LagrangeTriangleMesh` | 2D | High-order triangle mesh |
| `LagrangeQuadrangleMesh` | 2D | High-order quad mesh |
| `LagrangeTetrahedronMesh` | 3D | High-order tet mesh |
| `LagrangeHexahedronMesh` | 3D | High-order hex mesh |
| `UniformMesh1d/2d/3d` | 1-3D | Structured uniform meshes |
| `EdgeMesh` | 2D | Edge-only mesh (for boundary) |
| `DartMesh` | 2D/3D | Dart data structure |
| `NodeMesh` | any | Point cloud mesh |

Base classes: `Mesh` → `HomogeneousMesh` → `SimplexMesh` / `TensorMesh` / `StructuredMesh`

File parsers: `InpFileParser` (ABAQUS), `BdfFileParser` (Nastran), `MFileParser`

### `fealpy.fem` — Finite Element Method
The main FEM module with forms, integrators, BCs, and PDE models.

**Forms:**
- `BilinearForm` — A = assembly of bilinear integrators → COOTensor
- `LinearForm` — F = assembly of linear integrators → Tensor
- `NonlinearForm` — for nonlinear problems
- `BlockForm` — for mixed/hybrid formulations
- `LinearBlockForm` — for block-structured linear systems

**Cell operators (domain integrators):**
| Integrator | Mathematical form |
|-----------|-------------------|
| `ScalarDiffusionIntegrator` | ∫ c ∇u·∇v |
| `DiffusionIntegrator` | vector diffusion |
| `ScalarMassIntegrator` | ∫ c u·v |
| `MassIntegrator` | vector mass |
| `ScalarConvectionIntegrator` | ∫ (w·∇u)·v |
| `LinearElasticityIntegrator` | ∫ σ(u):ε(v) |
| `NonlinearElasticIntegrator` | nonlinear elasticity |
| `CurlCurlIntegrator` | ∫ curl(u)·curl(v) |
| `DivIntegrator` | ∫ div(u)·div(v) |
| `ScalarBiharmonicIntegrator` | ∫ Δu·Δv |
| `PolyharmonicIntegrator` | ∫ Δᵏu·Δᵏv |
| `ScalarNonlinearDiffusionIntegrator` | nonlinear diffusion |
| `ScalarNonlinearMassIntegrator` | nonlinear mass |
| `PressWorkIntegrator` | pressure work term |
| `ViscousWorkIntegrator` | viscous dissipation |
| `GradPressureIntegrator` | ∫ ∇p·v |
| `CouplingMassIntegrator` | coupling between spaces |
| `OPCIntegrator` | optimal control |
| `JumpPenaltyIntergrator` | DG jump penalty |
| `SpaceTimeResidualIntegrator` | space-time FEM residual |

**Cell source integrators:**
| Integrator | Mathematical form |
|-----------|-------------------|
| `ScalarSourceIntegrator` | ∫ f·v |
| `VectorSourceIntegrator` | ∫ f·v (vector) |
| `CellSourceIntegrator` (alias: `SourceIntegrator`) | generic cell source |
| `GradSourceIntegrator` | ∫ f·∇v |
| `OPCSIntegrator` | optimal control source |

**Face (boundary) operators:**
| Integrator | Usage |
|-----------|-------|
| `ScalarRobinBCIntegrator` | Robin BC |
| `BoundaryFaceMassIntegrator` | boundary mass |
| `InterFaceMassIntegrator` | interior face mass |
| `BoundaryFaceSourceIntegrator` | Neumann BC (= `ScalarNeumannBCIntegrator`) |
| `InterFaceSourceIntegrator` | interior face source |
| `ScalarRobinSourceIntegrator` | Robin source |
| `ScalarInteriorPenaltyIntegrator` | IPDG penalty |
| `FluidBoundaryFrictionIntegrator` | Navier slip |
| `BoundaryPressWorkIntegrator` | boundary pressure work |
| `TangentFaceMassIntegrator` | tangential boundary mass |

**Boundary conditions:**
- `DirichletBC` — Dirichlet (essential) BC
- `DirichletBCOperator` — operator form
- `PeriodicBC` — periodic BC

**Built-in PDE models (high-level):**
- `PoissonLFEMModel` — Δu = f
- `StokesLFEMModel` — Stokes flow
- `HelmholtzLFEMModel` — Helmholtz equation
- `CurlCurlLFEMModel` — Maxwell eigenvalue
- `AllenCahnLFEMModel` — phase field
- `LevelSetLFEMModel` — level set method
- `LevelSetReinitModel` — reinitialization
- `ParabolicSTFEMModel` — space-time parabolic
- `LinearElasticityEigenLFEMModel` — elastic eigenvalue
- `LinearElasticityLFEMModel` — linear elasticity
- `SurfacePoissonLFEMModel` — PDE on surface
- `EllipticMixedFEMModel` — mixed formulation
- `InterfacePoissonLFEMModel` — interface problems
- `CurlCurlUPMLModel` — Maxwell with UPML
- `OPCMixedFEMModel` — optimal control mixed
- `WPRLFEMModel` — weak form Poisson
- `MGTensorPossionLFEMModel` — multigrid tensor Poisson
- `DarcyForchheimerLFEMModel` — Darcy-Forchheimer
- `DLDMicrofluidicChipLFEMModel` — DLD chip (2D/3D)

**Other:**
- `RecoveryAlg` — gradient recovery
- `NonlinearWrapperInt` — wrapper for nonlinear integrators

### `fealpy.functionspace` — Finite element spaces

**Lagrange:**
- `LagrangeFESpace` — continuous/discontinuous Lagrange on simplices
- `ParametricLagrangeFESpace` — Lagrange on mapped elements
- `BernsteinFESpace` — Bernstein polynomial basis

**Nédélec (H(curl)):**
- `FirstNedelecFESpace` / `FirstNedelecFESpace2d` / `FirstNedelecFESpace3d`
- `SecondNedelecFESpace` / `SecondNedelecFESpace2d` / `SecondNedelecFESpace3d`

**Raviart-Thomas (H(div)):**
- `RaviartThomasFESpace` / `RaviartThomasFESpace2d` / `RaviartThomasFESpace3d`

**Brezzi-Douglas-Marini:**
- `BrezziDouglasMariniFESpace` / `BrezziDouglasMariniFESpace2d` / `BrezziDouglasMariniFESpace3d`

**Crouzeix-Raviart (nonconforming):**
- `CrConformingFESpace2d` / `CrConformingFESpace3d`

**Other:**
- `HuZhangFESpace` — Hu-Zhang element
- `InteriorPenaltyFESpace2d` — IPDG space
- `TensorFunctionSpace` — vector/tensor-valued from scalar space
- `FunctionSpace` — base class

**Virtual element spaces:**
- `ScaledMonomialSpace` / `ScaledMonomialSpace2d` / `ScaledMonomialSpace3d`
- `ConformingScalarVESpace2d`
- `NonConformingScalarVESpace2d`

**Utility:**
- `functionspace(mesh, ('Lagrange', p), shape=None)` — factory function

### `fealpy.pde` — PDE data definitions

Predefined test problems with exact solutions:

| File | Problem |
|------|---------|
| `poisson_1d.py` | 1D Poisson |
| `poisson_2d.py` | 2D Poisson (`CosCosData`, `SinSinData`, etc.) |
| `poisson_3d.py` | 3D Poisson |
| `helmholtz_2d.py` | Helmholtz equation |
| `linear_elasticity_2d.py` | Linear elasticity |
| `stokes_2d.py` | Stokes equations |
| `maxwell_2d.py` / `maxwell_3d.py` | Maxwell equations |
| `navier_stokes_equation_2d.py` / `_3d.py` | Navier-Stokes |
| `parabolic2d.py` | Parabolic (heat) equations |
| `semilinear_2d.py` | Semilinear elliptic |
| `biharmonic_triharmonic_2d.py` / `_3d.py` | Higher-order elliptic |
| `pml_2d.py` | PML models |
| `surface_poisson_model.py` | Surface PDE |

### `fealpy.solver` — Linear/Nonlinear solvers
Solvers for resulting linear systems.

### `fealpy.quadrature` — Numerical integration
Gaussian quadrature formulas for various element shapes.

### `fealpy.sparse` — Sparse matrix types
- `COOTensor` — coordinate format sparse tensor
- `CSRTensor` — compressed sparse row tensor
- `spdiags` — sparse diagonal matrix

---

## Other specialized modules

| Module | Domain | Key contents |
|--------|--------|-------------|
| `fdm` | Finite Difference | 1D/2D/3D FDM solvers |
| `fvm` | Finite Volume | FVM discretizations |
| `vem` | Virtual Element | VEM implementation |
| `fpm` | Finite Point | Meshfree methods |
| `cfd` | Computational Fluid Dynamics | Navier-Stokes, etc. |
| `cem` | Computational Electromagnetics | Maxwell solvers |
| `csm` | Computational Solid Mechanics | Elasticity, plasticity |
| `cdo` | Computational Design Optimization | Topology optimization |
| `cdg` | Computational Differential Geometry | Surface operators |
| `cgp` | Computational Graph Processing | Graph algorithms |
| `ml` | Machine Learning | PINN, neural operators |
| `unml` | Unstructured Mesh ML | ML on unstructured meshes |
| `material` | Material models | Constitutive laws |
| `physics` | Physics | Physical models |
| `model` | Generic models | Model framework |
| `geometry` | Geometry | Geometric computations |
| `mesher` | Mesh generation | Meshing algorithms |
| `meshopt` | Mesh optimization | Smoothing, refinement |
| `mmesh` | Polyhedral mesh | General polyhedra |
| `graph` | Graph theory | Graph algorithms |
| `opt` | Optimization | Numerical optimization |
| `plotter` | Visualization | 3D rendering |
| `plotting` | 2D plots | matplotlib wrappers |
| `tools` | Utilities | Helper functions |
| `utils` | Utilities | Helper functions |
| `common` | Common | Shared utilities |
| `backend` | Backend | numpy/jax/pytorch/cupy backends |
| `decorator` | Decorators | `@cartesian`, `@barycentric` |
| `time` | Time | Time integration |
| `writer` | Output | File I/O |
| `pathplanning` | Path planning | Robot path planning |

---

## Important: Directory disambiguation

- `fealpy/old/` — **Deprecated** code from previous versions. DO NOT USE.
- `fealpy/example/` — Working examples using current API (see `example/fem/` for FEM).
- `fealpy/tutorial/` — Mixed old+new APIs; only `tutorial/poisson.py` is confirmed updated.
- `fealpy/test/` and `fealpy/tests/` — Unit tests (good API usage reference).
