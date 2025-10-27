// Math.js library for advanced mathematical operations
// This is a simplified version - in production, use the full math.js library

// Basic math operations
const math = {
  // Constants
  pi: Math.PI,
  e: Math.E,
  
  // Basic operations
  add: (a, b) => a + b,
  subtract: (a, b) => a - b,
  multiply: (a, b) => a * b,
  divide: (a, b) => a / b,
  pow: (a, b) => Math.pow(a, b),
  sqrt: (a) => Math.sqrt(a),
  abs: (a) => Math.abs(a),
  
  // Trigonometric functions
  sin: (a) => Math.sin(a),
  cos: (a) => Math.cos(a),
  tan: (a) => Math.tan(a),
  asin: (a) => Math.asin(a),
  acos: (a) => Math.acos(a),
  atan: (a) => Math.atan(a),
  
  // Logarithmic functions
  log: (a) => Math.log10(a),
  ln: (a) => Math.log(a),
  log2: (a) => Math.log2(a),
  
  // Exponential functions
  exp: (a) => Math.exp(a),
  exp10: (a) => Math.pow(10, a),
  exp2: (a) => Math.pow(2, a),
  
  // Matrix operations (simplified)
  matrix: (data) => ({
    _data: data,
    toArray: () => data,
    toString: () => JSON.stringify(data)
  }),
  
  add: (a, b) => {
    if (a._data && b._data) {
      const result = [];
      for (let i = 0; i < a._data.length; i++) {
        result[i] = [];
        for (let j = 0; j < a._data[i].length; j++) {
          result[i][j] = a._data[i][j] + b._data[i][j];
        }
      }
      return math.matrix(result);
    }
    return a + b;
  },
  
  subtract: (a, b) => {
    if (a._data && b._data) {
      const result = [];
      for (let i = 0; i < a._data.length; i++) {
        result[i] = [];
        for (let j = 0; j < a._data[i].length; j++) {
          result[i][j] = a._data[i][j] - b._data[i][j];
        }
      }
      return math.matrix(result);
    }
    return a - b;
  },
  
  multiply: (a, b) => {
    if (a._data && b._data) {
      const result = [];
      for (let i = 0; i < a._data.length; i++) {
        result[i] = [];
        for (let j = 0; j < b._data[0].length; j++) {
          let sum = 0;
          for (let k = 0; k < b._data.length; k++) {
            sum += a._data[i][k] * b._data[k][j];
          }
          result[i][j] = sum;
        }
      }
      return math.matrix(result);
    }
    return a * b;
  },
  
  transpose: (a) => {
    if (a._data) {
      const result = [];
      for (let i = 0; i < a._data[0].length; i++) {
        result[i] = [];
        for (let j = 0; j < a._data.length; j++) {
          result[i][j] = a._data[j][i];
        }
      }
      return math.matrix(result);
    }
    return a;
  },
  
  det: (a) => {
    if (a._data && a._data.length === 2 && a._data[0].length === 2) {
      return a._data[0][0] * a._data[1][1] - a._data[0][1] * a._data[1][0];
    }
    return 0;
  },
  
  inv: (a) => {
    if (a._data && a._data.length === 2 && a._data[0].length === 2) {
      const det = math.det(a);
      if (det === 0) throw new Error('Matrix is singular');
      const result = [
        [a._data[1][1] / det, -a._data[0][1] / det],
        [-a._data[1][0] / det, a._data[0][0] / det]
      ];
      return math.matrix(result);
    }
    throw new Error('Inverse only supported for 2x2 matrices');
  },
  
  // Expression parsing (simplified)
  parse: (expr) => ({
    evaluate: (scope = {}) => {
      try {
        // Simple expression evaluation
        let result = expr;
        for (const [key, value] of Object.entries(scope)) {
          result = result.replace(new RegExp(key, 'g'), value);
        }
        return eval(result);
      } catch (e) {
        throw new Error('Invalid expression: ' + expr);
      }
    },
    toString: () => expr
  }),
  
  // Simplification (simplified)
  simplify: (expr) => expr,
  
  // Expansion (simplified)
  expand: (expr) => expr,
  
  // Factorization (simplified)
  factorize: (expr) => expr,
  
  // Derivative (simplified)
  derivative: (expr, variable) => ({
    evaluate: (scope = {}) => {
      // Simple derivative calculation for basic functions
      const exprStr = expr.toString();
      if (exprStr.includes(variable + '^2')) {
        return 2 * (scope[variable] || 1);
      } else if (exprStr.includes(variable)) {
        return 1;
      }
      return 0;
    },
    toString: () => 'd/d' + variable + '(' + expr.toString() + ')'
  }),
  
  // Integration (simplified)
  integrate: (expr, variable) => ({
    evaluate: (scope = {}) => {
      // Simple integration for basic functions
      const exprStr = expr.toString();
      if (exprStr.includes(variable)) {
        return Math.pow(scope[variable] || 1, 2) / 2;
      }
      return 0;
    },
    toString: () => '∫(' + expr.toString() + ')d' + variable
  })
};

// Export for Node.js style require
if (typeof module !== 'undefined' && module.exports) {
  module.exports = math;
}

// Make available globally
if (typeof window !== 'undefined') {
  window.math = math;
}