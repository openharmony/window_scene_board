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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { CapsuleLifecycleVm } from '../../../main/ets/vm/CapsuleLifecycleVm';

export function PoweroffControllerTest() {
  describe('PoweroffControllerTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('getLifecycleTime1', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(1);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime2', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(2);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime3', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(3);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime4', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(4);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime5', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(5);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime6', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(6);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime7', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(7);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime8', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(8);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime9', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(9);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime10', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(10);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime11', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(11);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime12', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(12);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime13', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(13);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime14', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(14);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime15', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(15);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime16', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(16);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime17', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(17);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime18', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(18);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime19', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(19);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime20', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(20);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime21', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(21);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime22', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(22);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime23', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(23);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime24', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(24);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime25', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(25);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime26', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(26);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime27', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(27);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime28', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(28);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime29', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(29);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime30', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(30);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime31', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(31);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime32', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(32);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime33', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(33);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime34', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(34);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime35', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(35);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime36', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(36);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime37', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(37);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime38', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(38);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime39', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(39);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime40', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(40);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime41', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(41);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime42', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(42);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime43', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(43);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime44', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(44);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime45', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(45);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime46', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(46);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime47', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(47);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime48', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(48);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime49', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(49);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime50', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(50);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime51', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(51);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime52', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(52);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime53', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(53);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime54', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(54);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime55', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(55);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime56', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(56);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime57', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(57);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime58', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(58);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime59', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(59);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime60', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(60);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime61', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(61);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime62', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(62);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime63', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(63);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime64', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(64);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime65', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(65);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime66', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(66);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime67', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(67);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime68', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(68);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime69', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(69);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime70', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(70);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime71', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(71);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime72', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(72);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime73', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(73);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime74', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(74);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime75', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(75);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime76', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(76);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime77', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(77);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime78', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(78);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime79', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(79);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime80', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(80);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime81', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(81);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime82', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(82);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime83', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(83);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime84', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(84);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime85', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(85);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime86', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(86);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime87', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(87);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime88', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(88);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime89', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(89);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime90', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(90);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime91', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(91);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime92', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(92);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime93', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(93);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime94', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(94);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime95', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(95);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime96', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(96);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime97', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(97);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime98', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(98);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime99', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(99);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime100', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(100);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime101', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(101);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime102', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(102);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime103', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(103);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime104', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(104);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime105', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(105);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime106', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(106);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime107', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(107);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime108', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(108);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime109', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(109);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime110', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(110);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime111', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(111);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime112', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(112);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime113', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(113);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime114', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(114);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime115', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(115);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime116', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(116);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime117', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(117);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime118', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(118);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime119', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(119);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime120', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(120);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime121', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(121);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime122', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(122);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime123', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(123);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime124', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(124);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime125', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(125);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime126', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(126);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime127', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(127);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime128', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(128);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime129', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(129);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime130', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(130);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime131', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(131);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime132', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(132);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime133', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(133);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime134', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(134);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime135', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(135);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime136', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(136);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime137', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(137);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime138', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(138);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime139', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(139);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime140', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(140);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime141', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(141);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime142', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(142);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime143', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(143);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime144', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(144);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime145', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(145);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime146', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(146);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime147', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(147);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime148', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(148);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime149', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(149);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime150', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(150);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime151', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(151);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime152', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(152);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime153', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(153);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime154', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(154);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime155', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(155);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime156', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(156);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime157', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(157);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime158', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(158);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime159', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(159);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime160', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(160);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime161', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(161);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime162', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(162);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime163', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(163);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime164', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(164);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime165', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(165);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime166', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(166);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime167', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(167);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime168', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(168);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime169', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(169);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime170', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(170);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime171', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(171);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime172', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(172);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime173', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(173);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime174', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(174);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime175', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(175);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime176', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(176);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime177', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(177);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime178', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(178);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime179', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(179);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime180', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(180);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime181', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(181);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime182', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(182);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime183', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(183);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime184', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(184);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime185', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(185);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime186', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(186);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime187', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(187);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime188', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(188);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime189', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(189);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime190', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(190);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime191', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(191);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime192', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(192);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime193', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(193);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime194', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(194);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime195', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(195);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime196', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(196);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime197', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(197);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime198', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(198);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime199', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(199);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime200', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(200);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime201', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(201);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime202', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(202);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime203', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(203);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime204', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(204);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime205', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(205);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime206', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(206);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime207', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(207);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime208', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(208);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime209', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(209);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime210', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(210);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime211', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(211);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime212', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(212);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime213', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(213);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime214', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(214);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime215', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(215);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime216', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(216);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime217', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(217);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime218', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(218);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime219', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(219);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime220', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(220);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime221', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(221);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime222', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(222);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime223', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(223);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime224', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(224);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime225', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(225);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime226', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(226);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime227', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(227);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime228', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(228);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime229', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(229);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime230', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(230);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime231', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(231);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime232', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(232);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime233', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(233);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime234', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(234);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime235', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(235);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime236', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(236);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime237', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(237);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime238', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(238);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime239', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(239);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime240', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(240);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime241', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(241);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime242', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(242);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime243', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(243);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime244', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(244);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime245', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(245);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime246', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(246);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime247', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(247);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime248', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(248);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime249', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(249);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime250', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(250);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime251', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(251);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime252', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(252);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime253', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(253);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime254', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(254);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime255', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(255);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime256', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(256);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime257', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(257);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime258', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(258);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime259', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(259);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime260', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(260);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime261', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(261);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime262', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(262);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime263', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(263);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime264', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(264);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime265', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(265);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime266', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(266);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime267', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(267);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime268', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(268);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime269', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(269);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime270', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(270);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime271', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(271);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime272', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(272);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime273', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(273);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime274', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(274);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime275', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(275);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime276', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(276);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime277', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(277);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime278', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(278);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime279', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(279);
      expect(time).not().assertFail();
    })
    it('getLifecycleTime280', 0, (): void => {
      let vm: CapsuleLifecycleVm = new CapsuleLifecycleVm();
      vm.init();
      let time = vm.getLifecycleTime(1);
      vm.deleteLifecycleInfo(280);
      expect(time).not().assertFail();
    })

  })
}