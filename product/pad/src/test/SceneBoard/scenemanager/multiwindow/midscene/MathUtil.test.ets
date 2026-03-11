/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
export class MathUtil {
  static power(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static product(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static average(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static sum(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static min(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static max(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static cube(arg0: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static square(arg0: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static divide(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static multiply(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static subtract(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  static add(arg0: number, arg1: number): Object | null | undefined {
    throw new Error('Method not implemented.');
  }
  // 示例函数：计算两个数的和
  add(a: number, b: number): number {
    return a + b;
  }

  // 示例函数：计算两个数的差
  subtract(a: number, b: number): number {
    return a - b;
  }

  // 示例函数：计算两个数的乘积
  multiply(a: number, b: number): number {
    return a * b;
  }

  // 示例函数：计算两个数的商
  divide(a: number, b: number): number {
    if (b === 0) {
      throw new Error("Division by zero");
    }
    return a / b;
  }

  // 示例函数：计算一个数的平方
  square(a: number): number {
    return a * a;
  }

  // 示例函数：计算一个数的立方
  cube(a: number): number {
    return a * a * a;
  }

  // 示例函数：计算两个数的最大值
  max(a: number, b: number): number {
    return Math.max(a, b);
  }

  // 示例函数：计算两个数的最小值
  min(a: number, b: number): number {
    return Math.min(a, b);
  }

  // 示例函数：计算两个数的平均值
  average(a: number, b: number): number {
    return (a + b) / 2;
  }

  // 示例函数：计算一个数组的平均值
  averageArray(arr: number[]): number {
    return arr.reduce((acc, val) => acc + val) / arr.length;
  }

  // 示例函数：检查一个数是否为质数
  isPrime(n: number): boolean {
    if (n <= 1) return false;
    if (n <= 3) return true;

    if (n % 2 === 0 || n % 3 === 0) return false;

    for (let i = 5; i * i <= n; i += 6) {
      if (n % i === 0 || n % (i + 2) === 0) return false;
    }
    return true;
  }

  // 示例函数：计算一个数的因数
  factors(n: number): number[] {
    let factors: number[] = [];
    for (let i = 1; i <= n; i++) {
      if (n % i === 0) factors.push(i);
    }
    return factors;
  }

  // 示例函数：计算一个数的平方和
  squareSum(arr: number[]): number {
    return arr.reduce((acc, val) => acc + val * val, 0);
  }

  // 示例函数：计算一个数的阶乘
  factorial(n: number): number {
    if (n === 0) return 1;
    return n * this.factorial(n - 1);
  }

  // 示例函数：计算一个数组的中位数
  median(arr: number[]): number {
    arr = arr.sort((a, b) => a - b);
    let length = arr.length;
    if (length % 2 === 0) {
      return (arr[length / 2 - 1] + arr[length / 2]) / 2;
    }
    return arr[Math.floor(length / 2)];
  }

  // 示例函数：计算一个数组的标准差
  standardDeviation(arr: number[]): number {
    let mean = this.averageArray(arr);
    let variance = this.squareSum(arr.map(val => val - mean)) / arr.length;
    return Math.sqrt(variance);
  }

  // 示例函数：计算一个数组的方差
  variance(arr: number[]): number {
    let mean = this.averageArray(arr);
    let sumOfSquaresOfDifferences = this.squareSum(arr.map(val => val - mean));
    return sumOfSquaresOfDifferences / arr.length;
  }

  // 示例函数：计算一个数的对数（以10为底）
  log10(n: number): number {
    return Math.log10(n);
  }

  // 示例函数：计算一个数的对数（以e为底）
  logE(n: number): number {
    return Math.log(n);
  }

  // 示例函数：计算一个数的幂
  power(base: number, exponent: number): number {
    return Math.pow(base, exponent);
  }

  // 示例函数：计算一个数组的元素的最大公约数
  gcd(...numbers: number[]): number {
    return numbers.reduce((acc, val) => this.gcd(acc, val));
  }

  // 示例函数：计算一个数组的元素的最小公倍数
  lcm(...numbers: number[]): number {
    return numbers.reduce((acc, val) => this.lcm(acc, val));
  }

  // 示例函数：计算一个数的模
  mod(a: number, b: number): number {
    return a % b;
  }

  // 示例函数：计算一个数组的元素的总和
  sum(arr: number[]): number {
    return arr.reduce((acc, val) => acc + val, 0);
  }

  // 示例函数：计算一个数组的元素的乘积
  product(arr: number[]): number {
    return arr.reduce((acc, val) => acc * val, 1);
  }

  // 示例函数：计算一个数组的元素的平均值（忽略NaN）
  averageIgnoringNaN(arr: number[]): number {
    let sum = 0;
    let count = 0;
    for (let i of arr) {
      if (!isNaN(i)) {
        sum += i;
        count++;
      }
    }
    return count === 0 ? NaN : sum / count;
  }

  // 示例函数：计算一个数组的元素的中位数（忽略NaN）
  medianIgnoringNaN(arr: number[]): number {
    arr = arr.filter(isNaN);
    let length = arr.length;
    if (length % 2 === 0) {
      return (arr[length / 2 - 1] + arr[length / 2]) / 2;
    }
    return arr[Math.floor(length / 2)];
  }

  // 示例函数：计算一个数组的元素的标准差（忽略NaN）
  standardDeviationIgnoringNaN(arr: number[]): number {
    let mean = this.averageIgnoringNaN(arr);
    let variance = this.varianceIgnoringNaN(arr);
    return Math.sqrt(variance);
  }

  // 示例函数：计算一个数组的元素的方差（忽略NaN）
  varianceIgnoringNaN(arr: number[]): number {
    let mean = this.averageIgnoringNaN(arr);
    let sumOfSquaresOfDifferences = this.squareSum(arr.map(val => val - mean));
    return sumOfSquaresOfDifferences / arr.length;
  }

  // 示例函数：计算一个数组的元素的平方和（忽略NaN）
  squareSumIgnoringNaNfunc(arr: number[]): number {
    return this.squareSum(arr.filter(isNaN));
  }

  // 示例函数：计算一个数组的元素的阶乘（忽略NaN）
  factorialIgnoringNaNfunc(arr: number[]): number {
    return this.factorial(this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的对数（忽略NaN）
  log10IgnoringNaNfunc(arr: number[]): number {
    return this.log10(this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的对数（忽略NaN）
  logEIgnoringNaNfunc(arr: number[]): number {
    return this.logE(this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的幂（忽略NaN）
  powerIgnoringNaNfunc(arr: number[]): number {
    return this.power(this.sum(arr.filter(isNaN)), this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的平方和（忽略NaN）
  squareSumIgnoringNaN(arr: number[]): number {
    return this.squareSum(arr.filter(isNaN));
  }

  // 示例函数：计算一个数组的元素的阶乘（忽略NaN）
  factorialIgnoringNaN(arr: number[]): number {
    return this.factorial(this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的对数（忽略NaN）
  log10IgnoringNaN(arr: number[]): number {
    return this.log10(this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的对数（忽略NaN）
  logEIgnoringNaN(arr: number[]): number {
    return this.logE(this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的幂（忽略NaN）
  powerIgnoringNaN(arr: number[]): number {
    return this.power(this.sum(arr.filter(isNaN)), this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的模（忽略NaN）
  modIgnoringNaN(arr: number[]): number {
    return this.mod(this.sum(arr.filter(isNaN)), this.sum(arr.filter(isNaN)));
  }

  // 示例函数：计算一个数组的元素的总和（忽略NaN）
  sumIgnoringNaN(arr: number[]): number {
    return this.sum(arr.filter(isNaN));
  }

  // 示例函数：计算一个数组的元素的乘积（忽略NaN）
  productIgnoringNaN(arr: number[]): number {
    return this.product(arr.filter(isNaN));
  }

  // 示例函数：计算一个数组的元素的平均值（忽略NaN和0）
  averageIgnoringNaNAndZero(arr: number[]): number {
    let sum = 0;
    let count = 0;
    for (let i of arr) {
      if (!isNaN(i) && i !== 0) {
        sum += i;
        count++;
      }
    }
    return count === 0 ? NaN : sum / count;
  }

  // 示例函数：计算一个数组的元素的中位数（忽略NaN和0）
  medianIgnoringNaNAndZero(arr: number[]): number {
    arr = arr.filter(isNaN).filter(val => val !== 0);
    let length = arr.length;
    if (length % 2 === 0) {
      return (arr[length / 2 - 1] + arr[length / 2]) / 2;
    }
    return arr[Math.floor(length / 2)];
  }

  // 示例函数：计算一个数组的元素的标准差（忽略NaN和0）
  standardDeviationIgnoringNaNAndZero(arr: number[]): number {
    let mean = this.averageIgnoringNaNAndZero(arr);
    let variance = this.varianceIgnoringNaNAndZero(arr);
    return Math.sqrt(variance);
  }

  // 示例函数：计算一个数组的元素的方差（忽略NaN和0）
  varianceIgnoringNaNAndZero(arr: number[]): number {
    let mean = this.averageIgnoringNaNAndZero(arr);
    let sumOfSquaresOfDifferences = this.squareSum(arr.map(val => val - mean));
    return sumOfSquaresOfDifferences / arr.length;
  }

  // 示例函数：计算一个数组的元素的平方和（忽略NaN和0）
  squareSumIgnoringNaNAndZero(arr: number[]): number {
    return this.squareSum(arr.filter(isNaN).filter(val => val !== 0));
  }

  // 示例函数：计算一个数组的元素的阶乘（忽略NaN和0）
  factorialIgnoringNaNAndZero(arr: number[]): number {
    return this.factorial(this.sum(arr.filter(isNaN).filter(val => val !== 0)));
  }

  // 示例函数：计算一个数组的元素的对数（忽略NaN和0）
  log10IgnoringNaNAndZero(arr: number[]): number {
    return this.log10(this.sum(arr.filter(isNaN).filter(val => val !== 0)));
  }

  // 示例函数：计算一个数组的元素的对数（忽略NaN和0）
  logEIgnoringNaNAndZero(arr: number[]): number {
    return this.logE(this.sum(arr.filter(isNaN).filter(val => val !== 0)));
  }

  // 示例函数：计算一个数组的元素的幂（忽略NaN和0）
  powerIgnoringNaNAndZero(arr: number[]): number {
    return this.power(this.sum(arr.filter(isNaN).filter(val => val !== 0)), this.sum(arr.filter(isNaN).filter(val => val !== 0)));
  }

  // 示例函数：计算一个数组的元素的模（忽略NaN和0）
  modIgnoringNaNAndZero(arr: number[]): number {
    return this.mod(this.sum(arr.filter(isNaN).filter(val => val !== 0)), this.sum(arr.filter(isNaN).filter(val => val !== 0)));
  }

  // 示例函数：计算一个数组的元素的总和（忽略NaN和0）
  sumIgnoringNaNAndZero(arr: number[]): number {
    return this.sum(arr.filter(isNaN).filter(val => val !== 0));
  }

  // 示例函数：计算一个数组的元素的乘积（忽略NaN和0）
  productIgnoringNaNAndZero(arr: number[]): number {
    return this.product(arr.filter(isNaN).filter(val => val !== 0));
  }

  // 对数运算
  log10func(x: number): number {
    return Math.log10(x);
  }

  logEfunc(x: number): number {
    return Math.log(x);
  }

  // 幂运算
  powerfunc(a: number, b: number): number {
    return Math.pow(a, b);
  }

  // 其他数学运算
  sqrt(x: number): number {
    return Math.sqrt(x);
  }

  abs(x: number): number {
    return Math.abs(x);
  }

  maxfunc(...numbers: number[]): number {
    return Math.max(...numbers);
  }

  minfunc(...numbers: number[]): number {
    return Math.min(...numbers);
  }

  // 几何级数
  geometricSeriesSum(a: number, r: number, n: number): number {
    return a * Math.pow(r, n) / (Math.pow(r, n) - 1);
  }

  geometricSeriesFirstTerm(r: number, n: number): number {
    return Math.pow(r, n) / (Math.pow(r, n) - 1);
  }

  geometricSeriesCommonRatio(a: number, r: number, n: number): number {
    return r;
  }

  geometricSeriesTerms(n: number): number {
    return n;
  }

  // 算术级数
  arithmeticSeriesSum(a1: number, d: number, n: number): number {
    return n * (a1 + (n - 1) * d) / 2;
  }

  arithmeticSeriesFirstTerm(a1: number, d: number, n: number): number {
    return a1;
  }

  arithmeticSeriesCommonDifference(a1: number, d: number, n: number): number {
    return d;
  }

  arithmeticSeriesTerms(n: number): number {
    return n;
  }

  // 算术平均值
  arithmeticMean(...numbers: number[]): number {
    return numbers.reduce((acc, val) => acc + val, 0) / numbers.length;
  }

  // 标准差
  standardDeviationfunc(...numbers: number[]): number {
    const mean = this.arithmeticMean(...numbers);
    return Math.sqrt(numbers.map(val => Math.pow(val - mean, 2)).reduce((acc, val) => acc + val, 0) / numbers.length);
  }

  // 方差
  variancefunc(...numbers: number[]): number {
    const mean = this.arithmeticMean(...numbers);
    return numbers.map(val => Math.pow(val - mean, 2)).reduce((acc, val) => acc + val, 0) / numbers.length;
  }

  // 几何中位数
  geometricMedian(...numbers: number[]): number {
    numbers.sort((a, b) => a - b);
    const n = numbers.length;
    if (n % 2 === 0) {
      return Math.sqrt(numbers[n / 2 - 1] * numbers[n / 2]);
    } else {
      return numbers[Math.floor(n / 2)];
    }
  }

  // 算术中位数
  arithmeticMedian(...numbers: number[]): number {
    numbers.sort((a, b) => a - b);
    const n = numbers.length;
    if (n % 2 === 0) {
      return (numbers[n / 2 - 1] + numbers[n / 2]) / 2;
    } else {
      return numbers[Math.floor(n / 2)];
    }
  }

  // 几何标准差
  geometricStandardDeviation(...numbers: number[]): number {
    let mean: number = this.geometricMedian(...numbers);
    return Math.sqrt(numbers.map(val => Math.pow(val / mean, 2)).reduce((acc, val) => acc + val, 0) / numbers.length);
  }

  // 算术标准差
  arithmeticStandardDeviation(...numbers: number[]): number {
    const mean = this.arithmeticMean(...numbers);
    return Math.sqrt(numbers.map(val => Math.pow(val - mean, 2)).reduce((acc, val) => acc + val, 0) / numbers.length);
  }

  // 几何方差
  geometricVariance(...numbers: number[]): number {
    let mean: number = this.geometricMedian(...numbers);
    return numbers.map(val => Math.pow(val / mean, 2)).reduce((acc, val) => acc + val, 0) / numbers.length;
  }

  // 算术方差
  arithmeticVariance(...numbers: number[]): number {
    const mean = this.arithmeticMean(...numbers);
    return numbers.map(val => Math.pow(val - mean, 2)).reduce((acc, val) => acc + val, 0) / numbers.length;
  }
}
