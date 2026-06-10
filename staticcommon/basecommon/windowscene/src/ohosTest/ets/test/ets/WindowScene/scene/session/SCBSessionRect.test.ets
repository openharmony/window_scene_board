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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { ScbNumber, SCBSessionRect } from '../../../../../../../main/ets/TsIndex';

export function SCBSessionRectTest() {
  describe('SCBSessionRectTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('setRectTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.setRect(new ScbNumber(11), new ScbNumber(20), new ScbNumber(30), new ScbNumber(40));
      expect(sessionRect.left.getPx()).assertEqual(11);
      expect(sessionRect.top.getPx()).assertEqual(20);
      expect(sessionRect.width.getPx()).assertEqual(30);
      expect(sessionRect.height.getPx()).assertEqual(40);
    })

    it('setRectNumTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.setRectNum(10, 20, 30, 40);
      expect(sessionRect.left.getPx()).assertEqual(10);
      expect(sessionRect.top.getPx()).assertEqual(20);
      expect(sessionRect.width.getPx()).assertEqual(30);
      expect(sessionRect.height.getPx()).assertEqual(40);
    })

    it('setPosNumTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.setPosNum(10, 20);
      expect(sessionRect.left.getPx()).assertEqual(10);
      expect(sessionRect.top.getPx()).assertEqual(20);
    })

    it('setSizeNumTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.setSizeNum(30, 40);
      expect(sessionRect.width.getPx()).assertEqual(30);
      expect(sessionRect.height.getPx()).assertEqual(40);
    })

    it('setSizeTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.setSize(new ScbNumber(30), new ScbNumber(40));
      expect(sessionRect.width.getPx()).assertEqual(30);
      expect(sessionRect.height.getPx()).assertEqual(40);
    })

    it('setPosTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.setPos(new ScbNumber(10), new ScbNumber(20));
      expect(sessionRect.left.getPx()).assertEqual(10);
      expect(sessionRect.top.getPx()).assertEqual(20);
    })

    it('copyTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      let copyRect = sessionRect.copy();
      expect(copyRect.left.getPx()).assertEqual(10);
      expect(copyRect.top.getPx()).assertEqual(20);
      expect(copyRect.width.getPx()).assertEqual(30);
      expect(copyRect.height.getPx()).assertEqual(40);
    })

    it('copyFromTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      sessionRect.copyFrom(new SCBSessionRect(10, 20, 30, 40));
      expect(sessionRect.left.getPx()).assertEqual(10);
      expect(sessionRect.top.getPx()).assertEqual(20);
      expect(sessionRect.width.getPx()).assertEqual(30);
      expect(sessionRect.height.getPx()).assertEqual(40);
    })

    it('isEmptyTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect();
      expect(sessionRect.isEmpty()).assertTrue();

      let sessionRect2: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      expect(sessionRect2.isEmpty()).assertFalse();
    })

    it('equalsTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      expect(sessionRect.equals(new SCBSessionRect)).assertFalse();
      expect(sessionRect.equals(new SCBSessionRect(10, 20, 30, 40))).assertTrue();
    })

    it('equalsOfSizeTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      expect(sessionRect.equalsOfSize(new SCBSessionRect)).assertFalse();
      expect(sessionRect.equalsOfSize(new SCBSessionRect(0, 0, 30, 40))).assertTrue();
    })

    it('containsTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      expect(sessionRect.contains(10, 20)).assertTrue();
      expect(sessionRect.contains(10, 60)).assertTrue();
      expect(sessionRect.contains(40, 20)).assertTrue();
      expect(sessionRect.contains(40, 60)).assertTrue();
      expect(sessionRect.contains(9, 20)).assertFalse();
      expect(sessionRect.contains(41, 60)).assertFalse();
      expect(sessionRect.contains(40, 19)).assertFalse();
      expect(sessionRect.contains(40, 61)).assertFalse();
    })

    it('printPxTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      expect(sessionRect.printPx().indexOf("10")).assertLarger(0);
      expect(sessionRect.printPx().indexOf("20")).assertLarger(0);
      expect(sessionRect.printPx().indexOf("30")).assertLarger(0);
      expect(sessionRect.printPx().indexOf("40")).assertLarger(0);
    })

    it('printPxTest', 0, () => {
      let sessionRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
      expect(sessionRect.printPx().indexOf("10")).assertLarger(0);
      expect(sessionRect.printPx().indexOf("20")).assertLarger(0);
      expect(sessionRect.printPx().indexOf("30")).assertLarger(0);
      expect(sessionRect.printPx().indexOf("40")).assertLarger(0);
    })
  })
}