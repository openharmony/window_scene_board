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
import { BrightnessManager } from '@ohos/pcbase/src/main/ets/SceneBoard/brightnesspanel/common/BrightnessManager'

export default function BrightnessManagerTest() {
  describe('BrightnessManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('setValue125', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(125)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setValue135', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(135)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('addValue', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.addValue(0)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('addValueOverMax', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(1000)
        mBrightnessManager.addValue(1000)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('subValue', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.subValue(0)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('subValueOverMin', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(0)
        mBrightnessManager.subValue(0)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getInterval', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.getInterval()
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMaxValue1', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(500)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMaxValue2', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(600)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMaxValue3', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(700)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMaxValue4', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(800)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMaxValue5', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(900)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMinValue1', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(-1)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMinValue2', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(-10)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMinValue3', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(-31)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMinValue4', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(-41)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setOverMinValue5', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.setPCValue(-51)
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('unRegisterBrightness', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.unRegisterBrightness()
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('RegisterBrightness', 0, () => {
      try{
        let mBrightnessManager: BrightnessManager = new BrightnessManager();
        mBrightnessManager.registerBrightness()
      } catch (e) {
        expect(false).assertFail();
      }
    })
  })
}