# FEALPy 迁移排错
来源是用户旧 FEALPy 3.4.0 技能的排错经验；这是检索线索，不是当前版本 API 保证。先定位实际 checkout、版本与同版本测试，再核对下表候选。

| 旧代码症状 | 当前项目中应查找的接口/做法 |
|---|---|
| LagrangeFiniteElementSpace 导入失败 | functionspace 下 LagrangeFESpace 及实际构造签名 |
| boundarycondition 模块不可用 | fem 下 DirichletBC，核对 gd/threshold/apply 参数 |
| space.stiff_matrix / mass_matrix 缺失 | BilinearForm 与扩散/质量积分器的装配 |
| space.source_vector 缺失 | LinearForm 与源项积分器 |
| integralalg.error 缺失 | mesh.error 的坐标、积分阶与输出定义 |
| SciPy 求解器不接受装配结果 | 实际稀疏类型的转换接口，保持稀疏 |
| mesh.integrator 缺失 | quadrature_formula 及积分点/权重获取方式 |

先查 fealpy/mesh、functionspace、fem、backend、sparse、solver，结合相同版本 example 和 tests。其他模块按具体 PDE 搜索，不复制静态全模块目录。
迁移不是全局字符串替换：核对函数签名、返回值、数组 shape、系数坐标类型、边界自由度与矩阵处理语义。旧接口在用户旧项目中仍有效时，不为“现代化”擅自升级依赖。
不能假定 gd 一定只允许关键字、所有 PDE 都用 solution、所有装配都返回同一种稀疏张量，或所有后端均已实现同等功能。

## 最小验收路径
从用户方程写出弱形式，先在小网格验证，再增密。记录版本、后端、单元阶、网格尺度、自由度、求解状态、残差与适当误差。
制造解的源项和边界数据从同一强形式推导。齐次 Neumann 问题检查相容性与零空间；非齐次 Dirichlet 检查消元后右端。
误差阶用 log(e_old/e_new)/log(h_old/h_new)，不能在非等比例网格上固定分母 log(2)。误差到舍入误差平台后停止用该区间估阶。
