# FEALPy API Migration Guide (Old → New)

Complete mapping from the old (pre-v3.4.0) API to the current v3.4.0 API.

## Module renames and moves

| Old import | New import |
|-----------|-----------|
| `from fealpy.functionspace import LagrangeFiniteElementSpace` | `from fealpy.functionspace import LagrangeFESpace` |
| `from fealpy.boundarycondition import DirichletBC` | `from fealpy.fem import DirichletBC` |
| `from fealpy.boundarycondition import PeriodicBC` | `from fealpy.fem import PeriodicBC` |
| `from fealpy.boundarycondition import NeumannBC` | `from fealpy.fem import BoundaryFaceSourceIntegrator` (now an integrator, not a BC class) |
| `from fealpy.functionspace import ParametricLagrangeFiniteElementSpace` | `from fealpy.functionspace import ParametricLagrangeFESpace` |

## Class renames

| Old class | New class |
|-----------|-----------|
| `LagrangeFiniteElementSpace` | `LagrangeFESpace` |
| `ParametricLagrangeFiniteElementSpace` | `ParametricLagrangeFESpace` |

## Assembly: monolithic methods → modular forms

### Stiffness matrix
```python
# OLD (pre-v3.4.0)
A = space.stiff_matrix()
A = space.stiff_matrix(c=coef)     # with coefficient

# NEW (v3.4.0)
from fealpy.fem import BilinearForm, ScalarDiffusionIntegrator
bform = BilinearForm(space)
bform.add_integrator(ScalarDiffusionIntegrator(coef=coef, method='fast'))
A = bform.assembly()
```

### Mass matrix
```python
# OLD
M = space.mass_matrix()
M = space.mass_matrix(c=coef)

# NEW
from fealpy.fem import BilinearForm, ScalarMassIntegrator
bform = BilinearForm(space)
bform.add_integrator(ScalarMassIntegrator(coef=coef))
M = bform.assembly()
```

### Source/Load vector
```python
# OLD
F = space.source_vector(f)
F = space.source_vector(f, dim=2)

# NEW
from fealpy.fem import LinearForm, ScalarSourceIntegrator, VectorSourceIntegrator
lform = LinearForm(space)
lform.add_integrator(ScalarSourceIntegrator(f))  # scalar
lform.add_integrator(VectorSourceIntegrator(f))  # vector
F = lform.assembly()
```

### Convection term
```python
# OLD
C = space.convection_matrix(velocity)

# NEW
from fealpy.fem import BilinearForm, ScalarConvectionIntegrator
bform = BilinearForm(space)
bform.add_integrator(ScalarConvectionIntegrator(velocity))
C = bform.assembly()
```

## DirichletBC changes

```python
# OLD
from fealpy.boundarycondition import DirichletBC
bc = DirichletBC(space, pde.dirichlet)      # gd as positional arg
A, F = bc.apply(A, F, uh)                   # 3-arg or 2-arg
A, F = bc.apply(A, F)                       # without uh

# NEW
from fealpy.fem import DirichletBC
bc = DirichletBC(space, gd=pde.solution)    # gd as KEYWORD arg
bc = DirichletBC(space, gd=pde.solution, threshold=None, method=None)
A, F = bc.apply(A, F)                       # always returns (A, F)
A, F = bc.apply(A, F, uh=uh)               # optional: interpolate into uh
A, F = bc.apply(A, F, gd=custom_gd)         # override gd
```

Key differences:
- `gd` is now keyword-only (not positional)
- `pde.dirichlet` attribute no longer exists on most PDE classes; use `pde.solution`
- `threshold` and `method` are new optional parameters
- `uh` is fully optional in apply()

## Error computation

```python
# OLD
L2error = space.integralalg.error(pde.solution, uh)
H1error = space.integralalg.error(pde.gradient, uh.grad_value)

# NEW
L2error = mesh.error(pde.solution, uh)
H1error = mesh.error(pde.gradient, uh.grad_value)

# Also supports:
L2error = mesh.error(pde.solution, uh, q=3, power=2)
```

## Matrix format changes

```python
# OLD: scipy.sparse matrices
from scipy.sparse import csr_matrix
A = csr_matrix((data, (rows, cols)), shape=(N, N))
x = A.toarray()

# NEW: custom COOTensor / CSRTensor
from fealpy.sparse import COOTensor, CSRTensor
# Assembly returns COOTensor
A = bform.assembly()           # → COOTensor
A_scipy = A.to_scipy()         # → scipy sparse matrix (for scipy solvers)
A_dense = A.to_scipy().toarray()  # if you really need dense

# Direct linear solve:
from scipy.sparse.linalg import spsolve
uh[:] = spsolve(A.to_scipy(), F)
```

## Mesh creation

```python
# OLD: pde.init_mesh() — only some PDE classes had this
mesh = pde.init_mesh(n=5, meshtype='tri')

# NEW: mesh factory methods or direct construction
from fealpy.mesh import TriangleMesh
mesh = TriangleMesh.from_box([x0, x1, y0, y1], nx=10, ny=10)
mesh = TriangleMesh.from_box(pde.domain(), nx=10, ny=10)  # use PDE's domain()
```

## Quadrature

```python
# OLD
qf = mesh.integrator(q)           # returns Quadrature
bcs, ws = qf.get_quadrature_points_and_weights()

# NEW
qf = mesh.quadrature_formula(q, etype='cell')
bcs, ws = qf.get_quadrature_points_and_weights()
```

## PDE model usage

```python
# NEW (v3.4.0) - high-level model API
from fealpy.fem import PoissonLFEMModel

model = PoissonLFEMModel()
model.set_pde()              # sets default PDE (can customize)
model.set_init_mesh(nx=20, ny=20)
model.set_space_degree(p=1)
model.solve.set('cg')        # solver choice
model.run['uniform_refine']() # run with uniform refinement
```

## Backend system (new in v3.4.0)

```python
from fealpy.backend import backend_manager as bm

bm.set_backend('numpy')      # switches global backend
# Also: 'pytorch', 'jax', 'tensorflow'

# Use bm instead of np for backend-agnostic code:
x = bm.tensor([1, 2, 3])    # NOT np.array([1, 2, 3])
z = bm.zeros((10, 10))
pi = bm.pi                   # NOT np.pi
```

## Mesh API changes (minor)

Methods that **still work** (no change needed):
- `mesh.entity('node')`, `mesh.entity('edge')`, `mesh.entity('cell')`
- `mesh.node`, `mesh.cell`
- `mesh.number_of_nodes()`, `mesh.number_of_cells()`, `mesh.number_of_edges()`
- `mesh.entity_measure('cell')`
- `mesh.grad_lambda()`
- `mesh.bc_to_point(bcs)`
- `mesh.uniform_refine(n)`
- `mesh.add_plot(axes)`, `mesh.find_node()`, `mesh.find_cell()`
