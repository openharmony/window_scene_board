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
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { MathUtil } from './MathUtil';

let initAll = () => {

}

export function WaitingAddStateTest() {
  describe("MidSceneManagerTest_001", () => {
    beforeAll((): void => {
      initAll();
    });
    MathUtilTest_sum();
    MathUtilTest_average();
    MathUtilTest_product();
    MathUtilTest_power();
  });
}

function MathUtilTest_sum() {
  it('should return 0 when sum 0 and 0', Level.LEVEL0, () => {
    expect(MathUtil.sum(0, 0)).assertEqual(0);
  });

  it('should return 1 when sum 0 and 1', Level.LEVEL0, () => {
    expect(MathUtil.sum(0, 1)).assertEqual(1);
  });

  it('should return 2 when sum 1 and 1', Level.LEVEL0, () => {
    expect(MathUtil.sum(1, 1)).assertEqual(2);
  });

  it('should return 3 when sum 2 and 1', Level.LEVEL0, () => {
    expect(MathUtil.sum(2, 1)).assertEqual(3);
  });

  it('should return -3 when sum -2 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-2, -1)).assertEqual(-3);
  });

  it('should return -4 when sum -3 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-3, -1)).assertEqual(-4);
  });

  it('should return -5 when sum -4 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-4, -1)).assertEqual(-5);
  });

  it('should return -6 when sum -5 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-5, -1)).assertEqual(-6);
  });

  it('should return -7 when sum -6 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-6, -1)).assertEqual(-7);
  });

  it('should return -8 when sum -7 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-7, -1)).assertEqual(-8);
  });

  it('should return -9 when sum -8 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-8, -1)).assertEqual(-9);
  });

  it('should return -10 when sum -9 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-9, -1)).assertEqual(-10);
  });

  it('should return -11 when sum -10 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-10, -1)).assertEqual(-11);
  });

  it('should return -12 when sum -11 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-11, -1)).assertEqual(-12);
  });

  it('should return -13 when sum -12 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-12, -1)).assertEqual(-13);
  });

  it('should return -14 when sum -13 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-13, -1)).assertEqual(-14);
  });

  it('should return -15 when sum -14 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-14, -1)).assertEqual(-15);
  });

  it('should return -16 when sum -15 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-15, -1)).assertEqual(-16);
  });

  it('should return -17 when sum -16 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-16, -1)).assertEqual(-17);
  });

  it('should return -18 when sum -17 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-17, -1)).assertEqual(-18);
  });

  it('should return -19 when sum -18 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-18, -1)).assertEqual(-19);
  });

  it('should return -20 when sum -19 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-19, -1)).assertEqual(-20);
  });

  it('should return -21 when sum -20 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-20, -1)).assertEqual(-21);
  });

  it('should return -22 when sum -21 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-21, -1)).assertEqual(-22);
  });

  it('should return -23 when sum -22 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-22, -1)).assertEqual(-23);
  });

  it('should return -24 when sum -23 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-23, -1)).assertEqual(-24);
  });

  it('should return -25 when sum -24 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-24, -1)).assertEqual(-25);
  });

  it('should return -26 when sum -25 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-25, -1)).assertEqual(-26);
  });

  it('should return -27 when sum -26 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-26, -1)).assertEqual(-27);
  });

  it('should return -28 when sum -27 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-27, -1)).assertEqual(-28);
  });

  it('should return -29 when sum -28 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-28, -1)).assertEqual(-29);
  });

  it('should return -30 when sum -29 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-29, -1)).assertEqual(-30);
  });

  it('should return -31 when sum -30 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-30, -1)).assertEqual(-31);
  });

  it('should return -32 when sum -31 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-31, -1)).assertEqual(-32);
  });

  it('should return -33 when sum -32 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-32, -1)).assertEqual(-33);
  });

  it('should return -34 when sum -33 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-33, -1)).assertEqual(-34);
  });

  it('should return -35 when sum -34 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-34, -1)).assertEqual(-35);
  });

  it('should return -36 when sum -35 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-35, -1)).assertEqual(-36);
  });

  it('should return -37 when sum -36 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-36, -1)).assertEqual(-37);
  });

  it('should return -38 when sum -37 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-37, -1)).assertEqual(-38);
  });

  it('should return -39 when sum -38 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-38, -1)).assertEqual(-39);
  });

  it('should return -40 when sum -39 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-39, -1)).assertEqual(-40);
  });

  it('should return -41 when sum -40 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-40, -1)).assertEqual(-41);
  });

  it('should return -42 when sum -41 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-41, -1)).assertEqual(-42);
  });

  it('should return -43 when sum -42 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-42, -1)).assertEqual(-43);
  });

  it('should return -44 when sum -43 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-43, -1)).assertEqual(-44);
  });

  it('should return -45 when sum -44 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-44, -1)).assertEqual(-45);
  });

  it('should return -46 when sum -45 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-45, -1)).assertEqual(-46);
  });

  it('should return -47 when sum -46 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-46, -1)).assertEqual(-47);
  });

  it('should return -48 when sum -47 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-47, -1)).assertEqual(-48);
  });

  it('should return -49 when sum -48 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-48, -1)).assertEqual(-49);
  });

  it('should return -50 when sum -49 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-49, -1)).assertEqual(-50);
  });

  it('should return -51 when sum -50 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-50, -1)).assertEqual(-51);
  });

  it('should return -52 when sum -51 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-51, -1)).assertEqual(-52);
  });

  it('should return -53 when sum -52 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-52, -1)).assertEqual(-53);
  });

  it('should return -54 when sum -53 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-53, -1)).assertEqual(-54);
  });

  it('should return -55 when sum -54 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-54, -1)).assertEqual(-55);
  });

  it('should return -56 when sum -55 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-55, -1)).assertEqual(-56);
  });

  it('should return -57 when sum -56 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-56, -1)).assertEqual(-57);
  });

  it('should return -58 when sum -57 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-57, -1)).assertEqual(-58);
  });

  it('should return -59 when sum -58 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-58, -1)).assertEqual(-59);
  });

  it('should return -60 when sum -59 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-59, -1)).assertEqual(-60);
  });

  it('should return -61 when sum -60 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-60, -1)).assertEqual(-61);
  });

  it('should return -62 when sum -61 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-61, -1)).assertEqual(-62);
  });

  it('should return -63 when sum -62 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-62, -1)).assertEqual(-63);
  });

  it('should return -64 when sum -63 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-63, -1)).assertEqual(-64);
  });

  it('should return -65 when sum -64 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-64, -1)).assertEqual(-65);
  });

  it('should return -66 when sum -65 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-65, -1)).assertEqual(-66);
  });

  it('should return -67 when sum -66 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-66, -1)).assertEqual(-67);
  });

  it('should return -68 when sum -67 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-67, -1)).assertEqual(-68);
  });

  it('should return -69 when sum -68 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-68, -1)).assertEqual(-69);
  });

  it('should return -70 when sum -69 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-69, -1)).assertEqual(-70);
  });

  it('should return -71 when sum -70 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-70, -1)).assertEqual(-71);
  });

  it('should return -72 when sum -71 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-71, -1)).assertEqual(-72);
  });

  it('should return -73 when sum -72 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-72, -1)).assertEqual(-73);
  });

  it('should return -74 when sum -73 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-73, -1)).assertEqual(-74);
  });

  it('should return -75 when sum -74 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-74, -1)).assertEqual(-75);
  });

  it('should return -76 when sum -75 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-75, -1)).assertEqual(-76);
  });

  it('should return -77 when sum -76 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-76, -1)).assertEqual(-77);
  });

  it('should return -78 when sum -77 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-77, -1)).assertEqual(-78);
  });

  it('should return -79 when sum -78 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-78, -1)).assertEqual(-79);
  });

  it('should return -80 when sum -79 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-79, -1)).assertEqual(-80);
  });

  it('should return -81 when sum -80 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-80, -1)).assertEqual(-81);
  });

  it('should return -82 when sum -81 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-81, -1)).assertEqual(-82);
  });

  it('should return -83 when sum -82 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-82, -1)).assertEqual(-83);
  });

  it('should return -84 when sum -83 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-83, -1)).assertEqual(-84);
  });

  it('should return -85 when sum -84 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-84, -1)).assertEqual(-85);
  });

  it('should return -86 when sum -85 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-85, -1)).assertEqual(-86);
  });

  it('should return -87 when sum -86 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-86, -1)).assertEqual(-87);
  });

  it('should return -88 when sum -87 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-87, -1)).assertEqual(-88);
  });

  it('should return -89 when sum -88 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-88, -1)).assertEqual(-89);
  });

  it('should return -90 when sum -89 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-89, -1)).assertEqual(-90);
  });

  it('should return -91 when sum -90 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-90, -1)).assertEqual(-91);
  });

  it('should return -92 when sum -91 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-91, -1)).assertEqual(-92);
  });

  it('should return -93 when sum -92 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-92, -1)).assertEqual(-93);
  });

  it('should return -94 when sum -93 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-93, -1)).assertEqual(-94);
  });

  it('should return -95 when sum -94 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-94, -1)).assertEqual(-95);
  });

  it('should return -96 when sum -95 and -1', Level.LEVEL0, () => {
    expect(MathUtil.sum(-95, -1)).assertEqual(-96);
  });
}

function MathUtilTest_average() {
  it('should return 0 when average 0 and 1', Level.LEVEL0, () => {
    expect(MathUtil.average(0, 1)).assertEqual(0.5);
  });

  it('should return 1 when average 1 and 1', Level.LEVEL0, () => {
    expect(MathUtil.average(1, 1)).assertEqual(1);
  });

  it('should return 1.5 when average 1 and 2', Level.LEVEL0, () => {
    expect(MathUtil.average(1, 2)).assertEqual(1.5);
  });

  it('should return 8 when average 9 and 7', Level.LEVEL0, () => {
    expect(MathUtil.average(9, 7)).assertEqual(8);
  });

  it('should return 8.5 when average 9 and 8', Level.LEVEL0, () => {
    expect(MathUtil.average(9, 8)).assertEqual(8.5);
  });

  it('should return 7 when average 7 and 7', Level.LEVEL0, () => {
    expect(MathUtil.average(7, 7)).assertEqual(7);
  });

  it('should return 6 when average 6 and 6', Level.LEVEL0, () => {
    expect(MathUtil.average(6, 6)).assertEqual(6);
  });

  it('should return 5 when average 5 and 5', Level.LEVEL0, () => {
    expect(MathUtil.average(5, 5)).assertEqual(5);
  });

  it('should return 4 when average 4 and 4', Level.LEVEL0, () => {
    expect(MathUtil.average(4, 4)).assertEqual(4);
  });

  it('should return 3 when average 3 and 3', Level.LEVEL0, () => {
    expect(MathUtil.average(3, 3)).assertEqual(3);
  });

  it('should return 2 when average 2 and 2', Level.LEVEL0, () => {
    expect(MathUtil.average(2, 2)).assertEqual(2);
  });

  it('should return 1 when average 1 and 1', Level.LEVEL0, () => {
    expect(MathUtil.average(1, 1)).assertEqual(1);
  });

  it('should return 0 when average 0 and 0', Level.LEVEL0, () => {
    expect(MathUtil.average(0, 0)).assertEqual(0);
  });

  it('should return -1 when average -1 and -1', Level.LEVEL0, () => {
    expect(MathUtil.average(-1, -1)).assertEqual(-1);
  });

  it('should return -2 when average -2 and -2', Level.LEVEL0, () => {
    expect(MathUtil.average(-2, -2)).assertEqual(-2);
  });

  it('should return -3 when average -3 and -3', Level.LEVEL0, () => {
    expect(MathUtil.average(-3, -3)).assertEqual(-3);
  });

  it('should return -4 when average -4 and -4', Level.LEVEL0, () => {
    expect(MathUtil.average(-4, -4)).assertEqual(-4);
  });

  it('should return -5 when average -5 and -5', Level.LEVEL0, () => {
    expect(MathUtil.average(-5, -5)).assertEqual(-5);
  });

  it('should return -6 when average -6 and -6', Level.LEVEL0, () => {
    expect(MathUtil.average(-6, -6)).assertEqual(-6);
  });

  it('should return -7 when average -7 and -7', Level.LEVEL0, () => {
    expect(MathUtil.average(-7, -7)).assertEqual(-7);
  });

  it('should return -8 when average -8 and -8', Level.LEVEL0, () => {
    expect(MathUtil.average(-8, -8)).assertEqual(-8);
  });

  it('should return -9 when average -9 and -9', Level.LEVEL0, () => {
    expect(MathUtil.average(-9, -9)).assertEqual(-9);
  });

  it('should return -10 when average -10 and -10', Level.LEVEL0, () => {
    expect(MathUtil.average(-10, -10)).assertEqual(-10);
  });

  it('should return -11 when average -11 and -11', Level.LEVEL0, () => {
    expect(MathUtil.average(-11, -11)).assertEqual(-11);
  });

  it('should return -12 when average -12 and -12', Level.LEVEL0, () => {
    expect(MathUtil.average(-12, -12)).assertEqual(-12);
  });

  it('should return -13 when average -13 and -13', Level.LEVEL0, () => {
    expect(MathUtil.average(-13, -13)).assertEqual(-13);
  });

  it('should return -14 when average -14 and -14', Level.LEVEL0, () => {
    expect(MathUtil.average(-14, -14)).assertEqual(-14);
  });

  it('should return -15 when average -15 and -15', Level.LEVEL0, () => {
    expect(MathUtil.average(-15, -15)).assertEqual(-15);
  });

  it('should return -16 when average -16 and -16', Level.LEVEL0, () => {
    expect(MathUtil.average(-16, -16)).assertEqual(-16);
  });

  it('should return -17 when average -17 and -17', Level.LEVEL0, () => {
    expect(MathUtil.average(-17, -17)).assertEqual(-17);
  });

  it('should return -18 when average -18 and -18', Level.LEVEL0, () => {
    expect(MathUtil.average(-18, -18)).assertEqual(-18);
  });

  it('should return -19 when average -19 and -19', Level.LEVEL0, () => {
    expect(MathUtil.average(-19, -19)).assertEqual(-19);
  });

  it('should return -20 when average -20 and -20', Level.LEVEL0, () => {
    expect(MathUtil.average(-20, -20)).assertEqual(-20);
  });

  it('should return -21 when average -21 and -21', Level.LEVEL0, () => {
    expect(MathUtil.average(-21, -21)).assertEqual(-21);
  });

  it('should return -22 when average -22 and -22', Level.LEVEL0, () => {
    expect(MathUtil.average(-22, -22)).assertEqual(-22);
  });

  it('should return -23 when average -23 and -23', Level.LEVEL0, () => {
    expect(MathUtil.average(-23, -23)).assertEqual(-23);
  });

  it('should return -24 when average -24 and -24', Level.LEVEL0, () => {
    expect(MathUtil.average(-24, -24)).assertEqual(-24);
  });

  it('should return -25 when average -25 and -25', Level.LEVEL0, () => {
    expect(MathUtil.average(-25, -25)).assertEqual(-25);
  });

  it('should return -26 when average -26 and -26', Level.LEVEL0, () => {
    expect(MathUtil.average(-26, -26)).assertEqual(-26);
  });

  it('should return -27 when average -27 and -27', Level.LEVEL0, () => {
    expect(MathUtil.average(-27, -27)).assertEqual(-27);
  });

  it('should return -28 when average -28 and -28', Level.LEVEL0, () => {
    expect(MathUtil.average(-28, -28)).assertEqual(-28);
  });

  it('should return -29 when average -29 and -29', Level.LEVEL0, () => {
    expect(MathUtil.average(-29, -29)).assertEqual(-29);
  });

  it('should return -30 when average -30 and -30', Level.LEVEL0, () => {
    expect(MathUtil.average(-30, -30)).assertEqual(-30);
  });

  it('should return -31 when average -31 and -31', Level.LEVEL0, () => {
    expect(MathUtil.average(-31, -31)).assertEqual(-31);
  });

  it('should return -32 when average -32 and -32', Level.LEVEL0, () => {
    expect(MathUtil.average(-32, -32)).assertEqual(-32);
  });

  it('should return -33 when average -33 and -33', Level.LEVEL0, () => {
    expect(MathUtil.average(-33, -33)).assertEqual(-33);
  });

  it('should return -34 when average -34 and -34', Level.LEVEL0, () => {
    expect(MathUtil.average(-34, -34)).assertEqual(-34);
  });

  it('should return -35 when average -35 and -35', Level.LEVEL0, () => {
    expect(MathUtil.average(-35, -35)).assertEqual(-35);
  });

  it('should return -36 when average -36 and -36', Level.LEVEL0, () => {
    expect(MathUtil.average(-36, -36)).assertEqual(-36);
  });

  it('should return -37 when average -37 and -37', Level.LEVEL0, () => {
    expect(MathUtil.average(-37, -37)).assertEqual(-37);
  });

  it('should return -38 when average -38 and -38', Level.LEVEL0, () => {
    expect(MathUtil.average(-38, -38)).assertEqual(-38);
  });

  it('should return -39 when average -39 and -39', Level.LEVEL0, () => {
    expect(MathUtil.average(-39, -39)).assertEqual(-39);
  });

  it('should return -40 when average -40 and -40', Level.LEVEL0, () => {
    expect(MathUtil.average(-40, -40)).assertEqual(-40);
  });

  it('should return -41 when average -41 and -41', Level.LEVEL0, () => {
    expect(MathUtil.average(-41, -41)).assertEqual(-41);
  });

  it('should return -42 when average -42 and -42', Level.LEVEL0, () => {
    expect(MathUtil.average(-42, -42)).assertEqual(-42);
  });

  it('should return -43 when average -43 and -43', Level.LEVEL0, () => {
    expect(MathUtil.average(-43, -43)).assertEqual(-43);
  });

  it('should return -44 when average -44 and -44', Level.LEVEL0, () => {
    expect(MathUtil.average(-44, -44)).assertEqual(-44);
  });

  it('should return -45 when average -45 and -45', Level.LEVEL0, () => {
    expect(MathUtil.average(-45, -45)).assertEqual(-45);
  });

  it('should return -46 when average -46 and -46', Level.LEVEL0, () => {
    expect(MathUtil.average(-46, -46)).assertEqual(-46);
  });

  it('should return -47 when average -47 and -47', Level.LEVEL0, () => {
    expect(MathUtil.average(-47, -47)).assertEqual(-47);
  });

  it('should return -48 when average -48 and -48', Level.LEVEL0, () => {
    expect(MathUtil.average(-48, -48)).assertEqual(-48);
  });

  it('should return -49 when average -49 and -49', Level.LEVEL0, () => {
    expect(MathUtil.average(-49, -49)).assertEqual(-49);
  });

  it('should return -50 when average -50 and -50', Level.LEVEL0, () => {
    expect(MathUtil.average(-50, -50)).assertEqual(-50);
  });

  it('should return -51 when average -51 and -51', Level.LEVEL0, () => {
    expect(MathUtil.average(-51, -51)).assertEqual(-51);
  });

  it('should return -52 when average -52 and -52', Level.LEVEL0, () => {
    expect(MathUtil.average(-52, -52)).assertEqual(-52);
  });

  it('should return -53 when average -53 and -53', Level.LEVEL0, () => {
    expect(MathUtil.average(-53, -53)).assertEqual(-53);
  });

  it('should return -54 when average -54 and -54', Level.LEVEL0, () => {
    expect(MathUtil.average(-54, -54)).assertEqual(-54);
  });

  it('should return -55 when average -55 and -55', Level.LEVEL0, () => {
    expect(MathUtil.average(-55, -55)).assertEqual(-55);
  });

  it('should return -56 when average -56 and -56', Level.LEVEL0, () => {
    expect(MathUtil.average(-56, -56)).assertEqual(-56);
  });

  it('should return -57 when average -57 and -57', Level.LEVEL0, () => {
    expect(MathUtil.average(-57, -57)).assertEqual(-57);
  });

  it('should return -58 when average -58 and -58', Level.LEVEL0, () => {
    expect(MathUtil.average(-58, -58)).assertEqual(-58);
  });

  it('should return -59 when average -59 and -59', Level.LEVEL0, () => {
    expect(MathUtil.average(-59, -59)).assertEqual(-59);
  });

  it('should return -60 when average -60 and -60', Level.LEVEL0, () => {
    expect(MathUtil.average(-60, -60)).assertEqual(-60);
  });

  it('should return -61 when average -61 and -61', Level.LEVEL0, () => {
    expect(MathUtil.average(-61, -61)).assertEqual(-61);
  });

  it('should return -62 when average -62 and -62', Level.LEVEL0, () => {
    expect(MathUtil.average(-62, -62)).assertEqual(-62);
  });

  it('should return -63 when average -63 and -63', Level.LEVEL0, () => {
    expect(MathUtil.average(-63, -63)).assertEqual(-63);
  });

  it('should return -64 when average -64 and -64', Level.LEVEL0, () => {
    expect(MathUtil.average(-64, -64)).assertEqual(-64);
  });

  it('should return -65 when average -65 and -65', Level.LEVEL0, () => {
    expect(MathUtil.average(-65, -65)).assertEqual(-65);
  });

  it('should return -66 when average -66 and -66', Level.LEVEL0, () => {
    expect(MathUtil.average(-66, -66)).assertEqual(-66);
  });

  it('should return -67 when average -67 and -67', Level.LEVEL0, () => {
    expect(MathUtil.average(-67, -67)).assertEqual(-67);
  });

  it('should return -68 when average -68 and -68', Level.LEVEL0, () => {
    expect(MathUtil.average(-68, -68)).assertEqual(-68);
  });

  it('should return -69 when average -69 and -69', Level.LEVEL0, () => {
    expect(MathUtil.average(-69, -69)).assertEqual(-69);
  });

  it('should return -70 when average -70 and -70', Level.LEVEL0, () => {
    expect(MathUtil.average(-70, -70)).assertEqual(-70);
  });

  it('should return -71 when average -71 and -71', Level.LEVEL0, () => {
    expect(MathUtil.average(-71, -71)).assertEqual(-71);
  });

  it('should return -72 when average -72 and -72', Level.LEVEL0, () => {
    expect(MathUtil.average(-72, -72)).assertEqual(-72);
  });

  it('should return -73 when average -73 and -73', Level.LEVEL0, () => {
    expect(MathUtil.average(-73, -73)).assertEqual(-73);
  });

  it('should return -74 when average -74 and -74', Level.LEVEL0, () => {
    expect(MathUtil.average(-74, -74)).assertEqual(-74);
  });

  it('should return -75 when average -75 and -75', Level.LEVEL0, () => {
    expect(MathUtil.average(-75, -75)).assertEqual(-75);
  });

  it('should return -76 when average -76 and -76', Level.LEVEL0, () => {
    expect(MathUtil.average(-76, -76)).assertEqual(-76);
  });

  it('should return -77 when average -77 and -77', Level.LEVEL0, () => {
    expect(MathUtil.average(-77, -77)).assertEqual(-77);
  });

  it('should return -78 when average -78 and -78', Level.LEVEL0, () => {
    expect(MathUtil.average(-78, -78)).assertEqual(-78);
  });

  it('should return -79 when average -79 and -79', Level.LEVEL0, () => {
    expect(MathUtil.average(-79, -79)).assertEqual(-79);
  });

  it('should return -80 when average -80 and -80', Level.LEVEL0, () => {
    expect(MathUtil.average(-80, -80)).assertEqual(-80);
  });

  it('should return -81 when average -81 and -81', Level.LEVEL0, () => {
    expect(MathUtil.average(-81, -81)).assertEqual(-81);
  });

  it('should return -82 when average -82 and -82', Level.LEVEL0, () => {
    expect(MathUtil.average(-82, -82)).assertEqual(-82);
  });

  it('should return -83 when average -83 and -83', Level.LEVEL0, () => {
    expect(MathUtil.average(-83, -83)).assertEqual(-83);
  });

  it('should return -84 when average -84 and -84', Level.LEVEL0, () => {
    expect(MathUtil.average(-84, -84)).assertEqual(-84);
  });
}

function MathUtilTest_product() {
  it('should return 12 when product 3 and 4', Level.LEVEL0, () => {
    expect(MathUtil.product(3, 4)).assertEqual(12);
  });

  it('should return 63 when product 7 and 9', Level.LEVEL0, () => {
    expect(MathUtil.product(7, 9)).assertEqual(63);
  });

  it('should return 121 when product 11 and 11', Level.LEVEL0, () => {
    expect(MathUtil.product(11, 11)).assertEqual(121);
  });

  it('should return 0 when product 0 and 0', Level.LEVEL0, () => {
    expect(MathUtil.product(0, 0)).assertEqual(0);
  });

  it('should return -6 when product -2 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-2, -3)).assertEqual(-6);
  });

  it('should return -9 when product -3 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-3, -3)).assertEqual(-9);
  });

  it('should return -12 when product -4 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-4, -3)).assertEqual(-12);
  });

  it('should return -15 when product -5 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-5, -3)).assertEqual(-15);
  });

  it('should return -18 when product -6 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-6, -3)).assertEqual(-18);
  });

  it('should return -21 when product -7 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-7, -3)).assertEqual(-21);
  });

  it('should return -24 when product -8 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-8, -3)).assertEqual(-24);
  });

  it('should return -27 when product -9 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-9, -3)).assertEqual(-27);
  });

  it('should return -30 when product -10 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-10, -3)).assertEqual(-30);
  });

  it('should return -33 when product -11 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-11, -3)).assertEqual(-33);
  });

  it('should return -36 when product -12 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-12, -3)).assertEqual(-36);
  });

  it('should return -39 when product -13 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-13, -3)).assertEqual(-39);
  });

  it('should return -42 when product -14 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-14, -3)).assertEqual(-42);
  });

  it('should return -45 when product -15 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-15, -3)).assertEqual(-45);
  });

  it('should return -48 when product -16 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-16, -3)).assertEqual(-48);
  });

  it('should return -51 when product -17 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-17, -3)).assertEqual(-51);
  });

  it('should return -54 when product -18 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-18, -3)).assertEqual(-54);
  });

  it('should return -57 when product -19 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-19, -3)).assertEqual(-57);
  });

  it('should return -60 when product -20 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-20, -3)).assertEqual(-60);
  });

  it('should return -63 when product -21 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-21, -3)).assertEqual(-63);
  });

  it('should return -66 when product -22 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-22, -3)).assertEqual(-66);
  });

  it('should return -69 when product -23 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-23, -3)).assertEqual(-69);
  });

  it('should return -72 when product -24 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-24, -3)).assertEqual(-72);
  });

  it('should return -75 when product -25 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-25, -3)).assertEqual(-75);
  });

  it('should return -78 when product -26 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-26, -3)).assertEqual(-78);
  });

  it('should return -81 when product -27 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-27, -3)).assertEqual(-81);
  });

  it('should return -84 when product -28 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-28, -3)).assertEqual(-84);
  });

  it('should return -87 when product -29 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-29, -3)).assertEqual(-87);
  });

  it('should return -90 when product -30 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-30, -3)).assertEqual(-90);
  });

  it('should return -93 when product -31 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-31, -3)).assertEqual(-93);
  });

  it('should return -96 when product -32 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-32, -3)).assertEqual(-96);
  });

  it('should return -99 when product -33 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-33, -3)).assertEqual(-99);
  });

  it('should return -102 when product -34 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-34, -3)).assertEqual(-102);
  });

  it('should return -105 when product -35 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-35, -3)).assertEqual(-105);
  });

  it('should return -108 when product -36 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-36, -3)).assertEqual(-108);
  });

  it('should return -111 when product -37 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-37, -3)).assertEqual(-111);
  });

  it('should return -114 when product -38 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-38, -3)).assertEqual(-114);
  });

  it('should return -117 when product -39 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-39, -3)).assertEqual(-117);
  });

  it('should return -120 when product -40 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-40, -3)).assertEqual(-120);
  });

  it('should return -123 when product -41 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-41, -3)).assertEqual(-123);
  });

  it('should return -126 when product -42 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-42, -3)).assertEqual(-126);
  });

  it('should return -129 when product -43 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-43, -3)).assertEqual(-129);
  });

  it('should return -132 when product -44 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-44, -3)).assertEqual(-132);
  });

  it('should return -135 when product -45 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-45, -3)).assertEqual(-135);
  });

  it('should return -138 when product -46 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-46, -3)).assertEqual(-138);
  });

  it('should return -141 when product -47 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-47, -3)).assertEqual(-141);
  });

  it('should return -144 when product -48 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-48, -3)).assertEqual(-144);
  });

  it('should return -147 when product -49 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-49, -3)).assertEqual(-147);
  });

  it('should return -150 when product -50 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-50, -3)).assertEqual(-150);
  });

  it('should return -153 when product -51 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-51, -3)).assertEqual(-153);
  });

  it('should return -156 when product -52 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-52, -3)).assertEqual(-156);
  });

  it('should return -159 when product -53 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-53, -3)).assertEqual(-159);
  });

  it('should return -162 when product -54 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-54, -3)).assertEqual(-162);
  });

  it('should return -165 when product -55 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-55, -3)).assertEqual(-165);
  });

  it('should return -168 when product -56 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-56, -3)).assertEqual(-168);
  });

  it('should return -171 when product -57 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-57, -3)).assertEqual(-171);
  });

  it('should return -174 when product -58 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-58, -3)).assertEqual(-174);
  });

  it('should return -177 when product -59 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-59, -3)).assertEqual(-177);
  });

  it('should return -180 when product -60 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-60, -3)).assertEqual(-180);
  });

  it('should return -183 when product -61 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-61, -3)).assertEqual(-183);
  });

  it('should return -186 when product -62 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-62, -3)).assertEqual(-186);
  });

  it('should return -189 when product -63 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-63, -3)).assertEqual(-189);
  });

  it('should return -192 when product -64 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-64, -3)).assertEqual(-192);
  });

  it('should return -195 when product -65 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-65, -3)).assertEqual(-195);
  });

  it('should return -198 when product -66 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-66, -3)).assertEqual(-198);
  });

  it('should return -201 when product -67 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-67, -3)).assertEqual(-201);
  });

  it('should return -204 when product -68 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-68, -3)).assertEqual(-204);
  });

  it('should return -207 when product -69 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-69, -3)).assertEqual(-207);
  });

  it('should return -210 when product -70 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-70, -3)).assertEqual(-210);
  });

  it('should return -213 when product -71 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-71, -3)).assertEqual(-213);
  });

  it('should return -216 when product -72 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-72, -3)).assertEqual(-216);
  });

  it('should return -219 when product -73 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-73, -3)).assertEqual(-219);
  });

  it('should return -222 when product -74 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-74, -3)).assertEqual(-222);
  });

  it('should return -225 when product -75 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-75, -3)).assertEqual(-225);
  });

  it('should return -228 when product -76 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-76, -3)).assertEqual(-228);
  });

  it('should return -231 when product -77 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-77, -3)).assertEqual(-231);
  });

  it('should return -234 when product -78 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-78, -3)).assertEqual(-234);
  });

  it('should return -237 when product -79 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-79, -3)).assertEqual(-237);
  });

  it('should return -240 when product -80 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-80, -3)).assertEqual(-240);
  });

  it('should return -243 when product -81 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-81, -3)).assertEqual(-243);
  });

  it('should return -246 when product -82 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-82, -3)).assertEqual(-246);
  });

  it('should return -249 when product -83 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-83, -3)).assertEqual(-249);
  });

  it('should return -252 when product -84 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-84, -3)).assertEqual(-252);
  });

  it('should return -255 when product -85 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-85, -3)).assertEqual(-255);
  });

  it('should return -258 when product -86 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-86, -3)).assertEqual(-258);
  });

  it('should return -261 when product -87 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-87, -3)).assertEqual(-261);
  });

  it('should return -264 when product -88 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-88, -3)).assertEqual(-264);
  });

  it('should return -267 when product -89 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-89, -3)).assertEqual(-267);
  });

  it('should return -270 when product -90 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-90, -3)).assertEqual(-270);
  });

  it('should return -273 when product -91 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-91, -3)).assertEqual(-273);
  });

  it('should return -276 when product -92 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-92, -3)).assertEqual(-276);
  });

  it('should return -279 when product -93 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-93, -3)).assertEqual(-279);
  });

  it('should return -282 when product -94 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-94, -3)).assertEqual(-282);
  });

  it('should return -285 when product -95 and -3', Level.LEVEL0, () => {
    expect(MathUtil.product(-95, -3)).assertEqual(-285);
  });
}

function MathUtilTest_power() {
  it('should return 12 when power 3 and 2', Level.LEVEL0, () => {
    expect(MathUtil.power(3, 2)).assertEqual(9);
  });

  it('should return 63 when product 7 and 9', Level.LEVEL0, () => {
    expect(MathUtil.power(4,2)).assertEqual(16);
  });

  it('should return 121 when product 11 and 11', Level.LEVEL0, () => {
    expect(MathUtil.power(3, 3)).assertEqual(27);
  });

  it('should return 0 when power 0 and 0', Level.LEVEL0, () => {
    expect(MathUtil.power(0, 0)).assertEqual(1);
  });

  it('should return 1 when power 1 and 1', Level.LEVEL0, () => {
    expect(MathUtil.power(1, 1)).assertEqual(1);
  });

  it('should return 4 when power 2 and 2', Level.LEVEL0, () => {
    expect(MathUtil.power(2, 2)).assertEqual(4);
  });

  it('should return 8 when power 2 and 3', Level.LEVEL0, () => {
    expect(MathUtil.power(2, 3)).assertEqual(8);
  });

  it('should return 27 when power 3 and 3', Level.LEVEL0, () => {
    expect(MathUtil.power(3, 3)).assertEqual(27);
  });

  it('should return 64 when power 4 and 2', Level.LEVEL0, () => {
    expect(MathUtil.power(4, 2)).assertEqual(16);
  });

  it('should return 125 when power 5 and 2', Level.LEVEL0, () => {
    expect(MathUtil.power(5, 2)).assertEqual(25);
  });

  it('should return 27 when power 3 and 3', Level.LEVEL0, () => {
    expect(MathUtil.power(3, 3)).assertEqual(27);
  });

  it('should return 1 when power 0 and 1', Level.LEVEL0, () => {
    expect(MathUtil.power(0, 1)).assertEqual(1);
  });

  it('should return 1 when power 1 and 0', Level.LEVEL0, () => {
    expect(MathUtil.power(1, 0)).assertEqual(1);
  });

  it('should return 1 when power 2 and 0', Level.LEVEL0, () => {
    expect(MathUtil.power(2, 0)).assertEqual(1);
  });

  it('should return 1 when power 0 and 2', Level.LEVEL0, () => {
    expect(MathUtil.power(0, 2)).assertEqual(0);
  });

  it('should return 1 when power -1 and -1', Level.LEVEL0, () => {
    expect(MathUtil.power(-1, -1)).assertEqual(1);
  });

  it('should return 1 when power -2 and -2', Level.LEVEL0, () => {
    expect(MathUtil.power(-2, -2)).assertEqual(1);
  });

  it('should return 1 when power -3 and -3', Level.LEVEL0, () => {
    expect(MathUtil.power(-3, -3)).assertEqual(1);
  });

  it('should return 1 when power -4 and -4', Level.LEVEL0, () => {
    expect(MathUtil.power(-4, -4)).assertEqual(1);
  });

  it('should return 1 when power -5 and -5', Level.LEVEL0, () => {
    expect(MathUtil.power(-5, -5)).assertEqual(1);
  });

  it('should return 1 when power -6 and -6', Level.LEVEL0, () => {
    expect(MathUtil.power(-6, -6)).assertEqual(1);
  });

  it('should return 1 when power -7 and -7', Level.LEVEL0, () => {
    expect(MathUtil.power(-7, -7)).assertEqual(1);
  });

  it('should return 1 when power -8 and -8', Level.LEVEL0, () => {
    expect(MathUtil.power(-8, -8)).assertEqual(1);
  });

  it('should return 1 when power -9 and -9', Level.LEVEL0, () => {
    expect(MathUtil.power(-9, -9)).assertEqual(1);
  });

  it('should return 1 when power -10 and -10', Level.LEVEL0, () => {
    expect(MathUtil.power(-10, -10)).assertEqual(1);
  });

  it('should return 1 when power 1 and -1', Level.LEVEL0, () => {
    expect(MathUtil.power(1, -1)).assertEqual(1);
  });

  it('should return 1 when power -1 and 1', Level.LEVEL0, () => {
    expect(MathUtil.power(-1, 1)).assertEqual(-1);
  });

  it('should return 1 when power -2 and 2', Level.LEVEL0, () => {
    expect(MathUtil.power(-2, 2)).assertEqual(4);
  });

  it('should return 1 when power 2 and -2', Level.LEVEL0, () => {
    expect(MathUtil.power(2, -2)).assertEqual(0.25);
  });

  it('should return 1 when power -3 and 3', Level.LEVEL0, () => {
    expect(MathUtil.power(-3, 3)).assertEqual(-27);
  });

  it('should return 1 when power 3 and -3', Level.LEVEL0, () => {
    expect(MathUtil.power(3, -3)).assertEqual(0.125);
  });

  it('should return 1 when power -4 and 4', Level.LEVEL0, () => {
    expect(MathUtil.power(-4, 4)).assertEqual(256);
  });

  it('should return 1 when power 4 and -4', Level.LEVEL0, () => {
    expect(MathUtil.power(4, -4)).assertEqual(0.0625);
  });

  it('should return 1 when power -5 and 5', Level.LEVEL0, () => {
    expect(MathUtil.power(-5, 5)).assertEqual(3125);
  });

  it('should return 1 when power 5 and -5', Level.LEVEL0, () => {
    expect(MathUtil.power(5, -5)).assertEqual(0.03125);
  });

  it('should return 1 when power -6 and 6', Level.LEVEL0, () => {
    expect(MathUtil.power(-6, 6)).assertEqual(46656);
  });

  it('should return 1 when power 6 and -6', Level.LEVEL0, () => {
    expect(MathUtil.power(6, -6)).assertEqual(0.015625);
  });

  it('should return 1 when power -7 and 7', Level.LEVEL0, () => {
    expect(MathUtil.power(-7, 7)).assertEqual(823543);
  });

  it('should return 1 when power 7 and -7', Level.LEVEL0, () => {
    expect(MathUtil.power(7, -7)).assertEqual(0.0078125);
  });

  it('should return 1 when power -8 and 8', Level.LEVEL0, () => {
    expect(MathUtil.power(-8, 8)).assertEqual(65536);
  });

  it('should return 1 when power 8 and -8', Level.LEVEL0, () => {
    expect(MathUtil.power(8, -8)).assertEqual(0.00390625);
  });

  it('should return 1 when power -9 and 9', Level.LEVEL0, () => {
    expect(MathUtil.power(-9, 9)).assertEqual(387420489);
  });

  it('should return 1 when power 9 and -9', Level.LEVEL0, () => {
    expect(MathUtil.power(9, -9)).assertEqual(0.001953125);
  });

  it('should return 1 when power -10 and 10', Level.LEVEL0, () => {
    expect(MathUtil.power(-10, 10)).assertEqual(100000000);
  });

  it('should return 1 when power 10 and -10', Level.LEVEL0, () => {
    expect(MathUtil.power(10, -10)).assertEqual(0.0009765625);
  });

  it('should return 1 when power -11 and 11', Level.LEVEL0, () => {
    expect(MathUtil.power(-11, 11)).assertEqual(1771561824);
  });

  it('should return 1 when power 11 and -11', Level.LEVEL0, () => {
    expect(MathUtil.power(11, -11)).assertEqual(0.00048828125);
  });

  it('should return 1 when power -12 and 12', Level.LEVEL0, () => {
    expect(MathUtil.power(-12, 12)).assertEqual(16777216);
  });

  it('should return 1 when power 12 and -12', Level.LEVEL0, () => {
    expect(MathUtil.power(12, -12)).assertEqual(0.000244140625);
  });

  it('should return 1 when power -13 and 13', Level.LEVEL0, () => {
    expect(MathUtil.power(-13, 13)).assertEqual(2199023255552);
  });

  it('should return 1 when power 13 and -13', Level.LEVEL0, () => {
    expect(MathUtil.power(13, -13)).assertEqual(0.0001220703125);
  });

  it('should return 1 when power -14 and 14', Level.LEVEL0, () => {
    expect(MathUtil.power(-14, 14)).assertEqual(4398046511104);
  });

  it('should return 1 when power 14 and -14', Level.LEVEL0, () => {
    expect(MathUtil.power(14, -14)).assertEqual(0.000060546875);
  });

  it('should return 1 when power -15 and 15', Level.LEVEL0, () => {
    expect(MathUtil.power(-15, 15)).assertEqual(9223372036854775808);
  });

  it('should return 1 when power 15 and -15', Level.LEVEL0, () => {
    expect(MathUtil.power(15, -15)).assertEqual(0.0000302734375);
  });

  it('should return 1 when power -16 and 16', Level.LEVEL0, () => {
    expect(MathUtil.power(-16, 16)).assertEqual(18446744073709551616);
  });

  it('should return 1 when power 16 and -16', Level.LEVEL0, () => {
    expect(MathUtil.power(16, -16)).assertEqual(0.00001513671875);
  });

  it('should return 1 when power -17 and 17', Level.LEVEL0, () => {
    expect(MathUtil.power(-17, 17)).assertEqual(340282366920938463463374607431768211456);
  });

  it('should return 1 when power 17 and -17', Level.LEVEL0, () => {
    expect(MathUtil.power(17, -17)).assertEqual(0.000007568359375);
  });

  it('should return 1 when power -18 and 18', Level.LEVEL0, () => {
    expect(MathUtil.power(-18, 18)).assertEqual(720575940379279351616);
  });

  it('should return 1 when power 18 and -18', Level.LEVEL0, () => {
    expect(MathUtil.power(18, -18)).assertEqual(0.0000037841796875);
  });

  it('should return 1 when power -19 and 19', Level.LEVEL0, () => {
    expect(MathUtil.power(-19, 19)).assertEqual(131072000000000000000000);
  });

  it('should return 1 when power 19 and -19', Level.LEVEL0, () => {
    expect(MathUtil.power(19, -19)).assertEqual(0.00000189208984375);
  });

  it('should return 1 when power -20 and 20', Level.LEVEL0, () => {
    expect(MathUtil.power(-20, 20)).assertEqual(1048576);
  });

  it('should return 1 when power 20 and -20', Level.LEVEL0, () => {
    expect(MathUtil.power(20, -20)).assertEqual(0.0000009458984375);
  });

  it('should return 1 when power -21 and 21', Level.LEVEL0, () => {
    expect(MathUtil.power(-21, 21)).assertEqual(22282279684173632734);
  });

  it('should return 1 when power 21 and -21', Level.LEVEL0, () => {
    expect(MathUtil.power(21, -21)).assertEqual(0.00000047319140625);
  });

  it('should return 1 when power -22 and 22', Level.LEVEL0, () => {
    expect(MathUtil.power(-22, 22)).assertEqual(4194304);
  });

  it('should return 1 when power 22 and -22', Level.LEVEL0, () => {
    expect(MathUtil.power(22, -22)).assertEqual(0.0000002369140625);
  });

  it('should return 1 when power -23 and 23', Level.LEVEL0, () => {
    expect(MathUtil.power(-23, 23)).assertEqual(8388608);
  });

  it('should return 1 when power 23 and -23', Level.LEVEL0, () => {
    expect(MathUtil.power(23, -23)).assertEqual(0.000000118565625);
  });
}