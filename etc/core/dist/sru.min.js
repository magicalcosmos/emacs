(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(require('axios'), require('crypto'), require('querystring')) :
  typeof define === 'function' && define.amd ? define(['axios', 'crypto', 'querystring'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.axios, global.crypto, global.querystring));
}(this, (function (axios, crypto, querystring) { 'use strict';

  function _interopDefaultLegacy (e) { return e && typeof e === 'object' && 'default' in e ? e : { 'default': e }; }

  var axios__default = /*#__PURE__*/_interopDefaultLegacy(axios);
  var crypto__default = /*#__PURE__*/_interopDefaultLegacy(crypto);
  var querystring__default = /*#__PURE__*/_interopDefaultLegacy(querystring);

  /**
   * 判断是否是数组类型
   * @param o
   * @return {Boolean}
   */
  function isArrayType(o) {
    return !!o && Object.prototype.toString.call(o) === '[object Array]';
  }
  /**
   * 判断是否是对象类型
   * @param o
   * @return {Boolean}
   */

  function isObjectType(o) {
    return !!o && Object.prototype.toString.call(o) === '[object Object]';
  }

  /**
   * 测试用例转化逻辑
   *
   * 数据说明：
   *  {
   *    name: 变量/字段名称
   *    typeName: 变量/字段类型名
   *    fieldPath: 唯一标识，用于标记变量/字段数据路径
   *    editable: 是否可编辑
   *    unused: 是否未使用
   *    kind: 变量种类，具体值以及信息见variableKind
   *    type: 变量类型，具体值以及信息见variableType
   *    scope: 变量范围，具体值以及信息见variableScopeKind
   *    elementTypeName: 元素类型名，仅当为数组类型时才存在
   *    length: 数组长度名，仅当为数组类型时才存在
   *    stubName: 桩函数名称，仅当为桩函数类型试才存在
   *    times: 调用次数列表，仅当为桩函数类型试才存在
   *    time: 当前调用次数，仅当为桩函数类型试才存在
   *    locations: 变量位置，仅当为绝对地址表达式类型才存在
   *    children: 子节点数据
   *    data: 当前变量对应测试用例数据
   *      {
   *        @value: 若为输入变量，表示输入变量的值；若为输出变量，表示预期值
   *        @result: 仅当输出变量才存在，表示实际值
   *      }
   *  }
   * Created by snowingsea on 2020/08/25.
   */

  var TestCaseTransformer = /*#__PURE__*/function () {
    // 变量种类
    // 变量类型
    // 变量范围
    // 桩类型
    // 初始化脚本
    // 成员函数所属类数据
    // 形参数据
    // 全局输入变量数据
    // 局部静态变量
    // 绝对地址表达式数据
    // 绝对地址基地址数据
    // 桩函数数据
    // 指针目标数据
    // 返回值数据
    // 成员函数所属类输出数据
    // 全局变量输出数据
    // 指针目标输出数据
    // 绝对地址基地址输出数据
    // 局部静态变量输出数据
    // 异常检查项
    // 测试用例数据
    // 函数变量信息数据
    // 类型系统数据
    // 类型检查结果，是否合法

    /**
     * 构造函数
     * @param testCaseData 测试用例数据
     * @param variablesData 函数变量信息数据
     * @param typeSystemData 类型系统数据
     */
    function TestCaseTransformer(testCaseData, variablesData, typeSystemData) {
      Object.defineProperty(this, "VARIABLE_KIND", {
        enumerable: true,
        writable: true,
        value: {
          field: 0,
          // 字段，未使用
          global: 1,
          // 全局变量
          param: 2,
          // 形参
          mallocVariable: 3,
          // 指针目标
          "return": 4,
          // 返回值
          stub: 10,
          // 桩函数
          stubReturn: 11,
          // 桩函数返回值
          stubParam: 12,
          // 桩函数参数
          stubPointerTarget: 13,
          // 桩函数指针目标
          stubMemberVariable: 14,
          // 桩函数成员变量
          constructorParam: 15,
          // 构造函数参数
          fixedAddressExpression: 20,
          // 绝对地址
          fixedAddressBase: 21,
          // 绝对地址目标
          fixedAddressOffset: 22,
          // 绝对地址偏移量
          statics: 23,
          //　静态变量
          exception: 30,
          // 异常
          object: 40 // 成员函数所属类

        }
      });
      Object.defineProperty(this, "VARIABLE_TYPE", {
        enumerable: true,
        writable: true,
        value: {
          basic: 1,
          // 基本类型
          pointer: 2,
          // 指针类型
          array: 3,
          // 数组类型
          record: 4,
          // 结构体类型
          functionPointer: 5,
          // 函数指针
          enumeration: 6,
          // 枚举类型
          fixedAddress: 7,
          // 绝对地址
          reference: 8 // 引用

        }
      });
      Object.defineProperty(this, "VARIABLE_SCOPE_KIND", {
        enumerable: true,
        writable: true,
        value: {
          input: 1,
          // 输入
          output: 2 // 输出

        }
      });
      Object.defineProperty(this, "STUB_KIND", {
        enumerable: true,
        writable: true,
        value: {
          value: 1,
          // 赋值打桩
          code: 2 // 代码打桩

        }
      });
      Object.defineProperty(this, "prelude", {
        enumerable: true,
        writable: true,
        value: ''
      });
      Object.defineProperty(this, "objectData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "paramVariablesData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "globalVariablesData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "staticsData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "fixedAddressExpressionsData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "fixedAddressBasesData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "stubsData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "mallocVariablesData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "returnValueData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "objectOutputData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "globalOutputData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "mallocOutputData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "fixedAddressBasesOutputData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "staticsOutputData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "exceptionsOutputData", {
        enumerable: true,
        writable: true,
        value: []
      });
      Object.defineProperty(this, "testCaseData", {
        enumerable: true,
        writable: true,
        value: null
      });
      Object.defineProperty(this, "variablesData", {
        enumerable: true,
        writable: true,
        value: null
      });
      Object.defineProperty(this, "typeSystemData", {
        enumerable: true,
        writable: true,
        value: null
      });
      Object.defineProperty(this, "isLegal", {
        enumerable: true,
        writable: true,
        value: true
      });
      this.setTypeSystemData(typeSystemData);
      this.setTestCaseData(testCaseData);
      this.setVariablesData(variablesData);
    }
    /**
     * 设置测试用例数据
     * @param testCaseData 测试用例数据
     */


    var _proto = TestCaseTransformer.prototype;

    _proto.setTestCaseData = function setTestCaseData(testCaseData) {
      this.testCaseData = testCaseData;
    }
    /**
     * 设置函数变量信息数据
     * @param variablesData 函数变量信息数据
     */
    ;

    _proto.setVariablesData = function setVariablesData(variablesData) {
      this.variablesData = variablesData;
      this.removeConstGlobalVariable();
    }
    /**
     * 设置类型系统数据
     * @param typeSystemData 类型系统数据
     */
    ;

    _proto.setTypeSystemData = function setTypeSystemData(typeSystemData) {
      this.typeSystemData = typeSystemData;
      this.removeConstGlobalVariable();
    }
    /**
     * 数据转换
     */
    ;

    _proto.transform = function transform() {
      var _this = this;

      //清空旧数据防止重复构建数据
      this.clearData();

      if (!this.testCaseData.data) {
        this.testCaseData.data = {};
      }

      TestCaseTransformer.removeEmptyField(this.testCaseData.data.output); // 数据字段补全

      var fieldNames = ['malloc', 'stubs', 'variables', 'fixedAddrs', 'output'];
      fieldNames.forEach(function (fieldName) {
        if (!_this.testCaseData.data[fieldName]) {
          _this.testCaseData.data[fieldName] = {};
        }

        if (!_this.variablesData[fieldName]) {
          _this.variablesData[fieldName] = {};
        }

        if (fieldName === 'malloc') {
          var testCaseDate = _this.testCaseData.data[fieldName];
          var variableData = _this.variablesData[fieldName];
          Object.keys(testCaseDate).forEach(function (variableName) {
            variableData[variableName] = variableData[variableName] || testCaseDate[variableName];
          });
        }
      });
      var variableFieldNames = ['global', 'params', 'statics'];
      variableFieldNames.forEach(function (fieldName) {
        if (!_this.testCaseData.data.variables[fieldName]) {
          _this.testCaseData.data.variables[fieldName] = {};
        }

        if (!_this.variablesData.variables[fieldName]) {
          _this.variablesData.variables[fieldName] = {};
        }
      });
      var fixedAddressFieldNames = ['exprs', 'bases'];
      fixedAddressFieldNames.forEach(function (fieldName) {
        if (!_this.testCaseData.data.fixedAddrs[fieldName]) {
          _this.testCaseData.data.fixedAddrs[fieldName] = {};
        }

        if (!_this.variablesData.fixedAddrs[fieldName]) {
          _this.variablesData.fixedAddrs[fieldName] = {};
        }

        if (fieldName === 'bases') {
          var testCaseDate = _this.testCaseData.data.fixedAddrs[fieldName];
          var variableData = _this.variablesData.fixedAddrs[fieldName];
          Object.keys(testCaseDate).forEach(function (variableName) {
            variableData[variableName] = variableData[variableName] || testCaseDate[variableName];
          });
        }
      }); // 输出项补全

      var outputFieldNames = ['global', 'malloc', 'fixedAddrs', 'statics'];
      outputFieldNames.forEach(function (fieldName) {
        if (!_this.testCaseData.data.output[fieldName]) {
          _this.testCaseData.data.output[fieldName] = {};
        }

        if (!_this.variablesData.output[fieldName]) {
          _this.variablesData.output[fieldName] = {};
        }
      }); // 绝对地址目标输出项补全

      if (!this.testCaseData.data.output.fixedAddrs.bases) {
        this.testCaseData.data.output.fixedAddrs.bases = {};
      } // 补充用户添加的桩函数及桩函数指针目标


      var testCaseStubs = this.testCaseData.data.stubs;
      var variableStubs = this.variablesData.stubs;
      Object.keys(testCaseStubs).forEach(function (stubName) {
        var stubTestCaseData = testCaseStubs[stubName];
        variableStubs[stubName] = variableStubs[stubName] || stubTestCaseData['@type'];
        var stubPointTargets = variableStubs[stubName].pointerTargets || {};

        if (stubTestCaseData['@value']) {
          Object.keys(stubTestCaseData['@value']).forEach(function (time) {
            var testCastStubPointTargets = stubTestCaseData['@value'][time].pointerTargets;

            if (testCastStubPointTargets) {
              Object.keys(testCastStubPointTargets).forEach(function (pointerTargetName) {
                stubPointTargets[pointerTargetName] = stubPointTargets[pointerTargetName] || testCastStubPointTargets[pointerTargetName];
              });
            }
          });
        }
      }); // 初始化脚本

      this.prelude = this.testCaseData.data.prelude; // 成员函数所属类

      this.buildObjectFields(); // 形参变量

      this.buildFields(this.testCaseData.data.variables.params, this.variablesData.variables.params, this.paramVariablesData, 'variables.params', this.VARIABLE_KIND.param, this.VARIABLE_SCOPE_KIND.input); // 全局输入变量

      this.buildFields(this.testCaseData.data.variables.global, this.variablesData.variables.global, this.globalVariablesData, 'variables.global', this.VARIABLE_KIND.global, this.VARIABLE_SCOPE_KIND.input); // 局部静态变量

      this.buildStatics(this.testCaseData.data.variables.statics, this.variablesData.variables.statics, this.staticsData, 'variables.statics', this.VARIABLE_SCOPE_KIND.input); // 绝对地址

      this.buildFixedAddresses(); // 桩函数

      Object.keys(this.variablesData.stubs).forEach(function (stubName) {
        _this.buildStubFields(stubName);
      }); // 指针目标变量

      this.buildInputMallocVariables(); // 返回值

      if (this.variablesData.output['%']) {
        if (!this.testCaseData.data.output['%']) {
          this.testCaseData.data.output['%'] = {};
        }

        this.buildFields({
          '%': this.testCaseData.data.output['%']
        }, {
          '%': this.variablesData.output['%']
        }, this.returnValueData, 'output', this.VARIABLE_KIND["return"], this.VARIABLE_SCOPE_KIND.output);
        this.completeTestCaseData(this.testCaseData.data.output['%'], this.variablesData.output['%']);
      } // 全局输出变量


      this.buildFields(this.testCaseData.data.output.global, this.variablesData.output.global, this.globalOutputData, 'output.global', this.VARIABLE_KIND.global, this.VARIABLE_SCOPE_KIND.output); // 指针目标输出变量

      this.buildFields(this.testCaseData.data.output.malloc, this.variablesData.output.malloc, this.mallocOutputData, 'output.malloc', this.VARIABLE_KIND.mallocVariable, this.VARIABLE_SCOPE_KIND.output);

      try {
        // 绝对地址基地址输出
        this.buildFixedAddressesOutput(this.testCaseData.data.output.fixedAddrs, this.variablesData.output.fixedAddrs, this.fixedAddressBasesOutputData, 'output.fixedAddrs', this.VARIABLE_SCOPE_KIND.output); // 局部静态变量输出

        this.buildStatics(this.testCaseData.data.output.statics, this.variablesData.output.statics, this.staticsOutputData, 'output.statics', this.VARIABLE_SCOPE_KIND.output); // 添加unused标记

        this.addUnusedTag4StaticOutput();
      } catch (error) {
        console.error(error);
      }

      this.buildExceptionFields();
    }
    /**
     * 更改结构体的构造函数
     * @param result 数据结果
     * @param constructorMangled 构造函数mangled值
     */
    ;

    _proto.changeRecordConstructor = function changeRecordConstructor(result, constructorMangled) {
      var init = {};
      init['@init'] = {};
      init['@init']['@ctor'] = {};
      init['@init']['@ctor']['@value'] = constructorMangled;
      this.setField(result, 'children', []);
      result.fieldPath = result.originFieldPath;

      if (result.init) {
        result.init['@init']['@ctor']['@value'] = constructorMangled;
      }

      this.buildFieldsByTypeName(result.originData, result.typeName, result, this.VARIABLE_SCOPE_KIND.input, init);
    }
    /**
     * 去除全局常量
     */
    ;

    _proto.removeConstGlobalVariable = function removeConstGlobalVariable() {
      var _this2 = this;

      if (!this.variablesData || !this.typeSystemData) {
        return;
      } // 去除有value值的全局常量


      if (this.variablesData.variables && this.variablesData.variables.global) {
        Object.keys(this.variablesData.variables.global).forEach(function (key) {
          var globalVariable = _this2.variablesData.variables.global[key];
          var type = _this2.typeSystemData.types[globalVariable['@type']];
          var isConst = type && type['@attributes'].indexOf('isConst') >= 0;

          if (globalVariable['@value'] && isConst) {
            delete _this2.variablesData.variables.global[key];
          }

          if (_this2.variablesData.output && _this2.variablesData.output.global && isConst) {
            delete _this2.variablesData.output.global[key];
          }
        });
      }
    }
    /**
     * 构建输入指针目标数据
     */
    ;

    _proto.buildInputMallocVariables = function buildInputMallocVariables() {
      var _this3 = this;

      Object.keys(this.variablesData.malloc).forEach(function (variableName) {
        if (!_this3.testCaseData.data.malloc[variableName]) {
          _this3.testCaseData.data.malloc[variableName] = {};
        }

        if (!_this3.testCaseData.data.malloc[variableName]['@init']) {
          _this3.testCaseData.data.malloc[variableName]['@init'] = {};
        }

        if (_this3.variablesData.malloc[variableName]['@elementType']) {
          // 数组
          if (!_this3.testCaseData.data.malloc[variableName]['@init']['#']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['#'] = {};
          }

          if (!_this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['#']['@init'] = {};
          }

          if (!_this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']['@ctor']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']['@ctor'] = {};
          }

          if (!_this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']['@ctor']['@value']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']['@ctor']['@value'] = '';
          }

          if (!_this3.variablesData.malloc[variableName]['@init']) {
            return;
          }

          if (!_this3.variablesData.malloc[variableName]['@init']['#']) {
            return;
          }

          if (!_this3.variablesData.malloc[variableName]['@init']['#']['@init']) {
            return;
          }

          if (!_this3.variablesData.malloc[variableName]['@init']['#']['@init']['@ctor']) {
            return;
          }

          if (!_this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']['@ctor']['@value']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['#']['@init']['@ctor']['@value'] = _this3.variablesData.malloc[variableName]['@init']['#']['@init']['@ctor']['@value'];
          }
        } else {
          // 非数组
          if (!_this3.testCaseData.data.malloc[variableName]['@init']['@ctor']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['@ctor'] = {};
          }

          if (!_this3.testCaseData.data.malloc[variableName]['@init']['@ctor']['@value']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['@ctor']['@value'] = '';
          }

          if (!_this3.variablesData.malloc[variableName]['@init']) {
            return;
          }

          if (!_this3.variablesData.malloc[variableName]['@init']['@ctor']) {
            return;
          }

          if (!_this3.testCaseData.data.malloc[variableName]['@init']['@ctor']['@value']) {
            _this3.testCaseData.data.malloc[variableName]['@init']['@ctor']['@value'] = _this3.variablesData.malloc[variableName]['@init']['@ctor']['@value'];
          }
        }
      });
      this.buildFields(this.testCaseData.data.malloc, this.variablesData.malloc, this.mallocVariablesData, 'malloc', this.VARIABLE_KIND.mallocVariable, this.VARIABLE_SCOPE_KIND.input);
    }
    /**
     * 构建测试用例字段数据
     * @param testCaseData 当前测试用例数据
     * @param variablesData 变量信息数据
     * @param results 结果集合
     * @param fieldPath 字段路径
     * @param kind 变量类型
     * @param scope 变量范围
     */
    ;

    _proto.buildFields = function buildFields(testCaseData, variablesData, results, fieldPath, kind, scope) {
      var _this4 = this;

      if (!variablesData) {
        return;
      } // 检查testCase变量的域是否在函数变量与类型系统中有定义，未找到则测试用例不合法


      Object.keys(testCaseData).forEach(function (name) {
        if (!variablesData[name]) {
          _this4.isLegal = false;
        }
      });
      Object.keys(variablesData).sort(function (a, b) {
        return parseInt(variablesData[a]['@index']) - parseInt(variablesData[b]['@index']);
      }).forEach(function (name) {
        if (!testCaseData[name]) {
          testCaseData[name] = {};
        }

        var variable = variablesData[name];
        var result = {
          fieldPath: fieldPath + "." + name + ".@value",
          initFieldPath: fieldPath + "." + name + ".@init",
          name: TestCaseTransformer.formatFieldName(name),
          typeName: variable['@type'],
          kind: kind,
          scope: scope,
          fileId: testCaseData[name].fileId || variable.fileId,
          filePath: testCaseData[name].filePath || variable.filePath,
          originalName: variable.originalName
        }; // 形参

        if ('variables.params' === fieldPath) {
          result.fileId = result.fileId || _this4.variablesData.fileId;
        }

        if (variable['@elementType']) {
          // 数组类型，通过元素类型构建
          var elementType = variable['@elementType'];
          var length = variable['@length'];

          _this4.buildFieldsByElementTypeName(testCaseData[name], elementType, length, result, scope);
        } else {
          var typeName = variable['@type'];

          _this4.buildFieldsByTypeName(testCaseData[name], typeName, result, scope);
        }

        results.push(result);

        if (scope !== _this4.VARIABLE_SCOPE_KIND.output) {
          _this4.completeTestCaseData(testCaseData[name], variable);
        }
      });
    }
    /**
     * 构建成员函数所属类数据
     */
    ;

    _proto.buildObjectFields = function buildObjectFields() {
      if (!this.variablesData.objectName) {
        return;
      } // 输入


      if (!this.testCaseData.data.object) {
        this.testCaseData.data.object = {
          '@value': ''
        };
      }

      var inputResult = {
        fieldPath: 'object.@value',
        initFieldPath: 'object.@init',
        name: '',
        kind: this.VARIABLE_KIND.object,
        scope: this.VARIABLE_SCOPE_KIND.input
      };
      this.objectData.push(inputResult);
      this.buildFieldsByTypeName(this.testCaseData.data.object, this.variablesData.objectName, inputResult, this.VARIABLE_SCOPE_KIND.input); // 输出

      if (!this.variablesData.output.object) {
        return;
      }

      if (!this.testCaseData.data.output.object) {
        this.testCaseData.data.output.object = {
          '@value': ''
        };
      }

      var outputResult = {
        fieldPath: 'output.object.@value',
        initFieldPath: 'output.object.@init',
        name: '',
        kind: this.VARIABLE_KIND.object,
        scope: this.VARIABLE_SCOPE_KIND.output
      };
      this.objectOutputData.push(outputResult);
      this.buildFieldsByTypeName(this.testCaseData.data.output.object, this.variablesData.objectName, outputResult, this.VARIABLE_SCOPE_KIND.output);
    }
    /**
     * 构建测试用例绝对地址输出数据
     * @param testCaseData 当前测试用例数据
     * @param variablesData 变量信息数据
     * @param results 结果集合
     * @param fieldPath 字段路径
     * @param scope 变量范围
     */
    ;

    _proto.buildFixedAddressesOutput = function buildFixedAddressesOutput(testCaseData, variablesData, results, fieldPath, scope) {
      var _this5 = this;

      // 绝对地址基地址
      var testCaseBases = this.testCaseData.data.output.fixedAddrs;
      Object.keys(variablesData).forEach(function (name) {
        if (!testCaseBases[name]) {
          testCaseBases[name] = {};
        }

        if (!testCaseBases[name].pointerTargets) {
          testCaseBases[name].pointerTargets = {};
        }

        var fixedAddressBase = {
          fieldPath: "output.fixedAddrs." + name + ".pointerTargets",
          name: variablesData[name]['@hex'],
          baseSystem: {
            '@hex': variablesData[name]['@hex'],
            '@dec': variablesData[name]['@dec']
          },
          kind: _this5.VARIABLE_KIND.fixedAddressBase,
          scope: scope,
          data: testCaseBases[name],
          children: [],
          type: _this5.VARIABLE_TYPE.fixedAddress,
          fileId: variablesData[name].fileId,
          filePath: variablesData[name].filePath,
          originalName: variablesData[name].originalName
        };
        results.push(fixedAddressBase);

        _this5.buildFields(testCaseBases[name].pointerTargets, variablesData[name].pointerTargets, fixedAddressBase.children, fixedAddressBase.fieldPath, _this5.VARIABLE_KIND.fixedAddressOffset, scope);
      });
    }
    /**
     * 构建测试用例局部静态变量数据
     * @param testCaseData 当前测试用例数据
     * @param variablesData 变量信息数据
     * @param results 结果集合
     * @param fieldPath 字段路径
     * @param scope 变量范围
     */
    ;

    _proto.buildStatics = function buildStatics(testCaseData, variablesData, results, fieldPath, scope) {
      var _this6 = this;

      Object.keys(variablesData).forEach(function (index) {
        if (!testCaseData[index]) {
          testCaseData[index] = {};
        }

        var variable = variablesData[index];
        var name = variable['@name'];
        var result = {
          fieldPath: fieldPath + "." + index + ".@value",
          initFieldPath: fieldPath + "." + name + ".@init",
          name: TestCaseTransformer.formatFieldName(name),
          typeName: variable['@type'],
          kind: _this6.VARIABLE_KIND.statics,
          scope: scope,
          location: variable.location,
          index: index,
          fileId: testCaseData[index].fileId || variable.fileId,
          filePath: testCaseData[index].filePath || variable.filePath,
          originalName: variable.originalName
        };

        if (variable['@elementType']) {
          // 数组类型，通过元素类型构建
          var elementType = variable['@elementType'];
          var length = variable['@length'];

          _this6.buildFieldsByElementTypeName(testCaseData[index], elementType, length, result, scope);
        } else {
          var typeName = variable['@type'];

          _this6.buildFieldsByTypeName(testCaseData[index], typeName, result, scope);
        }

        results.push(result);

        if (scope !== _this6.VARIABLE_SCOPE_KIND.output) {
          _this6.completeTestCaseData(testCaseData[index], variable);
        }
      });
    }
    /**
     * 根据类型名，通过类型系统构建字段列表
     * @param testCaseData 用例数据
     * @param elementTypeName 元素类型名称
     * @param length 数组长度
     * @param result 结果集合
     * @param scope 变量范围
     * @param indexes 要显示的下标数组
     */
    ;

    _proto.buildFieldsByElementTypeName = function buildFieldsByElementTypeName(testCaseData, elementTypeName, length, result, scope, indexes) {
      var _this7 = this;

      if (indexes === void 0) {
        indexes = [];
      }

      testCaseData['@elementType'] = elementTypeName;
      testCaseData['@length'] = length;
      result.elementTypeName = elementTypeName;
      result.length = length ? Number.parseInt(length.toString(), 10) : 0;
      result.type = this.VARIABLE_TYPE.array;
      result.scope = scope;
      this.setField(result, 'children', []);
      result.data = testCaseData;

      if (!testCaseData['@value']) {
        testCaseData['@value'] = {};
      }

      if (indexes.length === 0) {
        Object.keys(testCaseData['@value']).forEach(function (indexKey) {
          indexes.push(Number.parseInt(indexKey, 10));
        });
      }

      if (indexes.length === 0) {
        indexes.push(0);
      }

      indexes.sort(function (prev, next) {
        return prev - next;
      });
      indexes = indexes.filter(function (index) {
        return !result.length || index < result.length;
      });
      result.indexs = indexes;
      indexes.forEach(function (index) {
        var init = undefined;

        if (!testCaseData['@init']) {
          testCaseData['@init'] = {};
        }

        if (!testCaseData['@init'][index.toString()] && testCaseData['@init']['#']) {
          testCaseData['@init'][index.toString()] = JSON.parse(JSON.stringify(testCaseData['@init']['#']));
        }

        init = testCaseData['@init'][index.toString()];

        if (!testCaseData['@value'][index.toString()]) {
          testCaseData['@value'][index.toString()] = {};
        }

        var child = {
          fieldPath: result.fieldPath + "." + index + ".@value",
          initFieldPath: result.initFieldPath + "." + index + ".@init",
          name: TestCaseTransformer.formatElementFieldName(result.name, index),
          typeName: elementTypeName,
          kind: _this7.VARIABLE_KIND.field,
          scope: scope,
          fileId: result.fileId,
          filePath: result.filePath
        };
        result.children.push(child);

        _this7.buildFieldsByTypeName(testCaseData['@value'][index.toString()], elementTypeName, child, scope, init);

        if (scope !== _this7.VARIABLE_SCOPE_KIND.output) {
          _this7.completeTestCaseData(testCaseData['@value'][index.toString()], {
            '@type': elementTypeName
          });
        }
      });

      if (scope !== this.VARIABLE_SCOPE_KIND.output) {
        this.completeTestCaseData(testCaseData, {
          '@elementType': elementTypeName,
          '@length': length
        });
      }
    }
    /**
     * 构建初始化构造函数
     * @param testCaseData 用例数据
     * @param typeName 类型名称
     * @param result 结果集合
     * @param init 初始化数据
     */
    ;

    _proto.buildRecordConstructorFields = function buildRecordConstructorFields(testCaseData, recordType, result, init) {
      var _this8 = this;

      if (!recordType['@constructors']) {
        return;
      } // 构造函数


      result.data = testCaseData;
      result.init = init;
      result.constructors = recordType['@constructors'];

      if (!init['@init']) {
        init['@init'] = {};
      }

      if (!init['@init']['@ctor']) {
        init['@init']['@ctor'] = {};
      }

      if (!init['@init']['@ctor']['@value']) {
        init['@init']['@ctor']['@value'] = '';
      }

      result.originData = result.data;
      result.data = init['@init']['@ctor']; // 参数

      if (!result.children) {
        result.children = [];
      }

      var child;
      result.constructors.forEach(function (ctor) {
        if (child) {
          return;
        }

        if (ctor['@mangled'] !== init['@init']['@ctor']['@value']) {
          return;
        }

        if (!init['@init']['@ctor']['@params']) {
          init['@init']['@ctor']['@params'] = {};
        }

        child = {
          fieldPath: result.fieldPath.slice(0, -'@value'.length) + "@params",
          kind: _this8.VARIABLE_KIND.field,
          name: TestCaseTransformer.formatStubFieldName('', ctor['@name'], ctor.params, ctor['@scopes']),
          typeName: '',
          children: []
        };

        if (!ctor.params) {
          return;
        }

        _this8.addConstructorParamFields(init['@init']['@ctor']['@params'], ctor.params, child.children, child.fieldPath);
      });

      if (child) {
        result.children.push(child);
      }
    }
    /**
     * 添加构造函数参数字段
     * @param testCaseData 测试用例数据
     * @param paramsData 参数数据定义
     * @param results 结果集合
     * @param fieldPath 字段路径
     */
    ;

    _proto.addConstructorParamFields = function addConstructorParamFields(testCaseData, paramsData, results, fieldPath) {
      var _this9 = this;

      paramsData.forEach(function (param, index) {
        var strIndex = index.toString();

        if (!testCaseData[strIndex]) {
          testCaseData[strIndex] = {
            '@value': ''
          };
        }

        testCaseData[strIndex]['@type'] = param['@type'];
        var result = {
          fieldPath: fieldPath + "." + strIndex + ".@value",
          name: param['@name'] || '',
          kind: _this9.VARIABLE_KIND.constructorParam,
          scope: _this9.VARIABLE_SCOPE_KIND.input
        };
        results.push(result);

        _this9.buildFieldsByTypeName(testCaseData[strIndex], param['@type'], result, _this9.VARIABLE_SCOPE_KIND.input);
      });
    }
    /**
     * 根据类型名，通过类型系统构建字段列表
     * @param testCaseData 用例数据
     * @param typeName 类型名称
     * @param result 结果集合
     * @param scope 变量范围
     * @param init 元素初始化数据
     */
    ;

    _proto.buildFieldsByTypeName = function buildFieldsByTypeName(testCaseData, typeName, result, scope, init) {
      if (init === void 0) {
        init = undefined;
      }

      testCaseData['@type'] = typeName;
      result.typeName = typeName;
      var unqualifiedType = this.getUnqualifiedType(typeName);

      if (!unqualifiedType) {
        this.isLegal = false;
        return;
      }

      var attributes = unqualifiedType['@attributes'];
      var attributeSet = new Set(attributes);
      result.data = testCaseData;

      if (attributeSet.has('isRecord') || attributeSet.has('isCXXRecord')) {
        // 结构体
        result.originFieldPath = result.fieldPath;

        if ((attributeSet.has('isClass') || attributeSet.has('isStructure')) && result.kind !== this.VARIABLE_KIND.stubMemberVariable) {
          result.fieldPath = result.initFieldPath + ".@ctor.@value";

          if (scope === this.VARIABLE_SCOPE_KIND.input) {
            this.buildRecordConstructorFields(testCaseData, unqualifiedType, result, init || testCaseData);
          }
        }

        if (!testCaseData['@value']) {
          testCaseData['@value'] = {};
        }

        result.type = this.VARIABLE_TYPE.record;

        if (!result.children) {
          result.children = [];
        }

        var fields = unqualifiedType['@fields'];
        this.buildFields(testCaseData['@value'], fields, result.children, result.originFieldPath, this.VARIABLE_KIND.field, scope);
        return;
      }

      if (attributeSet.has('isArray')) {
        // 数组
        if (!unqualifiedType['@elementType']) {
          this.isLegal = false;
          console.error("Can't find element type in array type: " + unqualifiedType);
          return;
        }

        result.type = this.VARIABLE_TYPE.array;
        var elementType = unqualifiedType['@elementType'];
        var length = unqualifiedType['@length'];
        this.buildFieldsByElementTypeName(testCaseData, elementType, length, result, scope);
        return;
      } // 剩余情况下值应该是简单类型，否则类型不一致


      if (isArrayType(testCaseData['@value']) || isObjectType(testCaseData['@value'])) {
        this.isLegal = false;
      }

      if (attributeSet.has('isFunctionPointer')) {
        // 函数指针
        result.type = this.VARIABLE_TYPE.functionPointer;
        var pointeeTypeName = unqualifiedType['@pointeeType'];
        result.functionType = this.typeSystemData.types[pointeeTypeName];
        result.returnTypeName = result.functionType['%'] ? result.functionType['%']['@type'] : 'void';
        return;
      }

      if (attributeSet.has('isPointer')) {
        // 指针
        result.type = this.VARIABLE_TYPE.pointer;
        result.pointeeType = unqualifiedType['@pointeeType'];
        return;
      }

      if (attributeSet.has('isReference')) {
        // 引用
        result.type = this.VARIABLE_TYPE.reference;
        result.pointeeType = unqualifiedType['@pointeeType'];
        return;
      }

      if (attributeSet.has('isEnumeral')) {
        // 枚举
        result.type = this.VARIABLE_TYPE.enumeration;
        return;
      } // 基本类型


      result.type = this.VARIABLE_TYPE.basic;
    }
    /**
     * 构建绝对地址数据
     */
    ;

    _proto.buildFixedAddresses = function buildFixedAddresses() {
      var _this10 = this;

      var scope = this.VARIABLE_SCOPE_KIND.input; // 绝对地址表达式

      var testCaseExpressions = this.testCaseData.data.fixedAddrs['exprs'];
      var variableExpressions = this.variablesData.fixedAddrs['exprs'];
      Object.keys(variableExpressions).forEach(function (name) {
        if (!variableExpressions[name].enabled) {
          return;
        }

        if (!testCaseExpressions[name]) {
          testCaseExpressions[name] = {
            '@value': ''
          };
        }

        _this10.fixedAddressExpressionsData.push({
          fieldPath: "fixedAddrs.exprs." + name + ".@value",
          name: name,
          kind: _this10.VARIABLE_KIND.fixedAddressExpression,
          scope: scope,
          data: testCaseExpressions[name],
          locations: variableExpressions[name].locations,
          type: _this10.VARIABLE_TYPE.fixedAddress,
          fileId: testCaseExpressions[name].fileId || variableExpressions[name].fileId,
          filePath: testCaseExpressions[name].filePath || variableExpressions[name].filePath,
          originalName: variableExpressions[name].originalName
        });
      }); // 绝对地址基地址

      var testCaseBases = this.testCaseData.data.fixedAddrs['bases'];
      var variableBases = this.variablesData.fixedAddrs['bases'];
      Object.keys(variableBases).forEach(function (name) {
        if (!testCaseBases[name]) {
          testCaseBases[name] = {};
        }

        if (!testCaseBases[name].pointerTargets) {
          testCaseBases[name].pointerTargets = {};
        }

        var fixedAddressBase = {
          fieldPath: "fixedAddrs.bases." + name + ".pointerTargets",
          name: variableBases[name]['@hex'],
          kind: _this10.VARIABLE_KIND.fixedAddressBase,
          scope: scope,
          baseSystem: {
            '@hex': variableBases[name]['@hex'],
            '@dec': variableBases[name]['@dec']
          },
          data: testCaseBases[name],
          children: [],
          type: _this10.VARIABLE_TYPE.fixedAddress,
          fileId: testCaseBases[name].fileId || variableBases[name].fileId,
          filePath: testCaseBases[name].filePath || variableBases[name].filePath,
          originalName: variableBases[name].originalName
        };

        _this10.fixedAddressBasesData.push(fixedAddressBase);

        _this10.buildFields(testCaseBases[name].pointerTargets, variableBases[name].pointerTargets, fixedAddressBase.children, fixedAddressBase.fieldPath, _this10.VARIABLE_KIND.fixedAddressOffset, scope);
      });
    }
    /**
     * 构建桩函数数据
     * @param stubName 桩函数名
     */
    ;

    _proto.buildStubFields = function buildStubFields(stubName) {
      var _this11 = this;

      if (!this.testCaseData.data.stubs[stubName]) {
        this.testCaseData.data.stubs[stubName] = {
          '@value': ''
        };
      }

      var stub = this.variablesData.stubs[stubName];
      this.testCaseData.data.stubs[stubName]['@type'] = stub;
      var returnTypeName = stub['%'] ? stub['%']['@type'] : 'void';
      var times = [];
      var currentTimes = this.testCaseData.data.stubs[stubName].times;

      if (!currentTimes && currentTimes !== 0) {
        currentTimes = stub.times;
      }

      if (!currentTimes) {
        currentTimes = 0;
      }

      for (var i = 0; i <= currentTimes; i += 1) {
        times.push(i);
      }

      var result = {
        fieldPath: "stubs." + stubName,
        kind: this.VARIABLE_KIND.stub,
        name: TestCaseTransformer.formatStubFieldName(returnTypeName, stub['@name'] || stubName, stub.params, stub['@scopes']),
        stubName: stubName,
        typeName: returnTypeName,
        times: times,
        time: 0,
        currentTimes: currentTimes,
        currentStubKind: this.testCaseData.data.stubs[stubName].kind || this.STUB_KIND.value,
        children: [],
        data: stub,
        fileId: this.testCaseData.data.stubs[stubName].fileId || stub.fileId,
        filePath: this.testCaseData.data.stubs[stubName].filePath || stub.filePath,
        originalName: stub.originalName
      };
      this.stubsData.push(result);

      if (result.currentStubKind === this.STUB_KIND.code) {
        //We don't need subelement when it's code stub
        return;
      }

      this.addStubOutputFields(stubName, result.time, result.children);

      if (this.testCaseData.data.stubs[stubName]['@value']) {
        var templateData = [];
        Object.keys(this.testCaseData.data.stubs[stubName]['@value']).forEach(function (time) {
          _this11.addStubOutputFields(stubName, parseInt(time, 10), templateData);
        });
        templateData = [];
      }

      this.completeTestCaseStubData(stubName);
    }
    /**
     * 构建桩函数输出字段（返回值、指针参数）列表
     * @param stubName 桩函数名称
     * @param time 调用次数
     * @param results 结果集合
     */
    ;

    _proto.addStubOutputFields = function addStubOutputFields(stubName, time, results) {
      var _this12 = this;

      var stubPath = "stubs." + stubName + ".@value." + time;
      var stub = this.variablesData.stubs[stubName];

      if (!this.testCaseData.data.stubs[stubName]['@value']) {
        this.testCaseData.data.stubs[stubName]['@value'] = {};
      }

      if (!this.testCaseData.data.stubs[stubName]['@value'][time]) {
        this.testCaseData.data.stubs[stubName]['@value'][time] = {};
      }

      var stubTestCaseData = this.testCaseData.data.stubs[stubName]['@value'][time]; // 返回值

      if (stub['%']) {
        this.buildFields({
          '%': stubTestCaseData['%']
        }, {
          '%': stub['%']
        }, results, stubPath, this.VARIABLE_KIND.stubReturn, this.VARIABLE_SCOPE_KIND.input);
      } // 参数列表


      if (stub.params && stub.params.length > 0) {
        if (!stubTestCaseData.params) {
          stubTestCaseData.params = {};
        }

        var params = stub.params;
        params.forEach(function (param, index) {
          var strIndex = index.toString();

          if (!stubTestCaseData.params[strIndex]) {
            stubTestCaseData.params[strIndex] = {
              '@value': ''
            };
          }

          stubTestCaseData.params[strIndex]['@type'] = stub.params[strIndex]['@type'];
          var result = {
            fieldPath: stubPath + ".params." + strIndex + ".@value",
            name: param['@name'] || '',
            kind: _this12.VARIABLE_KIND.stubParam,
            scope: _this12.VARIABLE_SCOPE_KIND.input,
            stubPath: stubPath,
            fileId: stub.fileId,
            filePath: stub.filePath
          };
          results.push(result);

          _this12.buildFieldsByTypeName(stubTestCaseData.params[strIndex], param['@type'], result, _this12.VARIABLE_SCOPE_KIND.input);
        });
      } // 成员变量


      if (stub['@object']) {
        if (!stubTestCaseData.fields) {
          stubTestCaseData.fields = {};
        }

        var result = {
          fieldPath: stubPath + ".fields",
          name: 'Member Variables',
          kind: this.VARIABLE_KIND.stubMemberVariable,
          scope: this.VARIABLE_SCOPE_KIND.input,
          typeName: '',
          constructors: undefined,
          fileId: stub.fileId,
          filePath: stub.filePath
        };
        results.push(result);
        this.buildFieldsByTypeName({
          '@value': stubTestCaseData.fields
        }, stub['@object'], result, this.VARIABLE_SCOPE_KIND.input);
        result.typeName = '';
        delete result.constructors;
      } // 指针目标


      if (stub.pointerTargets) {
        if (!stubTestCaseData.pointerTargets) {
          stubTestCaseData.pointerTargets = {};
        }

        this.buildFields(stubTestCaseData.pointerTargets, stub.pointerTargets, results, stubPath + ".pointerTargets", this.VARIABLE_KIND.stubPointerTarget, this.VARIABLE_SCOPE_KIND.input);
      }
    }
    /**
     * 构造异常字段
     */
    ;

    _proto.buildExceptionFields = function buildExceptionFields() {
      var _this13 = this;

      if (!this.variablesData.output.exceptions) {
        return;
      }

      if (!this.testCaseData.data.output.exceptions) {
        this.testCaseData.data.output.exceptions = {};
      }

      this.variablesData.output.exceptions.forEach(function (exception, index) {
        var strIndex = index.toString();

        if (!_this13.testCaseData.data.output.exceptions[strIndex]) {
          _this13.testCaseData.data.output.exceptions[strIndex] = {
            '@value': ''
          };
        }

        _this13.testCaseData.data.output.exceptions[strIndex]['@type'] = exception['@type'];
        var result = {
          fieldPath: "output.exceptions." + strIndex + ".@value",
          initFieldPath: "output.exceptions." + strIndex + ".@init",
          name: '',
          kind: _this13.VARIABLE_KIND.exception,
          scope: _this13.VARIABLE_SCOPE_KIND.output
        };

        _this13.exceptionsOutputData.push(result);

        _this13.buildFieldsByTypeName(_this13.testCaseData.data.output.exceptions[strIndex], exception['@type'], result, _this13.VARIABLE_SCOPE_KIND.output);
      });
    }
    /**
     * 添加静态变量输出项的unused标记
     */
    ;

    _proto.addUnusedTag4StaticOutput = function addUnusedTag4StaticOutput() {
      var _this14 = this;

      if (!this.testCaseData.data.output.unused) {
        return;
      }

      if (!this.testCaseData.data.output.unused.statics) {
        return;
      }

      var data = [];
      this.testCaseData.data.output.unused.statics.forEach(function (index) {
        data.push(_this14.staticsOutputData[Number.parseInt(index, 10)]);
      });

      while (data.length > 0) {
        var item = data.pop();
        item.unused = true;

        if (item.children) {
          item.children.forEach(function (child) {
            data.push(child);
          });
        }
      }
    }
    /**
     * 设置字段数据
     * @param obj 对象
     * @param key 键
     * @param value  值
     */
    ;

    _proto.setField = function setField(obj, key, value) {
      obj[key] = value;
    }
    /**
     * 清空测试用例表结构数据
     */
    ;

    _proto.clearData = function clearData() {
      this.objectData = [];
      this.paramVariablesData = [];
      this.globalVariablesData = [];
      this.fixedAddressExpressionsData = [];
      this.fixedAddressBasesData = [];
      this.staticsData = [];
      this.stubsData = [];
      this.mallocVariablesData = [];
      this.returnValueData = [];
      this.globalOutputData = [];
      this.mallocOutputData = [];
      this.fixedAddressBasesOutputData = [];
      this.staticsOutputData = [];
      this.exceptionsOutputData = [];
      this.objectOutputData = [];
    }
    /**
     * Get data from types of type API by typeName, for selection/display
     * @param typeName 类型名称
     */
    ;

    _proto.getUnqualifiedType = function getUnqualifiedType(typeName) {
      if (!this.typeSystemData || !this.typeSystemData.types) {
        console.error("TypeSystemData or typeSystemData.types not exsist");
        return null;
      }

      var type = this.typeSystemData.types[typeName];

      if (!type) {
        console.error("Can't find the type(" + typeName + ") in typeSystem: " + JSON.stringify(this.typeSystemData));
        return null;
      }

      var canonicalType = this.typeSystemData.types[type['@canonical']];

      if (!canonicalType) {
        console.error("Can't find the canonical type(" + type['@canonical'] + ") in typeSystem: " + JSON.stringify(this.typeSystemData));
        return null;
      }

      var unqualifiedType = this.typeSystemData.types[canonicalType['@unqualified']];

      if (!unqualifiedType) {
        console.error("Can't find the unqualified type(" + canonicalType['@unqualified'] + ") in typeSystem: " + JSON.stringify(this.typeSystemData));
        return null;
      }

      var attributes = unqualifiedType['@attributes'];
      var attributeSet = new Set(attributes);

      if (attributeSet.has('isRecord')) {
        unqualifiedType['@fields'] = unqualifiedType['@fields'] || {};
      }

      return unqualifiedType;
    }
    /**
     * 补全测试用例数据，包括@value，@type，@elementType，@length
     * @param testCaseData 测试用例数据
     * @param variablesData 函数变量信息数据
     * @param defaultValue 默认值
     */
    ;

    _proto.completeTestCaseData = function completeTestCaseData(testCaseData, variablesData, defaultValue) {
      if (defaultValue === void 0) {
        defaultValue = '';
      }

      if (!testCaseData['@value']) {
        testCaseData['@value'] = defaultValue;
      }
    }
    /**
     * 补全测试用例桩数据
     * @param {String} stubName 装函数名
     */
    ;

    _proto.completeTestCaseStubData = function completeTestCaseStubData(stubName) {
      return;
    }
    /**
     * 清除空字段
     * @param testCase 用例数据
     */
    ;

    TestCaseTransformer.removeEmptyField = function removeEmptyField(testCase) {
      if (isObjectType(testCase)) {
        // 对象
        delete testCase['@type'];
        delete testCase['@elementType'];
        delete testCase['@length'];
        Object.keys(testCase).forEach(function (key) {
          TestCaseTransformer.removeEmptyField(testCase[key]);

          if (isObjectType(testCase[key])) {
            if (Object.keys(testCase[key]).length > 0) {
              return;
            }
          } else if (isArrayType(testCase[key])) {
            if (testCase[key].length > 0) {
              return;
            }
          } else if (testCase[key] || testCase[key] === '') {
            return;
          }

          delete testCase[key];
        });
      } else if (isArrayType(testCase)) {
        // 数组
        testCase.forEach(function (item) {
          TestCaseTransformer.removeEmptyField(item);
        });
      }
    }
    /**
     * 格式化字段名
     * @param fieldName 原字段名
     */
    ;

    TestCaseTransformer.formatFieldName = function formatFieldName(fieldName) {
      return fieldName === '%' ? 'return' : fieldName;
    }
    /**
     * 格式化（数组）元素字段名
     * @param arrayName 数组名
     * @param index 下标
     */
    ;

    TestCaseTransformer.formatElementFieldName = function formatElementFieldName(arrayName, index) {
      return arrayName + "[" + index + "]";
    }
    /**
     * 格式化桩函数字段名
     * @param returnTypeName 返回类型名
     * @param stubName 桩函数名
     * @param params 参数列表
     * @param scopes 空间名
     */
    ;

    TestCaseTransformer.formatStubFieldName = function formatStubFieldName(returnTypeName, stubName, params, scopes) {
      var names = [];

      if (scopes) {
        for (var i = scopes.length - 1; i >= 0; i -= 1) {
          names.push(scopes[i]['@name']);
        }
      }

      names.push(stubName);
      var fieldName = names.join('::') + "(";

      if (params) {
        params.forEach(function (param, index) {
          if (index > 0) {
            fieldName += ', ';
          }

          fieldName += param['@type'] + " " + param['@name'];
        });
      }

      fieldName += ')';
      return fieldName;
    }
    /**
     * 清除functionvariable原始数据
     */
    ;

    _proto.clearVariablesData = function clearVariablesData() {
      this.variablesData = {};
    }
    /**
    * 清除测试用例原始数据
    */
    ;

    _proto.clearTestCaseData = function clearTestCaseData() {
      this.testCaseData = {};
    }
    /**
    * 清除类型系统原始数据
    */
    ;

    _proto.clearTypeSystemData = function clearTypeSystemData() {
      this.typeSystemData = {};
    };

    return TestCaseTransformer;
  }();

  function _inheritsLoose(subClass, superClass) {
    subClass.prototype = Object.create(superClass.prototype);
    subClass.prototype.constructor = subClass;
    subClass.__proto__ = superClass;
  }

  function _getPrototypeOf(o) {
    _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) {
      return o.__proto__ || Object.getPrototypeOf(o);
    };
    return _getPrototypeOf(o);
  }

  function _setPrototypeOf(o, p) {
    _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) {
      o.__proto__ = p;
      return o;
    };

    return _setPrototypeOf(o, p);
  }

  function _isNativeReflectConstruct() {
    if (typeof Reflect === "undefined" || !Reflect.construct) return false;
    if (Reflect.construct.sham) return false;
    if (typeof Proxy === "function") return true;

    try {
      Date.prototype.toString.call(Reflect.construct(Date, [], function () {}));
      return true;
    } catch (e) {
      return false;
    }
  }

  function _construct(Parent, args, Class) {
    if (_isNativeReflectConstruct()) {
      _construct = Reflect.construct;
    } else {
      _construct = function _construct(Parent, args, Class) {
        var a = [null];
        a.push.apply(a, args);
        var Constructor = Function.bind.apply(Parent, a);
        var instance = new Constructor();
        if (Class) _setPrototypeOf(instance, Class.prototype);
        return instance;
      };
    }

    return _construct.apply(null, arguments);
  }

  function _isNativeFunction(fn) {
    return Function.toString.call(fn).indexOf("[native code]") !== -1;
  }

  function _wrapNativeSuper(Class) {
    var _cache = typeof Map === "function" ? new Map() : undefined;

    _wrapNativeSuper = function _wrapNativeSuper(Class) {
      if (Class === null || !_isNativeFunction(Class)) return Class;

      if (typeof Class !== "function") {
        throw new TypeError("Super expression must either be null or a function");
      }

      if (typeof _cache !== "undefined") {
        if (_cache.has(Class)) return _cache.get(Class);

        _cache.set(Class, Wrapper);
      }

      function Wrapper() {
        return _construct(Class, arguments, _getPrototypeOf(this).constructor);
      }

      Wrapper.prototype = Object.create(Class.prototype, {
        constructor: {
          value: Wrapper,
          enumerable: false,
          writable: true,
          configurable: true
        }
      });
      return _setPrototypeOf(Wrapper, Class);
    };

    return _wrapNativeSuper(Class);
  }

  function _assertThisInitialized(self) {
    if (self === void 0) {
      throw new ReferenceError("this hasn't been initialised - super() hasn't been called");
    }

    return self;
  }

  /**
   * 错误定义
   *
   * Created by snowingsea on 2021/03/07.
   */

  /**
   * 错误码
   */
  var errorCode = {
    networkError: 10000,
    wrongPassword: 10001,
    userNotExists: 10002,
    wrongOldPassword: 10003,
    samePassword: 10004,
    tokenExpired: 10010,
    notFound: 11000,
    multipleUser: 20010,
    multipleProduct: 20011,
    multipleLicense: 20012,
    multipleDocument: 20013
  };
  var codeMap = new Map();
  Object.keys(errorCode).forEach(function (key) {
    codeMap.set(errorCode[key], key);
  });
  /**
   * 自定义错误类
   */

  var SmartRocketError = /*#__PURE__*/function (_Error) {
    _inheritsLoose(SmartRocketError, _Error);

    // 错误码
    // 错误信息
    // 错误详情

    /**
     * @param error 错误码|错误类
     * @param description 错误详细描述
     */
    function SmartRocketError(error, description) {
      var _this;

      if (description === void 0) {
        description = '';
      }

      _this = _Error.call(this) || this;
      Object.defineProperty(_assertThisInitialized(_this), "code", {
        enumerable: true,
        writable: true,
        value: 0
      });
      Object.defineProperty(_assertThisInitialized(_this), "message", {
        enumerable: true,
        writable: true,
        value: ''
      });
      Object.defineProperty(_assertThisInitialized(_this), "description", {
        enumerable: true,
        writable: true,
        value: ''
      });

      if (error instanceof SmartRocketError) {
        _this.code = error.code;
        _this.message = error.message;
        _this.description = description;
      } else if (error instanceof Error) {
        _this.code = errorCode.networkError;
        _this.message = codeMap.get(errorCode.networkError);
        _this.description = error.message;
      } else {
        // Error.captureStackTrace(this, this.constructor);
        _this.code = error;
        _this.message = codeMap.get(error);
        _this.description = description;
      }

      if (error instanceof Error) {
        _this.stack = error.stack;
      }

      return _this;
    }

    return SmartRocketError;
  }( /*#__PURE__*/_wrapNativeSuper(Error));

  /**
   * 服务基类
   *
   * Created by snowingsea on 2021/03/07.
   */

  var BaseService = /*#__PURE__*/function () {
    // 网络服务实例
    function BaseService(_temp) {
      var _ref = _temp === void 0 ? {} : _temp,
          _ref$protocol = _ref.protocol,
          protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
          _ref$host = _ref.host,
          host = _ref$host === void 0 ? 'localhost' : _ref$host,
          _ref$port = _ref.port,
          port = _ref$port === void 0 ? 80 : _ref$port,
          _ref$version = _ref.version,
          version = _ref$version === void 0 ? 'v2' : _ref$version;

      Object.defineProperty(this, "serviceInstance", {
        enumerable: true,
        writable: true,
        value: null
      });
      this.serviceInstance = axios__default['default'].create({
        baseURL: protocol + "://" + host + ":" + port + "/api/" + version,
        timeout: 1000
      });
    }
    /**
     * GET方法请求
     * @param url 请求路径
     * @param config 配置信息
     * @returns {Promise<Object>}
     */


    var _proto = BaseService.prototype;

    _proto.get = function get(url, config) {
      if (config === void 0) {
        config = undefined;
      }

      return this.serviceInstance.get(url, config);
    }
    /**
     * POST方法请求
     * @param url 请求路径
     * @param config 配置信息
     * @returns {Promise<Object>}
     */
    ;

    _proto.post = function post(url, config) {
      if (config === void 0) {
        config = undefined;
      }

      return this.serviceInstance.post(url, config);
    }
    /**
     * PUT方法请求
     * @param url 请求路径
     * @param config 配置信息
     * @returns {Promise<Object>}
     */
    ;

    _proto.put = function put(url, config) {
      if (config === void 0) {
        config = undefined;
      }

      return this.serviceInstance.put(url, config);
    }
    /**
     * DELETE方法请求
     * @param url 路径
     * @param config 配置信息
     * @returns {Promise<Object>}
     */
    ;

    _proto["delete"] = function _delete(url, config) {
      if (config === void 0) {
        config = undefined;
      }

      return this.serviceInstance["delete"](url, config);
    }
    /**
     * 查询当前服务是否开启
     * @returns {Promise<Object>}
     */
    ;

    _proto.ping = function ping() {
      var _this = this;

      return new Promise(function (resolve, reject) {
        _this.get('health/ping.json').then(function (res) {
          if (res.status === 200) {
            return Promise.resolve(res.data);
          }

          return Promise.reject(BaseService.createNetworkError(res));
        }).then(resolve)["catch"](function (err) {
          reject(new SmartRocketError(err));
        });
      });
    }
    /**
     * 创建网络异常错误
     * @param res 响应数据
     * @returns {SmartRocketError}
     */
    ;

    BaseService.createNetworkError = function createNetworkError(res) {
      var details = {
        status: undefined
      };

      if (res && res.data) {
        details = res.data;
      }

      if (res && res.status) {
        details.status = res.status;
      }

      return new SmartRocketError(errorCode.networkError, JSON.stringify(details));
    };

    return BaseService;
  }();

  var UserService = /*#__PURE__*/function (_BaseService) {
    _inheritsLoose(UserService, _BaseService);

    // 用户名称
    // 用户密码
    function UserService(_temp) {
      var _this;

      var _ref = _temp === void 0 ? {} : _temp,
          _ref$protocol = _ref.protocol,
          protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
          _ref$host = _ref.host,
          host = _ref$host === void 0 ? 'localhost' : _ref$host,
          _ref$port = _ref.port,
          port = _ref$port === void 0 ? 80 : _ref$port,
          _ref$version = _ref.version,
          version = _ref$version === void 0 ? 'v2' : _ref$version,
          _ref$accessToken = _ref.accessToken,
          accessToken = _ref$accessToken === void 0 ? '' : _ref$accessToken,
          _ref$username = _ref.username,
          username = _ref$username === void 0 ? '' : _ref$username,
          _ref$password = _ref.password,
          password = _ref$password === void 0 ? '' : _ref$password;

      _this = _BaseService.call(this, {
        protocol: protocol,
        host: host,
        port: port,
        version: version
      }) || this;
      Object.defineProperty(_assertThisInitialized(_this), "username", {
        enumerable: true,
        writable: true,
        value: ''
      });
      Object.defineProperty(_assertThisInitialized(_this), "password", {
        enumerable: true,
        writable: true,
        value: ''
      });
      _this.serviceInstance = axios__default['default'].create({
        baseURL: protocol + "://" + host + ":" + port + "/api/" + version,
        headers: {
          'Authorization': "Bearer " + accessToken
        }
      });
      _this.username = username;
      _this.password = password;
      return _this;
    }
    /**
     * 使用密码登录
     * @returns {Promise} 密文
     */


    var _proto = UserService.prototype;

    _proto.loginByPassword = function loginByPassword() {
      var _this2 = this;

      return new Promise(function (resolve, reject) {
        var body = {
          grantType: 'password',
          username: _this2.username,
          password: UserService.encryptPassword(_this2.password)
        };

        _this2.post('oauth2/access-token.json', body).then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(UserService.createNetworkError(res));
          }
        })["catch"](function (err) {
          var description = err.response && err.response.data && err.response.data.description;

          switch (err.response && err.response.status) {
            case 401:
              // 用户名密码不匹配
              reject(new SmartRocketError(errorCode.wrongPassword, description));
              break;

            case 403:
              // 用户不存在
              reject(new SmartRocketError(errorCode.userNotExists, description));
              break;

            case undefined:
            case null:
              reject(new SmartRocketError(err));
              break;

            default:
              reject(UserService.createNetworkError(err.response));
              break;
          }
        });
      });
    }
    /**
     * 获取用户信息
     * @returns Promise<unknown>
     */
    ;

    _proto.getMyInfo = function getMyInfo() {
      var _this3 = this;

      return new Promise(function (resolve, reject) {
        _this3.get('me.json').then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(UserService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(UserService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 更改用户信息
     * @param nickname 昵称
     * @param lang 国际化语言
     * @returns Promise<unknown>
     */
    ;

    _proto.edit = function edit(_ref2) {
      var _this4 = this;

      var nickname = _ref2.nickname,
          lang = _ref2.lang;
      return new Promise(function (resolve, reject) {
        var query = {
          nickname: nickname,
          lang: lang
        };

        _this4.put("me.json?" + querystring__default['default'].stringify(query)).then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(UserService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(UserService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 修改密码
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @returns Promise<unknown>
     */
    ;

    _proto.changePassword = function changePassword(_ref3) {
      var _this5 = this;

      var oldPassword = _ref3.oldPassword,
          newPassword = _ref3.newPassword;
      return new Promise(function (resolve, reject) {
        var body = {
          oldPassword: UserService.encryptPassword(oldPassword),
          newPassword: UserService.encryptPassword(newPassword)
        };

        _this5.put('me/password.json', body).then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(UserService.createNetworkError(res));
          }
        })["catch"](function (err) {
          var description = err.response && err.response.data && err.response.data.description;

          switch (err.response && err.response.status) {
            case 400:
              reject(new SmartRocketError(errorCode.wrongOldPassword, description));
              break;

            case 416:
              reject(new SmartRocketError(errorCode.samePassword, description));
              break;

            default:
              reject(UserService.createTokenServiceError(err));
              break;
          }
        });
      });
    }
    /**
     * 密码客户端加密
     * @param text 原文本
     * @returns 密文
     */
    ;

    UserService.encryptPassword = function encryptPassword(text) {
      return crypto__default['default'].createHash('sha256').update(text).digest('hex');
    }
    /**
     * 创建登录状态下的错误
     * @param err 错误信息
     * @returns 自定义错误
     */
    ;

    UserService.createTokenServiceError = function createTokenServiceError(err) {
      var description = err.response && err.response.data && err.response.data.description;

      switch (err.response && err.response.status) {
        case 401:
          return new SmartRocketError(errorCode.tokenExpired, description);

        case undefined:
        case null:
          return new SmartRocketError(err);

        default:
          return UserService.createNetworkError(err.response);
      }
    };

    return UserService;
  }(BaseService);

  var AdministratorBaseService = /*#__PURE__*/function (_UserService) {
    _inheritsLoose(AdministratorBaseService, _UserService);

    function AdministratorBaseService(_temp) {
      var _this;

      var _ref = _temp === void 0 ? {} : _temp,
          _ref$protocol = _ref.protocol,
          protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
          _ref$host = _ref.host,
          host = _ref$host === void 0 ? 'localhost' : _ref$host,
          _ref$port = _ref.port,
          port = _ref$port === void 0 ? 80 : _ref$port,
          _ref$version = _ref.version,
          version = _ref$version === void 0 ? 'v2' : _ref$version,
          _ref$accessToken = _ref.accessToken,
          accessToken = _ref$accessToken === void 0 ? '' : _ref$accessToken;

      _this = _UserService.call(this, {
        protocol: protocol,
        host: host,
        port: port,
        version: version
      }) || this;
      _this.serviceInstance = axios__default['default'].create({
        baseURL: protocol + "://" + host + ":" + port + "/api/" + version + "/administrator",
        headers: {
          'Authorization': "Bearer " + accessToken
        }
      });
      return _this;
    }

    return AdministratorBaseService;
  }(UserService);

  var AdministratorUsersService = /*#__PURE__*/function (_AdministratorBaseSer) {
    _inheritsLoose(AdministratorUsersService, _AdministratorBaseSer);

    function AdministratorUsersService() {
      return _AdministratorBaseSer.apply(this, arguments) || this;
    }

    var _proto = AdministratorUsersService.prototype;

    /**
     * 获取用户列表
     * @returns
     */
    _proto.getUsers = function getUsers() {
      var _this = this;

      return new Promise(function (resolve, reject) {
        _this.get('users.json').then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(AdministratorBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(AdministratorBaseService.createTokenServiceError(err));
        });
      });
    };

    return AdministratorUsersService;
  }(AdministratorBaseService);

  var AdministratorService = /*#__PURE__*/function (_UserService) {
    _inheritsLoose(AdministratorService, _UserService);

    function AdministratorService(_temp) {
      var _this;

      var _ref = _temp === void 0 ? {} : _temp,
          _ref$protocol = _ref.protocol,
          protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
          _ref$host = _ref.host,
          host = _ref$host === void 0 ? 'localhost' : _ref$host,
          _ref$port = _ref.port,
          port = _ref$port === void 0 ? 80 : _ref$port,
          _ref$version = _ref.version,
          version = _ref$version === void 0 ? 'v2' : _ref$version,
          _ref$accessToken = _ref.accessToken,
          accessToken = _ref$accessToken === void 0 ? '' : _ref$accessToken;

      _this = _UserService.call(this, {
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      }) || this;
      _this.users = new AdministratorUsersService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
      return _this;
    }

    return AdministratorService;
  }(UserService);

  var TesterBaseService = /*#__PURE__*/function (_UserService) {
    _inheritsLoose(TesterBaseService, _UserService);

    function TesterBaseService(_temp) {
      var _this;

      var _ref = _temp === void 0 ? {} : _temp,
          _ref$protocol = _ref.protocol,
          protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
          _ref$host = _ref.host,
          host = _ref$host === void 0 ? 'localhost' : _ref$host,
          _ref$port = _ref.port,
          port = _ref$port === void 0 ? 80 : _ref$port,
          _ref$version = _ref.version,
          version = _ref$version === void 0 ? 'v2' : _ref$version,
          _ref$accessToken = _ref.accessToken,
          accessToken = _ref$accessToken === void 0 ? '' : _ref$accessToken;

      _this = _UserService.call(this, {
        protocol: protocol,
        host: host,
        port: port,
        version: version
      }) || this;
      _this.serviceInstance = axios__default['default'].create({
        baseURL: protocol + "://" + host + ":" + port + "/api/" + version + "/tester",
        headers: {
          'Authorization': "Bearer " + accessToken
        }
      });
      return _this;
    }

    return TesterBaseService;
  }(UserService);

  var TesterProjectsService = /*#__PURE__*/function (_TesterBaseService) {
    _inheritsLoose(TesterProjectsService, _TesterBaseService);

    function TesterProjectsService() {
      return _TesterBaseService.apply(this, arguments) || this;
    }

    var _proto = TesterProjectsService.prototype;

    /**
     * 获取项目列表
     * @returns
     */
    _proto.getProjects = function getProjects() {
      var _this = this;

      return new Promise(function (resolve, reject) {
        _this.get('projects.json').then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    };

    return TesterProjectsService;
  }(TesterBaseService);

  var TesterFunctionsService = /*#__PURE__*/function (_TesterBaseService) {
    _inheritsLoose(TesterFunctionsService, _TesterBaseService);

    function TesterFunctionsService() {
      return _TesterBaseService.apply(this, arguments) || this;
    }

    var _proto = TesterFunctionsService.prototype;

    /**
     * 获取函数列表
     * @param versionId 版本id
     * @returns {Promise}
     */
    _proto.getFunctions = function getFunctions(versionId) {
      var _this = this;

      return new Promise(function (resolve, reject) {
        _this.get("/project-versions/" + versionId + "/functions/overview.json?perPage=99999").then(function (res) {
          if (res.status === 200) {
            resolve(res.data.functions);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 获取函数详细信息
     * @param functionId 函数id
     * @returns {Promise}
     */
    ;

    _proto.getFunctionDetail = function getFunctionDetail(functionId) {
      var _this2 = this;

      return new Promise(function (resolve, reject) {
        _this2.get("/functions/" + functionId + ".json").then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 更新函数详细信息
     * @param functionId 函数id
     * @param updates 更新内容
     * @returns {Promise}
     */
    ;

    _proto.updateFunction = function updateFunction(functionId, updates) {
      var _this3 = this;

      return new Promise(function (resolve, reject) {
        _this3.put("/functions/" + functionId + ".json", updates).then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 更新函数自定义字段的值
     * @param functionId 函数id
     * @param keyValues 更新的自定义字段
     * @returns {Promise}
     */
    ;

    _proto.updateUserDefinedKeys = function updateUserDefinedKeys(functionId, keyValues) {
      var _this4 = this;

      return this.getFunctionDetail(functionId).then(function (_ref) {
        var userDefinedFields = _ref.userDefinedFields;
        keyValues.forEach(function (_ref2) {
          var name = _ref2.name,
              value = _ref2.value;
          var udf = userDefinedFields.find(function (udf) {
            return udf.name === name;
          });

          if (!udf) {
            throw TesterBaseService.createTokenServiceError("udf " + name + " not exists");
          }

          udf.value = value;
        });
        return _this4.updateFunction(functionId, {
          userDefinedFields: userDefinedFields
        });
      });
    };

    return TesterFunctionsService;
  }(TesterBaseService);

  var TesterTestsService = /*#__PURE__*/function (_TesterBaseService) {
    _inheritsLoose(TesterTestsService, _TesterBaseService);

    function TesterTestsService() {
      return _TesterBaseService.apply(this, arguments) || this;
    }

    var _proto = TesterTestsService.prototype;

    /**
     * 获取某个函数的测试用例列表
     * @param functionId 函数id
     * @returns {Promise}
     */
    _proto.getTestsByFunction = function getTestsByFunction(functionId) {
      var _this = this;

      return new Promise(function (resolve, reject) {
        _this.get("/functions/" + functionId + "/tests.json?perPage=9999999").then(function (res) {
          if (res.status === 200) {
            resolve(res.data.tests);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 获取测试用例详细信息
     * @param testId 测试用例id
     * @returns {Promise}
     */
    ;

    _proto.getTestDetail = function getTestDetail(testId) {
      var _this2 = this;

      return new Promise(function (resolve, reject) {
        _this2.get("/tests/" + testId + ".json").then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 更新测试用例信息
     * @param testId 测试用例id
     * @param updates 更新内容
     * @returns {Promise}
     */
    ;

    _proto.updateTest = function updateTest(testId, updates) {
      var _this3 = this;

      return new Promise(function (resolve, reject) {
        _this3.put("/tests/" + testId + ".json", updates).then(function (res) {
          if (res.status === 200) {
            resolve(res.data);
          } else {
            reject(TesterBaseService.createNetworkError(res));
          }
        })["catch"](function (err) {
          reject(TesterBaseService.createTokenServiceError(err));
        });
      });
    }
    /**
     * 更新测试用例用户自定义字段
     * @param testId 测试用例id
     * @param keyValues 更新的自定义字段内容
     * @returns {Promise}
     */
    ;

    _proto.updateUserDefinedKeys = function updateUserDefinedKeys(testId, keyValues) {
      var _this4 = this;

      return this.getTestDetail(testId).then(function (_ref) {
        var userDefinedFields = _ref.userDefinedFields;
        keyValues.forEach(function (_ref2) {
          var name = _ref2.name,
              value = _ref2.value;
          var udf = userDefinedFields.find(function (udf) {
            return udf.name === name;
          });

          if (!udf) {
            throw TesterBaseService.createTokenServiceError("udf " + name + " not exists");
          }

          udf.value = value;
        });
        return _this4.updateTest(testId, {
          userDefinedFields: userDefinedFields
        });
      });
    };

    return TesterTestsService;
  }(TesterBaseService);

  var TesterService = /*#__PURE__*/function (_UserService) {
    _inheritsLoose(TesterService, _UserService);

    function TesterService(_temp) {
      var _this;

      var _ref = _temp === void 0 ? {} : _temp,
          _ref$protocol = _ref.protocol,
          protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
          _ref$host = _ref.host,
          host = _ref$host === void 0 ? 'localhost' : _ref$host,
          _ref$port = _ref.port,
          port = _ref$port === void 0 ? 80 : _ref$port,
          _ref$version = _ref.version,
          version = _ref$version === void 0 ? 'v2' : _ref$version,
          _ref$accessToken = _ref.accessToken,
          accessToken = _ref$accessToken === void 0 ? '' : _ref$accessToken;

      _this = _UserService.call(this, {
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      }) || this;
      _this.projects = new TesterProjectsService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
      _this.functions = new TesterFunctionsService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
      _this.tests = new TesterTestsService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
      return _this;
    }

    return TesterService;
  }(UserService);

  /**
   * 客户端类
   *
   * Created by snowingsea on 2021/03/08.
   */

  var SmartRocketClient = function SmartRocketClient(_temp) {
    var _ref = _temp === void 0 ? {} : _temp,
        _ref$protocol = _ref.protocol,
        protocol = _ref$protocol === void 0 ? 'http' : _ref$protocol,
        _ref$host = _ref.host,
        host = _ref$host === void 0 ? 'localhost' : _ref$host,
        _ref$port = _ref.port,
        port = _ref$port === void 0 ? 80 : _ref$port,
        _ref$version = _ref.version,
        version = _ref$version === void 0 ? 'v2' : _ref$version,
        _ref$accessToken = _ref.accessToken,
        accessToken = _ref$accessToken === void 0 ? '' : _ref$accessToken;

    if (accessToken) {
      this.user = new UserService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
      this.administrator = new AdministratorService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
      this.tester = new TesterService({
        protocol: protocol,
        host: host,
        port: port,
        version: version,
        accessToken: accessToken
      });
    } else {
      var err = new Error('wrong arguments');
      throw err;
    }
  };

  var IntegrationTestCaseTransformer = /*#__PURE__*/function (_TestCaseTransformer) {
    _inheritsLoose(IntegrationTestCaseTransformer, _TestCaseTransformer);

    function IntegrationTestCaseTransformer(testCaseData, variablesData, typeSystemData) {
      return _TestCaseTransformer.call(this, testCaseData, variablesData, typeSystemData) || this;
    }
    /**
     * 去除全局常量
     */


    var _proto = IntegrationTestCaseTransformer.prototype;

    _proto.removeConstGlobalVariable = function removeConstGlobalVariable() {
      var _this = this;

      if (!this.variablesData || !this.typeSystemData) {
        return;
      } // 去除有value值的全局常量


      if (this.variablesData.variables && this.variablesData.variables.global) {
        Object.keys(this.variablesData.variables.global).forEach(function (key) {
          var globalVariable = _this.variablesData.variables.global[key];
          var fileId = globalVariable.fileId,
              isOriginal = globalVariable.isOriginal;
          var fileTypes = _this.typeSystemData[fileId];

          if (!fileTypes) {
            return console.error("can not find type system for file " + fileId);
          }

          var type = fileTypes[globalVariable['@type']];
          var isConst = type && type['@attributes'].indexOf('isConst') >= 0;

          if (globalVariable['@value'] && isConst) {
            if (!isOriginal) {
              delete _this.variablesData.variables.global[key];
            } else if (_this.testCaseData.data) {
              // const 补全默认值
              _this.testCaseData.data.variables = _this.testCaseData.data.variables || {};
              _this.testCaseData.data.variables.global = _this.testCaseData.data.variables.global || {};
              _this.testCaseData.data.variables.global[key] = _this.testCaseData.data.variables.global[key] || {};

              _this.completeTestCaseData(_this.testCaseData.data.variables.global[key], '', globalVariable['@value']);
            }
          }

          if (_this.variablesData.output && _this.variablesData.output.global && isConst) {
            if (!isOriginal) {
              delete _this.variablesData.output.global[key];
            }
          }
        });
      }
    }
    /**
     * 根据类型名，通过类型系统构建字段列表
     * @param testCaseData 用例数据
     * @param typeName 类型名称
     * @param result 结果集合
     * @param scope 变量范围
     * @param init 元素初始化数据
     */
    ;

    _proto.buildFieldsByTypeName = function buildFieldsByTypeName(testCaseData, typeName, result, scope, init) {
      if (init === void 0) {
        init = undefined;
      }

      testCaseData['@type'] = typeName;
      result.typeName = typeName;
      var fileId = result.fileId || this.variablesData.fileId;
      var filePath = result.filePath || this.variablesData.filePath;

      if (!fileId) {
        throw new Error('need fileId');
      }

      var unqualifiedType = this.getUnqualifiedTypeWithFieId(typeName, fileId.toString());

      if (!unqualifiedType) {
        this.isLegal = false;
        return;
      }

      var attributes = unqualifiedType['@attributes'];
      var attributeSet = new Set(attributes);
      result.data = testCaseData;

      if (attributeSet.has('isRecord') || attributeSet.has('isCXXRecord')) {
        // 结构体
        result.originFieldPath = result.fieldPath;

        if ((attributeSet.has('isClass') || attributeSet.has('isStructure')) && result.kind !== this.VARIABLE_KIND.stubMemberVariable) {
          result.fieldPath = result.initFieldPath + ".@ctor.@value";

          if (scope === this.VARIABLE_SCOPE_KIND.input) {
            this.buildRecordConstructorFields(testCaseData, unqualifiedType, result, init || testCaseData);
          }
        }

        if (!testCaseData['@value']) {
          testCaseData['@value'] = {};
        }

        result.type = this.VARIABLE_TYPE.record;

        if (!result.children) {
          result.children = [];
        }

        var fields = unqualifiedType['@fields'];
        Object.keys(fields).forEach(function (key) {
          fields[key].fileId = fileId.toString();
          fields[key].filePath = filePath;
        });
        this.buildFields(testCaseData['@value'], fields, result.children, result.originFieldPath, this.VARIABLE_KIND.field, scope);
        return;
      }

      if (attributeSet.has('isArray')) {
        // 数组
        if (!unqualifiedType['@elementType']) {
          this.isLegal = false;
          console.error("Can't find element type in array type: " + unqualifiedType);
          return;
        }

        result.type = this.VARIABLE_TYPE.array;
        var elementType = unqualifiedType['@elementType'];
        var length = unqualifiedType['@length'];
        this.buildFieldsByElementTypeName(testCaseData, elementType, length, result, scope);
        return;
      } // 剩余情况下值应该是简单类型，否则类型不一致


      if (isArrayType(testCaseData['@value']) || isObjectType(testCaseData['@value'])) {
        this.isLegal = false;
      }

      if (attributeSet.has('isFunctionPointer')) {
        // 函数指针
        result.type = this.VARIABLE_TYPE.functionPointer;
        var pointeeTypeName = unqualifiedType['@pointeeType'];
        result.functionType = this.typeSystemData[fileId][pointeeTypeName];
        return;
      }

      if (attributeSet.has('isPointer')) {
        // 指针
        result.type = this.VARIABLE_TYPE.pointer;
        result.pointeeType = unqualifiedType['@pointeeType'];
        return;
      }

      if (attributeSet.has('isReference')) {
        // 引用
        result.type = this.VARIABLE_TYPE.reference;
        result.pointeeType = unqualifiedType['@pointeeType'];
        return;
      }

      if (attributeSet.has('isEnumeral')) {
        // 枚举
        result.type = this.VARIABLE_TYPE.enumeration;
        return;
      } // 基本类型


      result.type = this.VARIABLE_TYPE.basic;
    };

    _proto.getUnqualifiedTypeWithFieId = function getUnqualifiedTypeWithFieId(typeName, fileId) {
      if (!this.typeSystemData || !this.typeSystemData[fileId]) {
        console.error("TypeSystemData or typeSystemData." + fileId + " not exsist");
        return null;
      }

      var fileTypes = this.typeSystemData[fileId];
      var type = fileTypes[typeName];

      if (!type) {
        console.error("Can't find the type(" + typeName + ") in " + fileId + ": " + JSON.stringify(fileTypes));
        return null;
      }

      var canonicalType = fileTypes[type['@canonical']];

      if (!canonicalType) {
        console.error("Can't find the canonical type(" + type['@canonical'] + ") in " + fileId + ": " + JSON.stringify(fileTypes));
        return null;
      }

      var unqualifiedType = fileTypes[canonicalType['@unqualified']];

      if (!unqualifiedType) {
        console.error("Can't find the unqualified type(" + canonicalType['@unqualified'] + ") in " + fileId + ": " + JSON.stringify(fileTypes));
        return null;
      }

      var attributes = unqualifiedType['@attributes'];
      var attributeSet = new Set(attributes);

      if (attributeSet.has('isRecord')) {
        unqualifiedType['@fields'] = unqualifiedType['@fields'] || {};
      }

      return unqualifiedType;
    };

    _proto.completeFileIdRecursively = function completeFileIdRecursively(item) {
      var _this2 = this;

      var fileId = item.fileId,
          filePath = item.filePath;

      if (item.children) {
        item.children.forEach(function (child) {
          child.fileId = child.fileId || fileId;
          child.filePath = child.filePath || filePath;

          _this2.completeFileIdRecursively(child);
        });
      }
    } // 补全所有children的fileId/filePath
    ;

    _proto.completeFileIdForChildren = function completeFileIdForChildren(arr) {
      var _this3 = this;

      arr.forEach(function (item) {
        _this3.completeFileIdRecursively(item);
      });
    };

    _proto.transform = function transform() {
      _TestCaseTransformer.prototype.transform.call(this); // 为所有children补全file相关信息


      this.completeFileIdForChildren(this.objectData);
      this.completeFileIdForChildren(this.paramVariablesData);
      this.completeFileIdForChildren(this.globalVariablesData);
      this.completeFileIdForChildren(this.staticsData);
      this.completeFileIdForChildren(this.fixedAddressExpressionsData);
      this.completeFileIdForChildren(this.fixedAddressBasesData);
      this.completeFileIdForChildren(this.stubsData);
      this.completeFileIdForChildren(this.mallocVariablesData);
      this.completeFileIdForChildren(this.returnValueData);
      this.completeFileIdForChildren(this.objectOutputData);
      this.completeFileIdForChildren(this.globalOutputData);
      this.completeFileIdForChildren(this.mallocOutputData);
      this.completeFileIdForChildren(this.fixedAddressBasesOutputData);
      this.completeFileIdForChildren(this.staticsOutputData);
    };

    return IntegrationTestCaseTransformer;
  }(TestCaseTransformer);

  module.exports = {
    TestCaseTransformer: TestCaseTransformer,
    SmartRocketClient: SmartRocketClient,
    UserService: UserService,
    IntegrationTestCaseTransformer: IntegrationTestCaseTransformer
  }; // Allow use of default import syntax in TypeScript

  module.exports["default"] = {
    TestCaseTransformer: TestCaseTransformer,
    SmartRocketClient: SmartRocketClient,
    UserService: UserService,
    IntegrationTestCaseTransformer: IntegrationTestCaseTransformer
  };

})));
