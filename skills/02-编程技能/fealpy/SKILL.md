---
name: fealpy
description: >
  Write Python code using FEALPy (Finite Element Analysis Library in Python v3.4.0)
  for computational mathematics tasks. Use this skill whenever the user mentions:
  fealpy, finite element method, FEM, finite difference, FDM, finite volume, FVM,
  mesh generation, Poisson equation, PDE solving, stiffness matrix, mass matrix,
  Dirichlet boundary condition, Lagrange element, computational fluid dynamics,
  computational electromagnetics, computational solid mechanics, numerical simulation,
  CAX, 有限元, 网格, 偏微分方程, 刚度矩阵, 数值模拟, 计算流体, 计算电磁,
  or asks to solve elliptic/parabolic/hyperbolic PDEs numerically.
  Also use when the user needs to create meshes (triangle, tetrahedron, quad, hex),
  assemble variational forms (BilinearForm, LinearForm), apply boundary conditions,
  or use FEALPy's built-in PDE models (Poisson, Stokes, Helmholtz, Allen-Cahn, etc.).
  FEALPy source is at ~/fealpy/fealpy/ (v3.4.0, Python >= 3.10).
---

# FEALPy Programming Skill

Use this skill to write correct, runnable FEALPy code in the current (v3.4.0) API.

## Critical: API version awareness

FEALPy v3.4.0 underwent a major API refactoring. The `tutorial/` directory mixes old and new
APIs — most files there will FAIL. Old code lives in `fealpy/old/` and must NOT be used.

**Priority of reference sources:**
1. `example/fem/*.py` — verified against current API (best)
2. `tutorial/poisson.py` — updated to new API
3. `fealpy/fealpy/` source code — ground truth
4. Other `tutorial/*.py` — mostly outdated, verify before using

## Standard code template (Poisson equation)

This is the canonical pattern for FEALPy v3.4.0. Use it as the starting point:

```python
import numpy as np
from scipy.sparse.linalg import spsolve

from fealpy.mesh import TriangleMesh
from fealpy.functionspace import LagrangeFESpace
from fealpy.fem import (
    BilinearForm, LinearForm,
    ScalarDiffusionIntegrator, ScalarSourceIntegrator,
    DirichletBC
)

# 1. Create mesh
mesh = TriangleMesh.from_box([0, 1, 0, 1], nx=10, ny=10)

# 2. Create FE space
space = LagrangeFESpace(mesh, p=1)    # p=1 for linear, p=2 for quadratic

# 3. Assemble stiffness matrix
bform = BilinearForm(space)
bform.add_integrator(ScalarDiffusionIntegrator(method='fast'))
A = bform.assembly()

# 4. Assemble load vector
lform = LinearForm(space)
lform.add_integrator(ScalarSourceIntegrator(source_func))
F = lform.assembly()

# 5. Apply Dirichlet BC
A, F = DirichletBC(space, gd=dirichlet_func).apply(A, F)

# 6. Solve
uh = space.function()
uh[:] = spsolve(A.to_scipy(), F)    # NOTE: .to_scipy(), not .toarray()

# 7. Error
l2 = mesh.error(exact_solution, uh)
```

## Old → New API mapping (MUST consult before writing code)

| Old API (tutorial/*.py) | New API (v3.4.0) |
|--------------------------|-------------------|
| `from fealpy.functionspace import LagrangeFiniteElementSpace` | `from fealpy.functionspace import LagrangeFESpace` |
| `space = LagrangeFiniteElementSpace(mesh, p=1)` | `space = LagrangeFESpace(mesh, p=1)` |
| `A = space.stiff_matrix()` | `BilinearForm(space).add_integrator(ScalarDiffusionIntegrator()).assembly()` |
| `F = space.source_vector(f)` | `LinearForm(space).add_integrator(ScalarSourceIntegrator(f)).assembly()` |
| `M = space.mass_matrix()` | `BilinearForm(space).add_integrator(ScalarMassIntegrator()).assembly()` |
| `from fealpy.boundarycondition import DirichletBC` | `from fealpy.fem import DirichletBC` |
| `space.integralalg.error(u, uh)` | `mesh.error(u, uh)` |
| `A.toarray()` (scipy sparse) | `A.to_scipy()` (custom COOTensor/CSRTensor) |
| `mesh.integrator(q)` | `mesh.quadrature_formula(q, etype)` |

## Quick reference by task

### Mesh creation

```python
from fealpy.mesh import (TriangleMesh, TetrahedronMesh, QuadrangleMesh,
                          IntervalMesh, UniformMesh1d, UniformMesh2d, UniformMesh3d)

# Structured triangle mesh on box
mesh = TriangleMesh.from_box([x0, x1, y0, y1], nx=10, ny=10)

# Uniform mesh (tensor-product)
mesh = UniformMesh2d((0, nx, 0, ny), h=(hx, hy), origin=(0.0, 0.0))

# From nodes and cells
mesh = TriangleMesh(node_array, cell_array)

# Tetrahedron
mesh = TetrahedronMesh.from_box([0,1,0,1,0,1], nx=4, ny=4, nz=4)

# Refine
mesh.uniform_refine(n=2)   # n levels of uniform refinement
```

### FE Spaces

```python
from fealpy.functionspace import (LagrangeFESpace, BernsteinFESpace,
    FirstNedelecFESpace, FirstNedelecFESpace2d, FirstNedelecFESpace3d,
    SecondNedelecFESpace, SecondNedelecFESpace2d, SecondNedelecFESpace3d,
    RaviartThomasFESpace, RaviartThomasFESpace2d, RaviartThomasFESpace3d,
    CrConformingFESpace2d, CrConformingFESpace3d,
    ParametricLagrangeFESpace, HuZhangFESpace,
    BrezziDouglasMariniFESpace, TensorFunctionSpace)

space = LagrangeFESpace(mesh, p=1, ctype='C')  # p=degree, ctype='C'=continuous, 'D'=discontinuous
gdof = space.number_of_global_dofs()
ipoints = space.interpolation_points()
cell2dof = space.cell_to_dof()
uh = space.function()    # create solution vector
isBD = space.is_boundary_dof()
```

### Integrators (new modular system)

```python
from fealpy.fem import (
    # Diffusion / Stiffness
    ScalarDiffusionIntegrator,          # ∇·(c∇u), use method='fast' for constant coeff
    DiffusionIntegrator,                # vector version
    # Mass
    ScalarMassIntegrator,               # ∫ c*u*v
    MassIntegrator,                     # vector mass
    # Convection
    ScalarConvectionIntegrator,         # ∫ w·∇u * v
    # Elasticity
    LinearElasticityIntegrator,         # ∫ σ(u):ε(v)
    NonlinearElasticIntegrator,
    # Other operators
    CurlCurlIntegrator,                 # ∫ curl(u)·curl(v)
    DivIntegrator,                      # ∫ div(u)*div(v)
    ScalarBiharmonicIntegrator,         # Δ²
    PolyharmonicIntegrator,             # Δᵏ
    # Sources
    ScalarSourceIntegrator,             # ∫ f*v
    VectorSourceIntegrator,             # ∫ f·v
    CellSourceIntegrator,
    # Boundary (Face) operators
    ScalarRobinBCIntegrator,
    BoundaryFaceMassIntegrator,
    BoundaryFaceSourceIntegrator,       # Neumann BC
    ScalarInteriorPenaltyIntegrator,    # DG penalty
    JumpPenaltyIntergrator,
)

# Usage pattern:
bform = BilinearForm(space)
bform.add_integrator(ScalarDiffusionIntegrator(coef=1.0, method='fast'))
bform.add_integrator(ScalarMassIntegrator(coef=1.0))
A = bform.assembly()
```

### Boundary conditions

```python
from fealpy.fem import DirichletBC, PeriodicBC

# Dirichlet BC
bc = DirichletBC(space, gd=dirichlet_func)         # gd = callable or constant
bc = DirichletBC(space, gd=dirichlet_func, threshold=my_threshold)
A, F = bc.apply(A, F)                               # returns modified (A, F)
A, F = bc.apply(A, F, uh=uh)                        # optional: interpolate onto uh

# For mixed spaces:
bc = DirichletBC((space1, space2), gd=(gD1, gD2))
```

### Assembly and solving

```python
# Variational forms
from fealpy.fem import BilinearForm, LinearForm, NonlinearForm, BlockForm

bform = BilinearForm(space)
bform.add_integrator(integrator)
bform.add_integrator(another_integrator)
A = bform.assembly()     # returns COOTensor

# With batch:
A_batch = bform.assembly_batch(batch_size=N)

lform = LinearForm(space)
lform.add_integrator(ScalarSourceIntegrator(f))
F = lform.assembly()     # returns TensorLike

# Solve with scipy
from scipy.sparse.linalg import spsolve
A_scipy = A.to_scipy()     # COOTensor → scipy sparse
F_np = bm.to_numpy(F)      # TensorLike → numpy (if using non-numpy backend)
uh[:] = spsolve(A_scipy, F_np)
```

### Built-in PDE models (quick prototyping)

```python
from fealpy.fem import (
    PoissonLFEMModel,              # Δu = f
    StokesLFEMModel,               # Stokes equations
    HelmholtzLFEMModel,            # Helmholtz
    CurlCurlLFEMModel,             # Maxwell
    AllenCahnLFEMModel,            # Phase field
    LevelSetLFEMModel,             # Level set
    ParabolicSTFEMModel,           # Time-dependent parabolic
    LinearElasticityEigenLFEMModel,
    SurfacePoissonLFEMModel,       # Surface PDE
    EllipticMixedFEMModel,         # Mixed formulation
)

model = PoissonLFEMModel()
model.set_pde()                    # use default PDE
model.set_init_mesh(nx=20, ny=20)  # create mesh
model.set_space_degree(p=1)        # set FE degree
model.solve.set('cg')              # choose solver
model.run['uniform_refine']()      # solve with refinement
```

### Backend system

```python
from fealpy.backend import backend_manager as bm

# Switch backend (default: numpy)
bm.set_backend('numpy')     # also: 'pytorch', 'jax', 'tensorflow'

# Tensor operations
bm.tensor([1,2,3])          # create tensor in current backend
bm.zeros(shape)             # backend-agnostic zeros
bm.pi                       # π in current backend
```

### Error computation

```python
# On mesh directly
l2_error = mesh.error(exact_solution, uh, q=3, power=2)
h1_error = mesh.error(exact_gradient, uh.grad_value)

# For higher-order accuracy, increase q (quadrature order)
l2_error = mesh.error(exact_solution, uh, q=space.p+4)
```

## When code doesn't run: debugging checklist

1. **ImportError**: check import path against the API mapping table above
2. **AttributeError `stiff_matrix` / `source_vector`**: using old API, switch to BilinearForm/LinearForm
3. **AttributeError `toarray`**: new COOTensor/CSRTensor uses `.to_scipy()` not `.toarray()`
4. **TypeError in DirichletBC**: `gd` parameter is now keyword `gd=pde.solution`, not positional `pde.dirichlet`
5. **`from fealpy.boundarycondition`**: module moved to `fealpy.fem`
6. **`LagrangeFiniteElementSpace`**: renamed to `LagrangeFESpace`

## Reference files

When you need more detail, read:
- `references/api-migration.md` — comprehensive old→new API mapping
- `references/module-catalog.md` — complete module/submodule listing

## Source code access

FEALPy source: `~/fealpy/fealpy/`
Verified examples: `~/fealpy/example/fem/`
CLAUDE.md: `~/fealpy/CLAUDE.md`
