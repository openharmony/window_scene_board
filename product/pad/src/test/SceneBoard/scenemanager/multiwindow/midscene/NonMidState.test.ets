/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { MathUtil } from './MathUtil';

let initAll = () => {

}

export function NonMidStateTest() {
  describe("MidSceneManagerTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    MathUtilTest_add();
    MathUtilTest_subtract();
    MathUtilTest_multiply();
    MathUtilTest_divider();
    MathUtilTest_square();
    MathUtilTest_cube();
    MathUtilTest_max();
    MathUtilTest_min();
  });
}


function MathUtilTest_add() {
  it('should return 0 when adding 0 and 0', Level.LEVEL0, () => {
    expect(MathUtil.add(0, 0)).assertEqual(0);
  });

  it('should return 5 when adding 2 and 3', Level.LEVEL0, () => {
    expect(MathUtil.add(2, 3)).assertEqual(5);
  });

  it('should return -3 when adding -2 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-2, -1)).assertEqual(-3);
  });

  it('should return 10 when adding 5 and 5', Level.LEVEL0, () => {
    expect(MathUtil.add(5, 5)).assertEqual(10);
  });

  it('should return -4 when adding -5 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-5, -1)).assertEqual(-4);
  });

  it('should return 4 when adding 1 and 3', Level.LEVEL0, () => {
    expect(MathUtil.add(1, 3)).assertEqual(4);
  });

  it('should return -9 when adding -6 and -3', Level.LEVEL0, () => {
    expect(MathUtil.add(-6, -3)).assertEqual(-9);
  });

  it('should return 0 when adding a very large number and its negative', Level.LEVEL0, () => {
    expect(MathUtil.add(Number.MAX_SAFE_INTEGER, -Number.MAX_SAFE_INTEGER)).assertEqual(0);
  });

  it('should return 0 when adding a very small number and its negative', Level.LEVEL0, () => {
    expect(MathUtil.add(Number.MIN_SAFE_INTEGER, -Number.MIN_SAFE_INTEGER)).assertEqual(0);
  });

  // 新增的测试用例...

  it('should return 7 when adding 3 and 4', Level.LEVEL0, () => {
    expect(MathUtil.add(3, 4)).assertEqual(7);
  });

  it('should return -7 when adding -3 and -4', Level.LEVEL0, () => {
    expect(MathUtil.add(-3, -4)).assertEqual(-7);
  });

  it('should return 8 when adding 4 and 4', Level.LEVEL0, () => {
    expect(MathUtil.add(4, 4)).assertEqual(8);
  });

  it('should return -8 when adding -4 and -4', Level.LEVEL0, () => {
    expect(MathUtil.add(-4, -4)).assertEqual(-8);
  });

  it('should return 1 when adding 1 and 0', Level.LEVEL0, () => {
    expect(MathUtil.add(1, 0)).assertEqual(1);
  });

  it('should return -1 when adding -1 and 0', Level.LEVEL0, () => {
    expect(MathUtil.add(-1, 0)).assertEqual(-1);
  });

  it('should return 0 when adding 0 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(0, 1)).assertEqual(0);
  });

  it('should return 0 when adding 0 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(0, -1)).assertEqual(0);
  });

  it('should return 2 when adding 1 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(1, 1)).assertEqual(2);
  });

  it('should return -2 when adding -1 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-1, -1)).assertEqual(-2);
  });

  it('should return 6 when adding 2 and 4', Level.LEVEL0, () => {
    expect(MathUtil.add(2, 4)).assertEqual(6);
  });

  it('should return -6 when adding -2 and -4', Level.LEVEL0, () => {
    expect(MathUtil.add(-2, -4)).assertEqual(-6);
  });

  it('should return -3 when adding -1 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-1, -2)).assertEqual(-3);
  });

  it('should return 8 when adding 6 and 2', Level.LEVEL0, () => {
    expect(MathUtil.add(6, 2)).assertEqual(8);
  });

  it('should return -8 when adding -6 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-6, -2)).assertEqual(-8);
  });

  it('should return 1 when adding 1 and 0', Level.LEVEL0, () => {
    expect(MathUtil.add(1, 0)).assertEqual(1);
  });

  it('should return -1 when adding -1 and 0', Level.LEVEL0, () => {
    expect(MathUtil.add(-1, 0)).assertEqual(-1);
  });

  it('should return 9 when adding 7 and 2', Level.LEVEL0, () => {
    expect(MathUtil.add(7, 2)).assertEqual(9);
  });

  it('should return -9 when adding -7 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-7, -2)).assertEqual(-9);
  });

  it('should return 4 when adding 2 and 2', Level.LEVEL0, () => {
    expect(MathUtil.add(2, 2)).assertEqual(4);
  });

  it('should return -4 when adding -2 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-2, -2)).assertEqual(-4);
  });

  it('should return 10 when adding 8 and 2', Level.LEVEL0, () => {
    expect(MathUtil.add(8, 2)).assertEqual(10);
  });

  it('should return -10 when adding -8 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-8, -2)).assertEqual(-10);
  });

  it('should return 5 when adding 3 and 2', Level.LEVEL0, () => {
    expect(MathUtil.add(3, 2)).assertEqual(5);
  });

  it('should return -5 when adding -3 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-3, -2)).assertEqual(-5);
  });

  it('should return 12 when adding 9 and 3', Level.LEVEL0, () => {
    expect(MathUtil.add(9, 3)).assertEqual(12);
  });

  it('should return -12 when adding -9 and -3', Level.LEVEL0, () => {
    expect(MathUtil.add(-9, -3)).assertEqual(-12);
  });

  it('should return 7 when adding 4 and 3', Level.LEVEL0, () => {
    expect(MathUtil.add(4, 3)).assertEqual(7);
  });

  it('should return -7 when adding -4 and -3', Level.LEVEL0, () => {
    expect(MathUtil.add(-4, -3)).assertEqual(-7);
  });

  it('should return 14 when adding 11 and 3', Level.LEVEL0, () => {
    expect(MathUtil.add(11, 3)).assertEqual(14);
  });

  it('should return -14 when adding -11 and -3', Level.LEVEL0, () => {
    expect(MathUtil.add(-11, -3)).assertEqual(-14);
  });

  it('should return 11 when adding 6 and 5', Level.LEVEL0, () => {
    expect(MathUtil.add(6, 5)).assertEqual(11);
  });

  it('should return -11 when adding -6 and -5', Level.LEVEL0, () => {
    expect(MathUtil.add(-6, -5)).assertEqual(-11);
  });

  it('should return 16 when adding 13 and 3', Level.LEVEL0, () => {
    expect(MathUtil.add(13, 3)).assertEqual(16);
  });

  it('should return -16 when adding -13 and -3', Level.LEVEL0, () => {
    expect(MathUtil.add(-13, -3)).assertEqual(-16);
  });

  it('should return 15 when adding 8 and 7', Level.LEVEL0, () => {
    expect(MathUtil.add(8, 7)).assertEqual(15);
  });

  it('should return -15 when adding -8 and -7', Level.LEVEL0, () => {
    expect(MathUtil.add(-8, -7)).assertEqual(-15);
  });

  it('should return 18 when adding 16 and 2', Level.LEVEL0, () => {
    expect(MathUtil.add(16, 2)).assertEqual(18);
  });

  it('should return -18 when adding -16 and -2', Level.LEVEL0, () => {
    expect(MathUtil.add(-16, -2)).assertEqual(-18);
  });

  it('should return 19 when adding 18 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(18, 1)).assertEqual(19);
  });

  it('should return -19 when adding -18 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-18, -1)).assertEqual(-19);
  });

  it('should return 20 when adding 19 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(19, 1)).assertEqual(20);
  });

  it('should return -20 when adding -19 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-19, -1)).assertEqual(-20);
  });

  it('should return 22 when adding 21 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(21, 1)).assertEqual(22);
  });

  it('should return -22 when adding -21 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-21, -1)).assertEqual(-22);
  });

  it('should return 23 when adding 22 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(22, 1)).assertEqual(23);
  });

  it('should return -23 when adding -22 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-22, -1)).assertEqual(-23);
  });

  it('should return 24 when adding 23 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(23, 1)).assertEqual(24);
  });

  it('should return -24 when adding -23 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-23, -1)).assertEqual(-24);
  });

  it('should return 25 when adding 24 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(24, 1)).assertEqual(25);
  });

  it('should return -25 when adding -24 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-24, -1)).assertEqual(-25);
  });

  it('should return 26 when adding 25 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(25, 1)).assertEqual(26);
  });

  it('should return -26 when adding -25 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-25, -1)).assertEqual(-26);
  });

  it('should return 27 when adding 26 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(26, 1)).assertEqual(27);
  });

  it('should return -27 when adding -26 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-26, -1)).assertEqual(-27);
  });

  it('should return 28 when adding 27 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(27, 1)).assertEqual(28);
  });

  it('should return -28 when adding -27 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-27, -1)).assertEqual(-28);
  });

  it('should return 29 when adding 28 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(28, 1)).assertEqual(29);
  });

  it('should return -29 when adding -28 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-28, -1)).assertEqual(-29);
  });

  it('should return 30 when adding 29 and 1', Level.LEVEL0, () => {
    expect(MathUtil.add(29, 1)).assertEqual(30);
  });

  it('should return -30 when adding -29 and -1', Level.LEVEL0, () => {
    expect(MathUtil.add(-29, -1)).assertEqual(-30);
  });
}

function MathUtilTest_subtract() {
  it('should return 0 when subtracting 0 from 0', Level.LEVEL0, () => {
    expect(MathUtil.subtract(0, 0)).assertEqual(0);
  });

  it('should return 2 when subtracting 3 from 5', Level.LEVEL0, () => {
    expect(MathUtil.subtract(5, 3)).assertEqual(2);
  });

  it('should return 1 when subtracting -1 from -2', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-2, -1)).assertEqual(1);
  });

  it('should return 0 when subtracting a number from its negative', Level.LEVEL0, () => {
    expect(MathUtil.subtract(4, -4)).assertEqual(8);
    expect(MathUtil.subtract(-4, 4)).assertEqual(-8);
  });

  it('should return 0 when subtracting 0 from 0', Level.LEVEL0, () => {
    expect(MathUtil.subtract(0, 0)).assertEqual(0);
  });

  it('should return 2 when subtracting 3 from 5', Level.LEVEL0, () => {
    expect(MathUtil.subtract(5, 3)).assertEqual(2);
  });

  it('should return 1 when subtracting -1 from -2', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-2, -1)).assertEqual(1);
  });

  it('should return 0 when subtracting a number from its negative', Level.LEVEL0, () => {
    expect(MathUtil.subtract(4, -4)).assertEqual(8);
    expect(MathUtil.subtract(-4, 4)).assertEqual(-8);
  });

  // 新增的测试用例...

  it('should return 3 when subtracting 1 from 4', Level.LEVEL0, () => {
    expect(MathUtil.subtract(4, 1)).assertEqual(3);
  });

  it('should return -3 when subtracting -1 from -4', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-4, -1)).assertEqual(-3);
  });

  it('should return 6 when subtracting 2 from 8', Level.LEVEL0, () => {
    expect(MathUtil.subtract(8, 2)).assertEqual(6);
  });

  it('should return -6 when subtracting -2 from -8', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-8, -2)).assertEqual(-6);
  });

  it('should return 9 when subtracting 7 from 16', Level.LEVEL0, () => {
    expect(MathUtil.subtract(16, 7)).assertEqual(9);
  });

  it('should return -9 when subtracting -7 from -16', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-16, -7)).assertEqual(-9);
  });

  it('should return 10 when subtracting 5 from 15', Level.LEVEL0, () => {
    expect(MathUtil.subtract(15, 5)).assertEqual(10);
  });

  it('should return -10 when subtracting -5 from -15', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-15, -5)).assertEqual(-10);
  });

  it('should return 11 when subtracting 8 from 19', Level.LEVEL0, () => {
    expect(MathUtil.subtract(19, 8)).assertEqual(11);
  });

  it('should return -11 when subtracting -8 from -19', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-19, -8)).assertEqual(-11);
  });

  it('should return 12 when subtracting 9 from 21', Level.LEVEL0, () => {
    expect(MathUtil.subtract(21, 9)).assertEqual(12);
  });

  it('should return -12 when subtracting -9 from -21', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-21, -9)).assertEqual(-12);
  });

  it('should return 13 when subtracting 10 from 23', Level.LEVEL0, () => {
    expect(MathUtil.subtract(23, 10)).assertEqual(13);
  });

  it('should return -13 when subtracting -10 from -23', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-23, -10)).assertEqual(-13);
  });

  it('should return 14 when subtracting 11 from 25', Level.LEVEL0, () => {
    expect(MathUtil.subtract(25, 11)).assertEqual(14);
  });

  it('should return -14 when subtracting -11 from -25', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-25, -11)).assertEqual(-14);
  });

  it('should return 15 when subtracting 12 from 27', Level.LEVEL0, () => {
    expect(MathUtil.subtract(27, 12)).assertEqual(15);
  });

  it('should return -15 when subtracting -12 from -27', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-27, -12)).assertEqual(-15);
  });

  it('should return 16 when subtracting 13 from 29', Level.LEVEL0, () => {
    expect(MathUtil.subtract(29, 13)).assertEqual(16);
  });

  it('should return -16 when subtracting -13 from -29', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-29, -13)).assertEqual(-16);
  });

  it('should return 17 when subtracting 14 from 31', Level.LEVEL0, () => {
    expect(MathUtil.subtract(31, 14)).assertEqual(17);
  });

  it('should return -17 when subtracting -14 from -31', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-31, -14)).assertEqual(-17);
  });

  it('should return 18 when subtracting 15 from 33', Level.LEVEL0, () => {
    expect(MathUtil.subtract(33, 15)).assertEqual(18);
  });

  it('should return -18 when subtracting -15 from -33', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-33, -15)).assertEqual(-18);
  });

  it('should return 19 when subtracting 16 from 35', Level.LEVEL0, () => {
    expect(MathUtil.subtract(35, 16)).assertEqual(19);
  });

  it('should return -19 when subtracting -16 from -35', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-35, -16)).assertEqual(-19);
  });

  it('should return 20 when subtracting 17 from 37', Level.LEVEL0, () => {
    expect(MathUtil.subtract(37, 17)).assertEqual(20);
  });

  it('should return -20 when subtracting -17 from -37', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-37, -17)).assertEqual(-20);
  });

  it('should return 21 when subtracting 18 from 39', Level.LEVEL0, () => {
    expect(MathUtil.subtract(39, 18)).assertEqual(21);
  });

  it('should return -21 when subtracting -18 from -39', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-39, -18)).assertEqual(-21);
  });

  it('should return 22 when subtracting 19 from 41', Level.LEVEL0, () => {
    expect(MathUtil.subtract(41, 19)).assertEqual(22);
  });

  it('should return -22 when subtracting -19 from -41', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-41, -19)).assertEqual(-22);
  });

  it('should return 23 when subtracting 20 from 43', Level.LEVEL0, () => {
    expect(MathUtil.subtract(43, 20)).assertEqual(23);
  });

  it('should return -23 when subtracting -20 from -43', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-43, -20)).assertEqual(-23);
  });

  it('should return 24 when subtracting 21 from 45', Level.LEVEL0, () => {
    expect(MathUtil.subtract(45, 21)).assertEqual(24);
  });

  it('should return -24 when subtracting -21 from -45', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-45, -21)).assertEqual(-24);
  });

  it('should return 25 when subtracting 22 from 47', Level.LEVEL0, () => {
    expect(MathUtil.subtract(47, 22)).assertEqual(25);
  });

  it('should return -25 when subtracting -22 from -47', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-47, -22)).assertEqual(-25);
  });

  it('should return 26 when subtracting 23 from 49', Level.LEVEL0, () => {
    expect(MathUtil.subtract(49, 23)).assertEqual(26);
  });

  it('should return -26 when subtracting -23 from -49', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-49, -23)).assertEqual(-26);
  });

  it('should return 27 when subtracting 24 from 51', Level.LEVEL0, () => {
    expect(MathUtil.subtract(51, 24)).assertEqual(27);
  });

  it('should return -27 when subtracting -24 from -51', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-51, -24)).assertEqual(-27);
  });

  it('should return 28 when subtracting 25 from 53', Level.LEVEL0, () => {
    expect(MathUtil.subtract(53, 25)).assertEqual(28);
  });

  it('should return -28 when subtracting -25 from -53', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-53, -25)).assertEqual(-28);
  });

  it('should return 29 when subtracting 26 from 55', Level.LEVEL0, () => {
    expect(MathUtil.subtract(55, 26)).assertEqual(29);
  });

  it('should return -29 when subtracting -26 from -55', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-55, -26)).assertEqual(-29);
  });

  it('should return 30 when subtracting 27 from 57', Level.LEVEL0, () => {
    expect(MathUtil.subtract(57, 27)).assertEqual(30);
  });

  it('should return -30 when subtracting -27 from -57', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-57, -27)).assertEqual(-30);
  });

  it('should return 31 when subtracting 28 from 59', Level.LEVEL0, () => {
    expect(MathUtil.subtract(59, 28)).assertEqual(31);
  });

  it('should return -31 when subtracting -28 from -59', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-59, -28)).assertEqual(-31);
  });

  it('should return 32 when subtracting 29 from 61', Level.LEVEL0, () => {
    expect(MathUtil.subtract(61, 29)).assertEqual(32);
  });

  it('should return -32 when subtracting -29 from -61', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-61, -29)).assertEqual(-32);
  });

  it('should return 33 when subtracting 30 from 63', Level.LEVEL0, () => {
    expect(MathUtil.subtract(63, 30)).assertEqual(33);
  });

  it('should return -33 when subtracting -30 from -63', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-63, -30)).assertEqual(-33);
  });

  it('should return 34 when subtracting 31 from 65', Level.LEVEL0, () => {
    expect(MathUtil.subtract(65, 31)).assertEqual(34);
  });

  it('should return -34 when subtracting -31 from -65', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-65, -31)).assertEqual(-34);
  });

  it('should return 35 when subtracting 32 from 67', Level.LEVEL0, () => {
    expect(MathUtil.subtract(67, 32)).assertEqual(35);
  });

  it('should return -35 when subtracting -32 from -67', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-67, -32)).assertEqual(-35);
  });

  it('should return 36 when subtracting 33 from 69', Level.LEVEL0, () => {
    expect(MathUtil.subtract(69, 33)).assertEqual(36);
  });

  it('should return -36 when subtracting -33 from -69', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-69, -33)).assertEqual(-36);
  });

  it('should return 37 when subtracting 34 from 71', Level.LEVEL0, () => {
    expect(MathUtil.subtract(71, 34)).assertEqual(37);
  });

  it('should return -37 when subtracting -34 from -71', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-71, -34)).assertEqual(-37);
  });

  it('should return 38 when subtracting 35 from 73', Level.LEVEL0, () => {
    expect(MathUtil.subtract(73, 35)).assertEqual(38);
  });

  it('should return -38 when subtracting -35 from -73', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-73, -35)).assertEqual(-38);
  });

  it('should return 39 when subtracting 36 from 75', Level.LEVEL0, () => {
    expect(MathUtil.subtract(75, 36)).assertEqual(39);
  });

  it('should return -39 when subtracting -36 from -75', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-75, -36)).assertEqual(-39);
  });

  it('should return 40 when subtracting 37 from 77', Level.LEVEL0, () => {
    expect(MathUtil.subtract(77, 37)).assertEqual(40);
  });

  it('should return -40 when subtracting -37 from -77', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-77, -37)).assertEqual(-40);
  });

  it('should return 41 when subtracting 38 from 79', Level.LEVEL0, () => {
    expect(MathUtil.subtract(79, 38)).assertEqual(41);
  });

  it('should return -41 when subtracting -38 from -79', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-79, -38)).assertEqual(-41);
  });

  it('should return 42 when subtracting 39 from 81', Level.LEVEL0, () => {
    expect(MathUtil.subtract(81, 39)).assertEqual(42);
  });

  it('should return -42 when subtracting -39 from -81', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-81, -39)).assertEqual(-42);
  });

  it('should return 43 when subtracting 40 from 83', Level.LEVEL0, () => {
    expect(MathUtil.subtract(83, 40)).assertEqual(43);
  });

  it('should return -43 when subtracting -40 from -83', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-83, -40)).assertEqual(-43);
  });

  it('should return 44 when subtracting 41 from 85', Level.LEVEL0, () => {
    expect(MathUtil.subtract(85, 41)).assertEqual(44);
  });

  it('should return -44 when subtracting -41 from -85', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-85, -41)).assertEqual(-44);
  });

  it('should return 45 when subtracting 42 from 87', Level.LEVEL0, () => {
    expect(MathUtil.subtract(87, 42)).assertEqual(45);
  });

  it('should return -45 when subtracting -42 from -87', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-87, -42)).assertEqual(-45);
  });

  it('should return 46 when subtracting 43 from 89', Level.LEVEL0, () => {
    expect(MathUtil.subtract(89, 43)).assertEqual(46);
  });

  it('should return -46 when subtracting -43 from -89', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-89, -43)).assertEqual(-46);
  });

  it('should return 47 when subtracting 44 from 91', Level.LEVEL0, () => {
    expect(MathUtil.subtract(91, 44)).assertEqual(47);
  });

  it('should return -47 when subtracting -44 from -91', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-91, -44)).assertEqual(-47);
  });

  it('should return 48 when subtracting 45 from 93', Level.LEVEL0, () => {
    expect(MathUtil.subtract(93, 45)).assertEqual(48);
  });

  it('should return -48 when subtracting -45 from -93', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-93, -45)).assertEqual(-48);
  });

  it('should return 49 when subtracting 46 from 95', Level.LEVEL0, () => {
    expect(MathUtil.subtract(95, 46)).assertEqual(49);
  });

  it('should return -49 when subtracting -46 from -95', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-95, -46)).assertEqual(-49);
  });

  it('should return 50 when subtracting 47 from 97', Level.LEVEL0, () => {
    expect(MathUtil.subtract(97, 47)).assertEqual(50);
  });

  it('should return -50 when subtracting -47 from -97', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-97, -47)).assertEqual(-50);
  });

  it('should return 51 when subtracting 48 from 99', Level.LEVEL0, () => {
    expect(MathUtil.subtract(99, 48)).assertEqual(51);
  });

  it('should return -51 when subtracting -48 from -99', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-99, -48)).assertEqual(-51);
  });

  it('should return 52 when subtracting 49 from 101', Level.LEVEL0, () => {
    expect(MathUtil.subtract(101, 49)).assertEqual(52);
  });

  it('should return -52 when subtracting -49 from -101', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-101, -49)).assertEqual(-52);
  });

  it('should return 53 when subtracting 50 from 103', Level.LEVEL0, () => {
    expect(MathUtil.subtract(103, 50)).assertEqual(53);
  });

  it('should return -53 when subtracting -50 from -103', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-103, -50)).assertEqual(-53);
  });

  it('should return 54 when subtracting 51 from 105', Level.LEVEL0, () => {
    expect(MathUtil.subtract(105, 51)).assertEqual(54);
  });

  it('should return -54 when subtracting -51 from -105', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-105, -51)).assertEqual(-54);
  });

  it('should return 55 when subtracting 52 from 107', Level.LEVEL0, () => {
    expect(MathUtil.subtract(107, 52)).assertEqual(55);
  });

  it('should return -55 when subtracting -52 from -107', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-107, -52)).assertEqual(-55);
  });

  it('should return 56 when subtracting 53 from 109', Level.LEVEL0, () => {
    expect(MathUtil.subtract(109, 53)).assertEqual(56);
  });

  it('should return -56 when subtracting -53 from -109', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-109, -53)).assertEqual(-56);
  });

  it('should return 57 when subtracting 54 from 111', Level.LEVEL0, () => {
    expect(MathUtil.subtract(111, 54)).assertEqual(57);
  });

  it('should return -57 when subtracting -54 from -111', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-111, -54)).assertEqual(-57);
  });

  it('should return 58 when subtracting 55 from 113', Level.LEVEL0, () => {
    expect(MathUtil.subtract(113, 55)).assertEqual(58);
  });

  it('should return -58 when subtracting -55 from -113', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-113, -55)).assertEqual(-58);
  });

  it('should return 59 when subtracting 56 from 115', Level.LEVEL0, () => {
    expect(MathUtil.subtract(115, 56)).assertEqual(59);
  });

  it('should return -59 when subtracting -56 from -115', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-115, -56)).assertEqual(-59);
  });

  it('should return 60 when subtracting 57 from 117', Level.LEVEL0, () => {
    expect(MathUtil.subtract(117, 57)).assertEqual(60);
  });

  it('should return -60 when subtracting -57 from -117', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-117, -57)).assertEqual(-60);
  });

  it('should return 61 when subtracting 58 from 119', Level.LEVEL0, () => {
    expect(MathUtil.subtract(119, 58)).assertEqual(61);
  });

  it('should return -61 when subtracting -58 from -119', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-119, -58)).assertEqual(-61);
  });

  it('should return 62 when subtracting 59 from 121', Level.LEVEL0, () => {
    expect(MathUtil.subtract(121, 59)).assertEqual(62);
  });

  it('should return -62 when subtracting -59 from -121', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-121, -59)).assertEqual(-62);
  });

  it('should return 63 when subtracting 60 from 123', Level.LEVEL0, () => {
    expect(MathUtil.subtract(123, 60)).assertEqual(63);
  });

  it('should return -63 when subtracting -60 from -123', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-123, -60)).assertEqual(-63);
  });

  it('should return 64 when subtracting 61 from 125', Level.LEVEL0, () => {
    expect(MathUtil.subtract(125, 61)).assertEqual(64);
  });

  it('should return -64 when subtracting -61 from -125', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-125, -61)).assertEqual(-64);
  });

  it('should return 65 when subtracting 62 from 127', Level.LEVEL0, () => {
    expect(MathUtil.subtract(127, 62)).assertEqual(65);
  });

  it('should return -65 when subtracting -62 from -127', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-127, -62)).assertEqual(-65);
  });

  it('should return 66 when subtracting 63 from 129', Level.LEVEL0, () => {
    expect(MathUtil.subtract(129, 63)).assertEqual(66);
  });

  it('should return -66 when subtracting -63 from -129', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-129, -63)).assertEqual(-66);
  });

  it('should return 67 when subtracting 64 from 131', Level.LEVEL0, () => {
    expect(MathUtil.subtract(131, 64)).assertEqual(67);
  });

  it('should return -67 when subtracting -64 from -131', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-131, -64)).assertEqual(-67);
  });

  it('should return 68 when subtracting 65 from 133', Level.LEVEL0, () => {
    expect(MathUtil.subtract(133, 65)).assertEqual(68);
  });

  it('should return -68 when subtracting -65 from -133', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-133, -65)).assertEqual(-68);
  });

  it('should return 69 when subtracting 66 from 135', Level.LEVEL0, () => {
    expect(MathUtil.subtract(135, 66)).assertEqual(69);
  });

  it('should return -69 when subtracting -66 from -135', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-135, -66)).assertEqual(-69);
  });

  it('should return 70 when subtracting 67 from 137', Level.LEVEL0, () => {
    expect(MathUtil.subtract(137, 67)).assertEqual(70);
  });

  it('should return -70 when subtracting -67 from -137', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-137, -67)).assertEqual(-70);
  });

  it('should return 71 when subtracting 68 from 139', Level.LEVEL0, () => {
    expect(MathUtil.subtract(139, 68)).assertEqual(71);
  });

  it('should return -71 when subtracting -68 from -139', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-139, -68)).assertEqual(-71);
  });

  it('should return 72 when subtracting 69 from 141', Level.LEVEL0, () => {
    expect(MathUtil.subtract(141, 69)).assertEqual(72);
  });

  it('should return -72 when subtracting -69 from -141', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-141, -69)).assertEqual(-72);
  });

  it('should return 73 when subtracting 70 from 143', Level.LEVEL0, () => {
    expect(MathUtil.subtract(143, 70)).assertEqual(73);
  });

  it('should return -73 when subtracting -70 from -143', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-143, -70)).assertEqual(-73);
  });

  it('should return 74 when subtracting 71 from 145', Level.LEVEL0, () => {
    expect(MathUtil.subtract(145, 71)).assertEqual(74);
  });

  it('should return -74 when subtracting -71 from -145', Level.LEVEL0, () => {
    expect(MathUtil.subtract(-145, -71)).assertEqual(-74);
  });

  it('should return 75 when subtracting 72 from 147', Level.LEVEL0, () => {
    expect(MathUtil.subtract(147, 72)).assertEqual(75);
  });
}

function MathUtilTest_multiply() {
  it('should return 0 when multiplying 0 and any number', Level.LEVEL0, () => {
    expect(MathUtil.multiply(0, 5)).assertEqual(0);
    expect(MathUtil.multiply(5, 0)).assertEqual(0);
  });

  it('should return 10 when multiplying 2 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(2, 5)).assertEqual(10);
  });

  it('should return -10 when multiplying -2 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-2, 5)).assertEqual(-10);
  });

  it('should return -10 when multiplying 2 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(2, -5)).assertEqual(-10);
  });

  it('should return -20 when multiplying -2 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-2, -5)).assertEqual(20);
  });

  it('should return 5 when multiplying 1/2 and 2', Level.LEVEL0, () => {
    expect(MathUtil.multiply(0.5, 2)).assertEqual(1);
  });

  it('should return -5 when multiplying -1/2 and 2', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-0.5, 2)).assertEqual(-1);
  });

  it('should return 0 when multiplying 3 and 0', Level.LEVEL0, () => {
    expect(MathUtil.multiply(3, 0)).assertEqual(0);
  });

  it('should return 0 when multiplying 0 and 3', Level.LEVEL0, () => {
    expect(MathUtil.multiply(0, 3)).assertEqual(0);
  });

  it('should return 15 when multiplying 3 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(3, 5)).assertEqual(15);
  });

  it('should return -15 when multiplying -3 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-3, 5)).assertEqual(-15);
  });

  it('should return -15 when multiplying 3 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(3, -5)).assertEqual(-15);
  });

  it('should return 20 when multiplying 4 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(4, 5)).assertEqual(20);
  });

  it('should return -20 when multiplying -4 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-4, 5)).assertEqual(-20);
  });

  it('should return -20 when multiplying 4 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(4, -5)).assertEqual(-20);
  });

  it('should return 25 when multiplying 5 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(5, 5)).assertEqual(25);
  });

  it('should return -25 when multiplying -5 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-5, 5)).assertEqual(-25);
  });

  it('should return -25 when multiplying 5 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(5, -5)).assertEqual(-25);
  });

  it('should return 30 when multiplying 6 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(6, 5)).assertEqual(30);
  });

  it('should return -30 when multiplying -6 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-6, 5)).assertEqual(-30);
  });

  it('should return -30 when multiplying 6 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(6, -5)).assertEqual(-30);
  });

  it('should return 35 when multiplying 7 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(7, 5)).assertEqual(35);
  });

  it('should return -35 when multiplying 7 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(7, -5)).assertEqual(-35);
  });

  it('should return 40 when multiplying 8 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(8, 5)).assertEqual(40);
  });

  it('should return -40 when multiplying -8 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-8, 5)).assertEqual(-40);
  });

  it('should return -40 when multiplying 8 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(8, -5)).assertEqual(-40);
  });

  it('should return 45 when multiplying 9 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(9, 5)).assertEqual(45);
  });

  it('should return -45 when multiplying -9 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-9, 5)).assertEqual(-45);
  });

  it('should return -45 when multiplying 9 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(9, -5)).assertEqual(-45);
  });

  it('should return 50 when multiplying 10 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(10, 5)).assertEqual(50);
  });

  it('should return -50 when multiplying -10 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-10, 5)).assertEqual(-50);
  });

  it('should return -50 when multiplying 10 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(10, -5)).assertEqual(-50);
  });

  it('should return 55 when multiplying 11 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(11, 5)).assertEqual(55);
  });

  it('should return -55 when multiplying -11 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-11, 5)).assertEqual(-55);
  });

  it('should return -55 when multiplying 11 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(11, -5)).assertEqual(-55);
  });

  it('should return 60 when multiplying 12 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(12, 5)).assertEqual(60);
  });

  it('should return -60 when multiplying -12 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-12, 5)).assertEqual(-60);
  });

  it('should return -60 when multiplying 12 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(12, -5)).assertEqual(-60);
  });

  it('should return 65 when multiplying 13 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(13, 5)).assertEqual(65);
  });

  it('should return -65 when multiplying -13 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-13, 5)).assertEqual(-65);
  });

  it('should return -65 when multiplying 13 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(13, -5)).assertEqual(-65);
  });

  it('should return 70 when multiplying 14 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(14, 5)).assertEqual(70);
  });

  it('should return -70 when multiplying -14 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-14, 5)).assertEqual(-70);
  });

  it('should return -70 when multiplying 14 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(14, -5)).assertEqual(-70);
  });

  it('should return 75 when multiplying 15 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(15, 5)).assertEqual(75);
  });

  it('should return -75 when multiplying -15 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-15, 5)).assertEqual(-75);
  });

  it('should return -75 when multiplying 15 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(15, -5)).assertEqual(-75);
  });

  it('should return 80 when multiplying 16 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(16, 5)).assertEqual(80);
  });

  it('should return -80 when multiplying -16 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-16, 5)).assertEqual(-80);
  });

  it('should return -80 when multiplying 16 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(16, -5)).assertEqual(-80);
  });

  it('should return 85 when multiplying 17 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(17, 5)).assertEqual(85);
  });

  it('should return -85 when multiplying -17 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-17, 5)).assertEqual(-85);
  });

  it('should return -85 when multiplying 17 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(17, -5)).assertEqual(-85);
  });

  it('should return 90 when multiplying 18 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(18, 5)).assertEqual(90);
  });

  it('should return -90 when multiplying -18 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-18, 5)).assertEqual(-90);
  });

  it('should return -90 when multiplying 18 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(18, -5)).assertEqual(-90);
  });

  it('should return 95 when multiplying 19 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(19, 5)).assertEqual(95);
  });

  it('should return -95 when multiplying -19 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-19, 5)).assertEqual(-95);
  });

  it('should return -95 when multiplying 19 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(19, -5)).assertEqual(-95);
  });

  it('should return 100 when multiplying 20 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(20, 5)).assertEqual(100);
  });

  it('should return -100 when multiplying -20 and 5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(-20, 5)).assertEqual(-100);
  });

  it('should return -100 when multiplying 20 and -5', Level.LEVEL0, () => {
    expect(MathUtil.multiply(20, -5)).assertEqual(-100);
  });
}

function MathUtilTest_divider() {
  it('should return 0 when dividing by 0', Level.LEVEL0, () => {
    expect(MathUtil.divide(5, 0)).assertEqual(Infinity);
    expect(MathUtil.divide(0, 5)).assertEqual(0);
  });

  it('should return 1 when dividing 1 by 1', Level.LEVEL0, () => {
    expect(MathUtil.divide(1, 1)).assertEqual(1);
  });

  it('should return 0.5 when dividing 2 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(2, 4)).assertEqual(0.5);
  });

  it('should return -0.5 when dividing -2 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(-2, 4)).assertEqual(-0.5);
  });

  it('should return 0 when dividing 0 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(0, 4)).assertEqual(0);
  });

  it('should return -0 when dividing 0 by -4', Level.LEVEL0, () => {
    expect(MathUtil.divide(0, -4)).assertEqual(0);
  });

  it('should return 1 when dividing 3 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(3, 3)).assertEqual(1);
  });

  it('should return -1 when dividing -3 by -3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-3, -3)).assertEqual(1);
  });

  it('should return 0.6 when dividing 6 by 10', Level.LEVEL0, () => {
    expect(MathUtil.divide(6, 10)).assertEqual(0.6);
  });

  it('should return -0.6 when dividing -6 by 10', Level.LEVEL0, () => {
    expect(MathUtil.divide(-6, 10)).assertEqual(-0.6);
  });

  it('should return 0.75 when dividing 15 by 20', Level.LEVEL0, () => {
    expect(MathUtil.divide(15, 20)).assertEqual(0.75);
  });

  it('should return -0.75 when dividing -15 by 20', Level.LEVEL0, () => {
    expect(MathUtil.divide(-15, 20)).assertEqual(-0.75);
  });

  it('should return 1.5 when dividing 6 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(6, 4)).assertEqual(1.5);
  });

  it('should return -1.5 when dividing -6 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(-6, 4)).assertEqual(-1.5);
  });

  it('should return 2 when dividing 8 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(8, 4)).assertEqual(2);
  });

  it('should return -2 when dividing -8 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(-8, 4)).assertEqual(-2);
  });

  it('should return 3 when dividing 9 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(9, 3)).assertEqual(3);
  });

  it('should return -3 when dividing -9 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-9, 3)).assertEqual(-3);
  });

  it('should return 4 when dividing 12 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(12, 3)).assertEqual(4);
  });

  it('should return -4 when dividing -12 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-12, 3)).assertEqual(-4);
  });

  it('should return 5 when dividing 15 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(15, 3)).assertEqual(5);
  });

  it('should return -5 when dividing -15 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-15, 3)).assertEqual(-5);
  });

  it('should return 6 when dividing 18 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(18, 3)).assertEqual(6);
  });

  it('should return -6 when dividing -18 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-18, 3)).assertEqual(-6);
  });

  it('should return 7 when dividing 21 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(21, 3)).assertEqual(7);
  });

  it('should return -7 when dividing -21 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-21, 3)).assertEqual(-7);
  });

  it('should return 8 when dividing 24 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(24, 3)).assertEqual(8);
  });

  it('should return -8 when dividing -24 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-24, 3)).assertEqual(-8);
  });

  it('should return 9 when dividing 27 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(27, 3)).assertEqual(9);
  });

  it('should return -9 when dividing -27 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-27, 3)).assertEqual(-9);
  });

  it('should return 10 when dividing 30 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(30, 3)).assertEqual(10);
  });

  it('should return -10 when dividing -30 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-30, 3)).assertEqual(-10);
  });

  it('should return 11 when dividing 33 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(33, 3)).assertEqual(11);
  });

  it('should return -11 when dividing -33 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-33, 3)).assertEqual(-11);
  });

  it('should return 12 when dividing 36 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(36, 3)).assertEqual(12);
  });

  it('should return -12 when dividing -36 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-36, 3)).assertEqual(-12);
  });

  it('should return 13 when dividing 39 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(39, 3)).assertEqual(13);
  });

  it('should return -13 when dividing -39 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-39, 3)).assertEqual(-13);
  });

  it('should return 14 when dividing 42 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(42, 3)).assertEqual(14);
  });

  it('should return -14 when dividing -42 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-42, 3)).assertEqual(-14);
  });

  it('should return 15 when dividing 45 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(45, 3)).assertEqual(15);
  });

  it('should return -15 when dividing -45 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(-45, 3)).assertEqual(-15);
  });

  it('should return 1 when dividing 1 by 1', Level.LEVEL0, () => {
    expect(MathUtil.divide(1, 1)).assertEqual(1);
  });

  it('should return 0.5 when dividing 2 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(2, 4)).assertEqual(0.5);
  });

  it('should return -0.5 when dividing -2 by 4', Level.LEVEL0, () => {
    expect(MathUtil.divide(-2, 4)).assertEqual(-0.5);
  });

  it('should return -0.5 when dividing 2 by -4', Level.LEVEL0, () => {
    expect(MathUtil.divide(2, -4)).assertEqual(-0.5);
  });

  it('should return 0.5 when dividing -2 by -4', Level.LEVEL0, () => {
    expect(MathUtil.divide(-2, -4)).assertEqual(0.5);
  });

  it('should return 0 when dividing 3 by 0', Level.LEVEL0, () => {
    expect(MathUtil.divide(3, 0)).assertEqual(Infinity);
  });

  it('should return 0 when dividing 0 by 3', Level.LEVEL0, () => {
    expect(MathUtil.divide(0, 3)).assertEqual(0);
  });

  it('should return 1 when dividing 6 by 6', Level.LEVEL0, () => {
    expect(MathUtil.divide(6, 6)).assertEqual(1);
  });

  it('should return -1 when dividing -6 by 6', Level.LEVEL0, () => {
    expect(MathUtil.divide(-6, 6)).assertEqual(-1);
  });

  it('should return -1 when dividing 6 by -6', Level.LEVEL0, () => {
    expect(MathUtil.divide(6, -6)).assertEqual(-1);
  });

  it('should return 0.666 when dividing 3 by 4.5', Level.LEVEL0, () => {
    expect(MathUtil.divide(3, 4.5)).assertEqual(0.666);
  });

  it('should return -0.666 when dividing -3 by 4.5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-3, 4.5)).assertEqual(-0.666);
  });

  it('should return -0.666 when dividing 3 by -4.5', Level.LEVEL0, () => {
    expect(MathUtil.divide(3, -4.5)).assertEqual(-0.666);
  });

  it('should return 0.8 when dividing 4 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(4, 5)).assertEqual(0.8);
  });

  it('should return -0.8 when dividing -4 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-4, 5)).assertEqual(-0.8);
  });

  it('should return -0.8 when dividing 4 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(4, -5)).assertEqual(-0.8);
  });

  it('should return 1.5 when dividing 7.5 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(7.5, 5)).assertEqual(1.5);
  });

  it('should return -1.5 when dividing -7.5 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-7.5, 5)).assertEqual(-1.5);
  });

  it('should return -1.5 when dividing 7.5 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(7.5, -5)).assertEqual(-1.5);
  });

  it('should return 2 when dividing 10 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(10, 5)).assertEqual(2);
  });

  it('should return -2 when dividing -10 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-10, 5)).assertEqual(-2);
  });

  it('should return -2 when dividing 10 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(10, -5)).assertEqual(-2);
  });

  it('should return 2.5 when dividing 12.5 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(12.5, 5)).assertEqual(2.5);
  });

  it('should return -2.5 when dividing -12.5 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-12.5, 5)).assertEqual(-2.5);
  });

  it('should return -2.5 when dividing 12.5 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(12.5, -5)).assertEqual(-2.5);
  });

  it('should return 3 when dividing 15 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(15, 5)).assertEqual(3);
  });

  it('should return -3 when dividing -15 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-15, 5)).assertEqual(-3);
  });

  it('should return -3 when dividing 15 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(15, -5)).assertEqual(-3);
  });

  it('should return 3.6 when dividing 18 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(18, 5)).assertEqual(3.6);
  });

  it('should return -3.6 when dividing -18 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-18, 5)).assertEqual(-3.6);
  });

  it('should return -3.6 when dividing 18 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(18, -5)).assertEqual(-3.6);
  });

  it('should return 4 when dividing 20 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(20, 5)).assertEqual(4);
  });

  it('should return -4 when dividing -20 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-20, 5)).assertEqual(-4);
  });

  it('should return -4 when dividing 20 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(20, -5)).assertEqual(-4);
  });

  it('should return 4.8 when dividing 24 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(24, 5)).assertEqual(4.8);
  });

  it('should return -4.8 when dividing -24 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-24, 5)).assertEqual(-4.8);
  });

  it('should return -4.8 when dividing 24 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(24, -5)).assertEqual(-4.8);
  });

  it('should return 5 when dividing 25 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(25, 5)).assertEqual(5);
  });

  it('should return -5 when dividing -25 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-25, 5)).assertEqual(-5);
  });

  it('should return -5 when dividing 25 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(25, -5)).assertEqual(-5);
  });

  it('should return 5.2 when dividing 26 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(26, 5)).assertEqual(5.2);
  });

  it('should return -5.2 when dividing -26 by 5', Level.LEVEL0, () => {
    expect(MathUtil.divide(-26, 5)).assertEqual(-5.2);
  });

  it('should return -5.2 when dividing 26 by -5', Level.LEVEL0, () => {
    expect(MathUtil.divide(26, -5)).assertEqual(-5.2);
  });
}

function MathUtilTest_square() {
  it('should return 0 when dividing by 0', Level.LEVEL0, () => {
    expect(MathUtil.square(5)).assertEqual(25);
    expect(MathUtil.square(0)).assertEqual(0);
  });

  it('should return 1 when dividing 1 by 1', Level.LEVEL0, () => {
    expect(MathUtil.square(1)).assertEqual(1);
  });

  it('should return 0.5 when dividing 2 by 4', Level.LEVEL0, () => {
    expect(MathUtil.square(2)).assertEqual(4);
  });

  it('should return -0.5 when dividing -2 by 4', Level.LEVEL0, () => {
    expect(MathUtil.square(-2)).assertEqual(4);
  });

  it('should return -0.5 when dividing 2 by -4', Level.LEVEL0, () => {
    expect(MathUtil.square(2)).assertEqual(4);
  });

  it('should return 0.5 when dividing -2 by -4', Level.LEVEL0, () => {
    expect(MathUtil.square(-2)).assertEqual(4);
  });

  it('should return 0 when dividing 3 by 0', Level.LEVEL0, () => {
    expect(MathUtil.square(3)).assertEqual(9);
  });

  it('should return 0 when dividing 0 by 3', Level.LEVEL0, () => {
    expect(MathUtil.square(0)).assertEqual(0);
  });

  it('should return 1 when dividing 1 by 1', Level.LEVEL0, () => {
    expect(MathUtil.square(1)).assertEqual(1);
  });

  it('should return 4 when dividing 2 by 2', Level.LEVEL0, () => {
    expect(MathUtil.square(2)).assertEqual(4);
  });

  it('should return 4 when dividing -2 by -2', Level.LEVEL0, () => {
    expect(MathUtil.square(-2)).assertEqual(4);
  });

  it('should return -4 when dividing 2 by -2', Level.LEVEL0, () => {
    expect(MathUtil.square(2)).assertEqual(4);
  });

  it('should return -4 when dividing -2 by 2', Level.LEVEL0, () => {
    expect(MathUtil.square(-2)).assertEqual(4);
  });

  it('should return 9 when dividing 3 by 3', Level.LEVEL0, () => {
    expect(MathUtil.square(3)).assertEqual(9);
  });

  it('should return -9 when dividing 3 by -3', Level.LEVEL0, () => {
    expect(MathUtil.square(3)).assertEqual(9);
  });

  it('should return -9 when dividing -3 by 3', Level.LEVEL0, () => {
    expect(MathUtil.square(-3)).assertEqual(9);
  });

  it('should return -9 when dividing -3 by -3', Level.LEVEL0, () => {
    expect(MathUtil.square(-3)).assertEqual(9);
  });

  it('should return 16 when dividing 4 by 4', Level.LEVEL0, () => {
    expect(MathUtil.square(4)).assertEqual(16);
  });

  it('should return -16 when dividing 4 by -4', Level.LEVEL0, () => {
    expect(MathUtil.square(4)).assertEqual(16);
  });

  it('should return -16 when dividing -4 by 4', Level.LEVEL0, () => {
    expect(MathUtil.square(-4)).assertEqual(16);
  });

  it('should return -16 when dividing -4 by -4', Level.LEVEL0, () => {
    expect(MathUtil.square(-4)).assertEqual(16);
  });

  it('should return 25 when dividing 5 by 5', Level.LEVEL0, () => {
    expect(MathUtil.square(5)).assertEqual(25);
  });

  it('should return -25 when dividing 5 by -5', Level.LEVEL0, () => {
    expect(MathUtil.square(5)).assertEqual(25);
  });

  it('should return -25 when dividing -5 by 5', Level.LEVEL0, () => {
    expect(MathUtil.square(-5)).assertEqual(25);
  });

  it('should return -25 when dividing -5 by -5', Level.LEVEL0, () => {
    expect(MathUtil.square(-5)).assertEqual(25);
  });

  it('should return 36 when dividing 6 by 6', Level.LEVEL0, () => {
    expect(MathUtil.square(6)).assertEqual(36);
  });

  it('should return -36 when dividing 6 by -6', Level.LEVEL0, () => {
    expect(MathUtil.square(6)).assertEqual(36);
  });

  it('should return -36 when dividing -6 by 6', Level.LEVEL0, () => {
    expect(MathUtil.square(-6)).assertEqual(36);
  });

  it('should return -36 when dividing -6 by -6', Level.LEVEL0, () => {
    expect(MathUtil.square(-6)).assertEqual(36);
  });

  it('should return 49 when dividing 7 by 7', Level.LEVEL0, () => {
    expect(MathUtil.square(7)).assertEqual(49);
  });

  it('should return -49 when dividing 7 by -7', Level.LEVEL0, () => {
    expect(MathUtil.square(7)).assertEqual(49);
  });

  it('should return -49 when dividing -7 by 7', Level.LEVEL0, () => {
    expect(MathUtil.square(-7)).assertEqual(49);
  });

  it('should return -49 when dividing -7 by -7', Level.LEVEL0, () => {
    expect(MathUtil.square(-7)).assertEqual(49);
  });

  it('should return 64 when dividing 8 by 8', Level.LEVEL0, () => {
    expect(MathUtil.square(8)).assertEqual(64);
  });

  it('should return -64 when dividing 8 by -8', Level.LEVEL0, () => {
    expect(MathUtil.square(8)).assertEqual(64);
  });

  it('should return -64 when dividing -8 by 8', Level.LEVEL0, () => {
    expect(MathUtil.square(-8)).assertEqual(64);
  });

  it('should return -64 when dividing -8 by -8', Level.LEVEL0, () => {
    expect(MathUtil.square(-8)).assertEqual(64);
  });

  it('should return 81 when dividing 9 by 9', Level.LEVEL0, () => {
    expect(MathUtil.square(9)).assertEqual(81);
  });

  it('should return -81 when dividing 9 by -9', Level.LEVEL0, () => {
    expect(MathUtil.square(9)).assertEqual(81);
  });

  it('should return -81 when dividing -9 by 9', Level.LEVEL0, () => {
    expect(MathUtil.square(-9)).assertEqual(81);
  });

  it('should return -81 when dividing -9 by -9', Level.LEVEL0, () => {
    expect(MathUtil.square(-9)).assertEqual(81);
  });

  it('should return 100 when dividing 10 by 10', Level.LEVEL0, () => {
    expect(MathUtil.square(10)).assertEqual(100);
  });

  it('should return -100 when dividing 10 by -10', Level.LEVEL0, () => {
    expect(MathUtil.square(10)).assertEqual(100);
  });

  it('should return -100 when dividing -10 by 10', Level.LEVEL0, () => {
    expect(MathUtil.square(-10)).assertEqual(100);
  });

  it('should return -100 when dividing -10 by -10', Level.LEVEL0, () => {
    expect(MathUtil.square(-10)).assertEqual(100);
  });
}

function MathUtilTest_cube() {
  it('should return 125 when cube 5', Level.LEVEL0, () => {
    expect(MathUtil.cube(5)).assertEqual(125);
  });

  it('should return 1 when cube 5', Level.LEVEL0, () => {
    expect(MathUtil.cube(1)).assertEqual(1);
  });

  it('should return -1 when cube -1', Level.LEVEL0, () => {
    expect(MathUtil.cube(-1)).assertEqual(-1);
  });

  it('should return 0 when cube 0', Level.LEVEL0, () => {
    expect(MathUtil.cube(0)).assertEqual(0);
  });

  it('should return 8 when cube 2', Level.LEVEL0, () => {
    expect(MathUtil.cube(2)).assertEqual(8);
  });

  it('should return -8 when cube -2', Level.LEVEL0, () => {
    expect(MathUtil.cube(-2)).assertEqual(-8);
  });

  it('should return 27 when cube 3', Level.LEVEL0, () => {
    expect(MathUtil.cube(3)).assertEqual(27);
  });

  it('should return -27 when cube -3', Level.LEVEL0, () => {
    expect(MathUtil.cube(-3)).assertEqual(-27);
  });

  it('should return 64 when cube 4', Level.LEVEL0, () => {
    expect(MathUtil.cube(4)).assertEqual(64);
  });

  it('should return -64 when cube -4', Level.LEVEL0, () => {
    expect(MathUtil.cube(-4)).assertEqual(-64);
  });

  it('should return 125 when cube 5', Level.LEVEL0, () => {
    expect(MathUtil.cube(5)).assertEqual(125);
  });

  it('should return -125 when cube -5', Level.LEVEL0, () => {
    expect(MathUtil.cube(-5)).assertEqual(-125);
  });

  it('should return 216 when cube 6', Level.LEVEL0, () => {
    expect(MathUtil.cube(6)).assertEqual(216);
  });

  it('should return -216 when cube -6', Level.LEVEL0, () => {
    expect(MathUtil.cube(-6)).assertEqual(-216);
  });

  it('should return 343 when cube 7', Level.LEVEL0, () => {
    expect(MathUtil.cube(7)).assertEqual(343);
  });

  it('should return -343 when cube -7', Level.LEVEL0, () => {
    expect(MathUtil.cube(-7)).assertEqual(-343);
  });

  it('should return 512 when cube 8', Level.LEVEL0, () => {
    expect(MathUtil.cube(8)).assertEqual(512);
  });

  it('should return -512 when cube -8', Level.LEVEL0, () => {
    expect(MathUtil.cube(-8)).assertEqual(-512);
  });

  it('should return 729 when cube 9', Level.LEVEL0, () => {
    expect(MathUtil.cube(9)).assertEqual(729);
  });

  it('should return -729 when cube -9', Level.LEVEL0, () => {
    expect(MathUtil.cube(-9)).assertEqual(-729);
  });

  it('should return 1000 when cube 10', Level.LEVEL0, () => {
    expect(MathUtil.cube(10)).assertEqual(1000);
  });

  it('should return -1000 when cube -10', Level.LEVEL0, () => {
    expect(MathUtil.cube(-10)).assertEqual(-1000);
  });

  it('should return 1331 when cube 11', Level.LEVEL0, () => {
    expect(MathUtil.cube(11)).assertEqual(1331);
  });

  it('should return -1331 when cube -11', Level.LEVEL0, () => {
    expect(MathUtil.cube(-11)).assertEqual(-1331);
  });

  it('should return 1728 when cube 12', Level.LEVEL0, () => {
    expect(MathUtil.cube(12)).assertEqual(1728);
  });

  it('should return -1728 when cube -12', Level.LEVEL0, () => {
    expect(MathUtil.cube(-12)).assertEqual(-1728);
  });

  it('should return 2197 when cube 13', Level.LEVEL0, () => {
    expect(MathUtil.cube(13)).assertEqual(2197);
  });

  it('should return -2197 when cube -13', Level.LEVEL0, () => {
    expect(MathUtil.cube(-13)).assertEqual(-2197);
  });

  it('should return 2744 when cube 14', Level.LEVEL0, () => {
    expect(MathUtil.cube(14)).assertEqual(2744);
  });

  it('should return -2744 when cube -14', Level.LEVEL0, () => {
    expect(MathUtil.cube(-14)).assertEqual(-2744);
  });

  it('should return 3375 when cube 15', Level.LEVEL0, () => {
    expect(MathUtil.cube(15)).assertEqual(3375);
  });

  it('should return -3375 when cube -15', Level.LEVEL0, () => {
    expect(MathUtil.cube(-15)).assertEqual(-3375);
  });

  it('should return 4096 when cube 16', Level.LEVEL0, () => {
    expect(MathUtil.cube(16)).assertEqual(4096);
  });

  it('should return -4096 when cube -16', Level.LEVEL0, () => {
    expect(MathUtil.cube(-16)).assertEqual(-4096);
  });

  it('should return 4913 when cube 17', Level.LEVEL0, () => {
    expect(MathUtil.cube(17)).assertEqual(4913);
  });

  it('should return -4913 when cube -17', Level.LEVEL0, () => {
    expect(MathUtil.cube(-17)).assertEqual(-4913);
  });

  it('should return 5832 when cube 18', Level.LEVEL0, () => {
    expect(MathUtil.cube(18)).assertEqual(5832);
  });

  it('should return -5832 when cube -18', Level.LEVEL0, () => {
    expect(MathUtil.cube(-18)).assertEqual(-5832);
  });

  it('should return 6859 when cube 19', Level.LEVEL0, () => {
    expect(MathUtil.cube(19)).assertEqual(6859);
  });

  it('should return -6859 when cube -19', Level.LEVEL0, () => {
    expect(MathUtil.cube(-19)).assertEqual(-6859);
  });

  it('should return 8000 when cube 20', Level.LEVEL0, () => {
    expect(MathUtil.cube(20)).assertEqual(8000);
  });

  it('should return -8000 when cube -20', Level.LEVEL0, () => {
    expect(MathUtil.cube(-20)).assertEqual(-8000);
  });

  it('should return 9261 when cube 21', Level.LEVEL0, () => {
    expect(MathUtil.cube(21)).assertEqual(9261);
  });

  it('should return -9261 when cube -21', Level.LEVEL0, () => {
    expect(MathUtil.cube(-21)).assertEqual(-9261);
  });

  it('should return 10648 when cube 22', Level.LEVEL0, () => {
    expect(MathUtil.cube(22)).assertEqual(10648);
  });

  it('should return -10648 when cube -22', Level.LEVEL0, () => {
    expect(MathUtil.cube(-22)).assertEqual(-10648);
  });

  it('should return 12167 when cube 23', Level.LEVEL0, () => {
    expect(MathUtil.cube(23)).assertEqual(12167);
  });

  it('should return -12167 when cube -23', Level.LEVEL0, () => {
    expect(MathUtil.cube(-23)).assertEqual(-12167);
  });

  it('should return 13782 when cube 24', Level.LEVEL0, () => {
    expect(MathUtil.cube(24)).assertEqual(13782);
  });

  it('should return -13782 when cube -24', Level.LEVEL0, () => {
    expect(MathUtil.cube(-24)).assertEqual(-13782);
  });

  it('should return 15552 when cube 25', Level.LEVEL0, () => {
    expect(MathUtil.cube(25)).assertEqual(15552);
  });

  it('should return -15552 when cube -25', Level.LEVEL0, () => {
    expect(MathUtil.cube(-25)).assertEqual(-15552);
  });

  it('should return 17576 when cube 26', Level.LEVEL0, () => {
    expect(MathUtil.cube(26)).assertEqual(17576);
  });

  it('should return -17576 when cube -26', Level.LEVEL0, () => {
    expect(MathUtil.cube(-26)).assertEqual(-17576);
  });

  it('should return 19732 when cube 27', Level.LEVEL0, () => {
    expect(MathUtil.cube(27)).assertEqual(19732);
  });

  it('should return -19732 when cube -27', Level.LEVEL0, () => {
    expect(MathUtil.cube(-27)).assertEqual(-19732);
  });

  it('should return 21952 when cube 28', Level.LEVEL0, () => {
    expect(MathUtil.cube(28)).assertEqual(21952);
  });

  it('should return -21952 when cube -28', Level.LEVEL0, () => {
    expect(MathUtil.cube(-28)).assertEqual(-21952);
  });

  it('should return 24389 when cube 29', Level.LEVEL0, () => {
    expect(MathUtil.cube(29)).assertEqual(24389);
  });

  it('should return -24389 when cube -29', Level.LEVEL0, () => {
    expect(MathUtil.cube(-29)).assertEqual(-24389);
  });

  it('should return 270625 when cube 30', Level.LEVEL0, () => {
    expect(MathUtil.cube(30)).assertEqual(270625);
  });

  it('should return -270625 when cube -30', Level.LEVEL0, () => {
    expect(MathUtil.cube(-30)).assertEqual(-270625);
  });
}

function MathUtilTest_max() {
  it('should return 5 when max(1, 5)', Level.LEVEL0, () => {
    expect(MathUtil.max(1, 5)).assertEqual(5);
  });

  it('should return 5 when max(1, 5)', Level.LEVEL0, () => {
    expect(MathUtil.max(3, 7)).assertEqual(7);
  });

  it('should return 1 when max(1, 5)', Level.LEVEL0, () => {
    expect(MathUtil.max(1, 5)).assertEqual(5);
  });

  it('should return 7 when max(3, 7)', Level.LEVEL0, () => {
    expect(MathUtil.max(3, 7)).assertEqual(7);
  });

  it('should return -1 when max(-5, -10)', Level.LEVEL0, () => {
    expect(MathUtil.max(-5, -10)).assertEqual(-5);
  });

  it('should return 0 when max(0, 0)', Level.LEVEL0, () => {
    expect(MathUtil.max(0, 0)).assertEqual(0);
  });

  it('should return 1 when max(1, 1)', Level.LEVEL0, () => {
    expect(MathUtil.max(1, 1)).assertEqual(1);
  });

  it('should return -1 when max(-1, -1)', Level.LEVEL0, () => {
    expect(MathUtil.max(-1, -1)).assertEqual(-1);
  });

  it('should return 2 when max(2, 1)', Level.LEVEL0, () => {
    expect(MathUtil.max(2, 1)).assertEqual(2);
  });

  it('should return 2 when max(-2, -1)', Level.LEVEL0, () => {
    expect(MathUtil.max(-2, -1)).assertEqual(-2);
  });

  it('should return 3 when max(3, 2)', Level.LEVEL0, () => {
    expect(MathUtil.max(3, 2)).assertEqual(3);
  });

  it('should return 3 when max(-3, -2)', Level.LEVEL0, () => {
    expect(MathUtil.max(-3, -2)).assertEqual(-3);
  });

  it('should return 4 when max(4, 3)', Level.LEVEL0, () => {
    expect(MathUtil.max(4, 3)).assertEqual(4);
  });

  it('should return 4 when max(-4, -3)', Level.LEVEL0, () => {
    expect(MathUtil.max(-4, -3)).assertEqual(-4);
  });

  it('should return 5 when max(5, 4)', Level.LEVEL0, () => {
    expect(MathUtil.max(5, 4)).assertEqual(5);
  });

  it('should return 5 when max(-5, -4)', Level.LEVEL0, () => {
    expect(MathUtil.max(-5, -4)).assertEqual(-5);
  });

  it('should return 6 when max(6, 5)', Level.LEVEL0, () => {
    expect(MathUtil.max(6, 5)).assertEqual(6);
  });

  it('should return 6 when max(-6, -5)', Level.LEVEL0, () => {
    expect(MathUtil.max(-6, -5)).assertEqual(-6);
  });

  it('should return 7 when max(7, 6)', Level.LEVEL0, () => {
    expect(MathUtil.max(7, 6)).assertEqual(7);
  });

  it('should return 7 when max(-7, -6)', Level.LEVEL0, () => {
    expect(MathUtil.max(-7, -6)).assertEqual(-7);
  });

  it('should return 8 when max(8, 7)', Level.LEVEL0, () => {
    expect(MathUtil.max(8, 7)).assertEqual(8);
  });

  it('should return 8 when max(-8, -7)', Level.LEVEL0, () => {
    expect(MathUtil.max(-8, -7)).assertEqual(-8);
  });

  it('should return 9 when max(9, 8)', Level.LEVEL0, () => {
    expect(MathUtil.max(9, 8)).assertEqual(9);
  });

  it('should return 9 when max(-9, -8)', Level.LEVEL0, () => {
    expect(MathUtil.max(-9, -8)).assertEqual(-9);
  });

  it('should return 10 when max(10, 9)', Level.LEVEL0, () => {
    expect(MathUtil.max(10, 9)).assertEqual(10);
  });

  it('should return 10 when max(-10, -9)', Level.LEVEL0, () => {
    expect(MathUtil.max(-10, -9)).assertEqual(-10);
  });

  it('should return 11 when max(11, 10)', Level.LEVEL0, () => {
    expect(MathUtil.max(11, 10)).assertEqual(11);
  });

  it('should return 11 when max(-11, -10)', Level.LEVEL0, () => {
    expect(MathUtil.max(-11, -10)).assertEqual(-11);
  });

  it('should return 12 when max(12, 11)', Level.LEVEL0, () => {
    expect(MathUtil.max(12, 11)).assertEqual(12);
  });

  it('should return 12 when max(-12, -11)', Level.LEVEL0, () => {
    expect(MathUtil.max(-12, -11)).assertEqual(-12);
  });

  it('should return 13 when max(13, 12)', Level.LEVEL0, () => {
    expect(MathUtil.max(13, 12)).assertEqual(13);
  });

  it('should return 13 when max(-13, -12)', Level.LEVEL0, () => {
    expect(MathUtil.max(-13, -12)).assertEqual(-13);
  });

  it('should return 14 when max(14, 13)', Level.LEVEL0, () => {
    expect(MathUtil.max(14, 13)).assertEqual(14);
  });

  it('should return 14 when max(-14, -13)', Level.LEVEL0, () => {
    expect(MathUtil.max(-14, -13)).assertEqual(-14);
  });

  it('should return 15 when max(15, 14)', Level.LEVEL0, () => {
    expect(MathUtil.max(15, 14)).assertEqual(15);
  });

  it('should return 15 when max(-15, -14)', Level.LEVEL0, () => {
    expect(MathUtil.max(-15, -14)).assertEqual(-15);
  });

  it('should return 16 when max(16, 15)', Level.LEVEL0, () => {
    expect(MathUtil.max(16, 15)).assertEqual(16);
  });

  it('should return 16 when max(-16, -15)', Level.LEVEL0, () => {
    expect(MathUtil.max(-16, -15)).assertEqual(-16);
  });

  it('should return 17 when max(17, 16)', Level.LEVEL0, () => {
    expect(MathUtil.max(17, 16)).assertEqual(17);
  });

  it('should return 17 when max(-17, -16)', Level.LEVEL0, () => {
    expect(MathUtil.max(-17, -16)).assertEqual(-17);
  });

  it('should return 18 when max(18, 17)', Level.LEVEL0, () => {
    expect(MathUtil.max(18, 17)).assertEqual(18);
  });

  it('should return 18 when max(-18, -17)', Level.LEVEL0, () => {
    expect(MathUtil.max(-18, -17)).assertEqual(-18);
  });

  it('should return 19 when max(19, 18)', Level.LEVEL0, () => {
    expect(MathUtil.max(19, 18)).assertEqual(19);
  });

  it('should return 19 when max(-19, -18)', Level.LEVEL0, () => {
    expect(MathUtil.max(-19, -18)).assertEqual(-19);
  });

  it('should return 20 when max(20, 19)', Level.LEVEL0, () => {
    expect(MathUtil.max(20, 19)).assertEqual(20);
  });

  it('should return 20 when max(-20, -19)', Level.LEVEL0, () => {
    expect(MathUtil.max(-20, -19)).assertEqual(-20);
  });

  it('should return 21 when max(21, 20)', Level.LEVEL0, () => {
    expect(MathUtil.max(21, 20)).assertEqual(21);
  });

  it('should return 21 when max(-21, -20)', Level.LEVEL0, () => {
    expect(MathUtil.max(-21, -20)).assertEqual(-21);
  });

  it('should return 22 when max(22, 21)', Level.LEVEL0, () => {
    expect(MathUtil.max(22, 21)).assertEqual(22);
  });

  it('should return 22 when max(-22, -21)', Level.LEVEL0, () => {
    expect(MathUtil.max(-22, -21)).assertEqual(-22);
  });

  it('should return 23 when max(23, 22)', Level.LEVEL0, () => {
    expect(MathUtil.max(23, 22)).assertEqual(23);
  });

  it('should return 23 when max(-23, -22)', Level.LEVEL0, () => {
    expect(MathUtil.max(-23, -22)).assertEqual(-23);
  });

  it('should return 24 when max(24, 23)', Level.LEVEL0, () => {
    expect(MathUtil.max(24, 23)).assertEqual(24);
  });

  it('should return 24 when max(-24, -23)', Level.LEVEL0, () => {
    expect(MathUtil.max(-24, -23)).assertEqual(-24);
  });

  it('should return 25 when max(25, 24)', Level.LEVEL0, () => {
    expect(MathUtil.max(25, 24)).assertEqual(25);
  });

  it('should return 25 when max(-25, -24)', Level.LEVEL0, () => {
    expect(MathUtil.max(-25, -24)).assertEqual(-25);
  });

  it('should return 26 when max(26, 25)', Level.LEVEL0, () => {
    expect(MathUtil.max(26, 25)).assertEqual(26);
  });

  it('should return 26 when max(-26, -25)', Level.LEVEL0, () => {
    expect(MathUtil.max(-26, -25)).assertEqual(-26);
  });

  it('should return 27 when max(27, 26)', Level.LEVEL0, () => {
    expect(MathUtil.max(27, 26)).assertEqual(27);
  });

  it('should return 27 when max(-27, -26)', Level.LEVEL0, () => {
    expect(MathUtil.max(-27, -26)).assertEqual(-27);
  });

  it('should return 28 when max(28, 27)', Level.LEVEL0, () => {
    expect(MathUtil.max(28, 27)).assertEqual(28);
  });

  it('should return 28 when max(-28, -27)', Level.LEVEL0, () => {
    expect(MathUtil.max(-28, -27)).assertEqual(-28);
  });

  it('should return 29 when max(29, 28)', Level.LEVEL0, () => {
    expect(MathUtil.max(29, 28)).assertEqual(29);
  });

  it('should return 29 when max(-29, -28)', Level.LEVEL0, () => {
    expect(MathUtil.max(-29, -28)).assertEqual(-29);
  });

  it('should return 30 when max(30, 29)', Level.LEVEL0, () => {
    expect(MathUtil.max(30, 29)).assertEqual(30);
  });

  it('should return 30 when max(-30, -29)', Level.LEVEL0, () => {
    expect(MathUtil.max(-30, -29)).assertEqual(-30);
  });
}

function MathUtilTest_min() {
  it('should return 1 when min(1, 5)', Level.LEVEL0, () => {
    expect(MathUtil.min(1, 5)).assertEqual(1);
  });

  it('should return -5 when min(-1, -5)', Level.LEVEL0, () => {
    expect(MathUtil.min(-1, -5)).assertEqual(-5);
  });

  it('should return 3 when min(3, 7)', Level.LEVEL0, () => {
    expect(MathUtil.min(3, 7)).assertEqual(3);
  });

  it('should return -3 when min(-3, -7)', Level.LEVEL0, () => {
    expect(MathUtil.min(-3, -7)).assertEqual(-7);
  });

  it('should return 0 when min(0, 0)', Level.LEVEL0, () => {
    expect(MathUtil.min(0, 0)).assertEqual(0);
  });

  it('should return -1 when min(-1, -1)', Level.LEVEL0, () => {
    expect(MathUtil.min(-1, -1)).assertEqual(-1);
  });

  it('should return 2 when min(2, 1)', Level.LEVEL0, () => {
    expect(MathUtil.min(2, 1)).assertEqual(1);
  });

  it('should return -2 when min(-2, -1)', Level.LEVEL0, () => {
    expect(MathUtil.min(-2, -1)).assertEqual(-2);
  });

  it('should return 4 when min(4, 3)', Level.LEVEL0, () => {
    expect(MathUtil.min(4, 3)).assertEqual(3);
  });

  it('should return -4 when min(-4, -3)', Level.LEVEL0, () => {
    expect(MathUtil.min(-4, -3)).assertEqual(-4);
  });

  it('should return 5 when min(5, 4)', Level.LEVEL0, () => {
    expect(MathUtil.min(5, 4)).assertEqual(4);
  });

  it('should return -5 when min(-5, -4)', Level.LEVEL0, () => {
    expect(MathUtil.min(-5, -4)).assertEqual(-5);
  });

  it('should return 6 when min(6, 5)', Level.LEVEL0, () => {
    expect(MathUtil.min(6, 5)).assertEqual(5);
  });

  it('should return -6 when min(-6, -5)', Level.LEVEL0, () => {
    expect(MathUtil.min(-6, -5)).assertEqual(-6);
  });

  it('should return 7 when min(7, 6)', Level.LEVEL0, () => {
    expect(MathUtil.min(7, 6)).assertEqual(6);
  });

  it('should return -7 when min(-7, -6)', Level.LEVEL0, () => {
    expect(MathUtil.min(-7, -6)).assertEqual(-7);
  });

  it('should return 8 when min(8, 7)', Level.LEVEL0, () => {
    expect(MathUtil.min(8, 7)).assertEqual(7);
  });

  it('should return -8 when min(-8, -7)', Level.LEVEL0, () => {
    expect(MathUtil.min(-8, -7)).assertEqual(-8);
  });

  it('should return 9 when min(9, 8)', Level.LEVEL0, () => {
    expect(MathUtil.min(9, 8)).assertEqual(8);
  });

  it('should return -9 when min(-9, -8)', Level.LEVEL0, () => {
    expect(MathUtil.min(-9, -8)).assertEqual(-9);
  });

  it('should return 10 when min(10, 9)', Level.LEVEL0, () => {
    expect(MathUtil.min(10, 9)).assertEqual(9);
  });

  it('should return -10 when min(-10, -9)', Level.LEVEL0, () => {
    expect(MathUtil.min(-10, -9)).assertEqual(-10);
  });

  it('should return 11 when min(11, 10)', Level.LEVEL0, () => {
    expect(MathUtil.min(11, 10)).assertEqual(10);
  });

  it('should return -11 when min(-11, -10)', Level.LEVEL0, () => {
    expect(MathUtil.min(-11, -10)).assertEqual(-11);
  });

  it('should return 12 when min(12, 11)', Level.LEVEL0, () => {
    expect(MathUtil.min(12, 11)).assertEqual(11);
  });

  it('should return -12 when min(-12, -11)', Level.LEVEL0, () => {
    expect(MathUtil.min(-12, -11)).assertEqual(-12);
  });

  it('should return 13 when min(13, 12)', Level.LEVEL0, () => {
    expect(MathUtil.min(13, 12)).assertEqual(12);
  });

  it('should return -13 when min(-13, -12)', Level.LEVEL0, () => {
    expect(MathUtil.min(-13, -12)).assertEqual(-13);
  });

  it('should return 14 when min(14, 13)', Level.LEVEL0, () => {
    expect(MathUtil.min(14, 13)).assertEqual(13);
  });

  it('should return -14 when min(-14, -13)', Level.LEVEL0, () => {
    expect(MathUtil.min(-14, -13)).assertEqual(-14);
  });

  it('should return 15 when min(15, 14)', Level.LEVEL0, () => {
    expect(MathUtil.min(15, 14)).assertEqual(14);
  });

  it('should return -15 when min(-15, -14)', Level.LEVEL0, () => {
    expect(MathUtil.min(-15, -14)).assertEqual(-15);
  });

  it('should return 16 when min(16, 15)', Level.LEVEL0, () => {
    expect(MathUtil.min(16, 15)).assertEqual(15);
  });

  it('should return -16 when min(-16, -15)', Level.LEVEL0, () => {
    expect(MathUtil.min(-16, -15)).assertEqual(-16);
  });

  it('should return 17 when min(17, 16)', Level.LEVEL0, () => {
    expect(MathUtil.min(17, 16)).assertEqual(16);
  });

  it('should return -17 when min(-17, -16)', Level.LEVEL0, () => {
    expect(MathUtil.min(-17, -16)).assertEqual(-17);
  });

  it('should return 18 when min(18, 17)', Level.LEVEL0, () => {
    expect(MathUtil.min(18, 17)).assertEqual(17);
  });

  it('should return -18 when min(-18, -17)', Level.LEVEL0, () => {
    expect(MathUtil.min(-18, -17)).assertEqual(-18);
  });

  it('should return 19 when min(19, 18)', Level.LEVEL0, () => {
    expect(MathUtil.min(19, 18)).assertEqual(18);
  });

  it('should return -19 when min(-19, -18)', Level.LEVEL0, () => {
    expect(MathUtil.min(-19, -18)).assertEqual(-19);
  });

  it('should return 20 when min(20, 19)', Level.LEVEL0, () => {
    expect(MathUtil.min(20, 19)).assertEqual(19);
  });

  it('should return -20 when min(-20, -19)', Level.LEVEL0, () => {
    expect(MathUtil.min(-20, -19)).assertEqual(-20);
  });

  it('should return 21 when min(21, 20)', Level.LEVEL0, () => {
    expect(MathUtil.min(21, 20)).assertEqual(20);
  });

  it('should return -21 when min(-21, -20)', Level.LEVEL0, () => {
    expect(MathUtil.min(-21, -20)).assertEqual(-21);
  });

  it('should return 22 when min(22, 21)', Level.LEVEL0, () => {
    expect(MathUtil.min(22, 21)).assertEqual(21);
  });

  it('should return -22 when min(-22, -21)', Level.LEVEL0, () => {
    expect(MathUtil.min(-22, -21)).assertEqual(-22);
  });

  it('should return 23 when min(23, 22)', Level.LEVEL0, () => {
    expect(MathUtil.min(23, 22)).assertEqual(22);
  });

  it('should return -23 when min(-23, -22)', Level.LEVEL0, () => {
    expect(MathUtil.min(-23, -22)).assertEqual(-23);
  });

  it('should return 24 when min(24, 23)', Level.LEVEL0, () => {
    expect(MathUtil.min(24, 23)).assertEqual(23);
  });

  it('should return -24 when min(-24, -23)', Level.LEVEL0, () => {
    expect(MathUtil.min(-24, -23)).assertEqual(-24);
  });

  it('should return 25 when min(25, 24)', Level.LEVEL0, () => {
    expect(MathUtil.min(25, 24)).assertEqual(24);
  });

  it('should return -25 when min(-25, -24)', Level.LEVEL0, () => {
    expect(MathUtil.min(-25, -24)).assertEqual(-25);
  });

  it('should return 26 when min(26, 25)', Level.LEVEL0, () => {
    expect(MathUtil.min(26, 25)).assertEqual(25);
  });

  it('should return -26 when min(-26, -25)', Level.LEVEL0, () => {
    expect(MathUtil.min(-26, -25)).assertEqual(-26);
  });

  it('should return 27 when min(27, 26)', Level.LEVEL0, () => {
    expect(MathUtil.min(27, 26)).assertEqual(26);
  });

  it('should return -27 when min(-27, -26)', Level.LEVEL0, () => {
    expect(MathUtil.min(-27, -26)).assertEqual(-27);
  });

  it('should return 28 when min(28, 27)', Level.LEVEL0, () => {
    expect(MathUtil.min(28, 27)).assertEqual(27);
  });

  it('should return -28 when min(-28, -27)', Level.LEVEL0, () => {
    expect(MathUtil.min(-28, -27)).assertEqual(-28);
  });

  it('should return 29 when min(29, 28)', Level.LEVEL0, () => {
    expect(MathUtil.min(29, 28)).assertEqual(28);
  });

  it('should return -29 when min(-29, -28)', Level.LEVEL0, () => {
    expect(MathUtil.min(-29, -28)).assertEqual(-29);
  });

  it('should return 30 when min(30, 29)', Level.LEVEL0, () => {
    expect(MathUtil.min(30, 29)).assertEqual(29);
  });

  it('should return -30 when min(-30, -29)', Level.LEVEL0, () => {
    expect(MathUtil.min(-30, -29)).assertEqual(-30);
  });
}