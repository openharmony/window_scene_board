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
import { describe, it, expect, Level } from '@ohos/hypium';
import { ExtendClipPath, ComponentAnimState } from '../../../../../../main/ets/base/anim/ComponentAnimState';

export function ExtendClipPathTest() {
  describe('ExtendClipPathTest', (): void => {
    it('test_initExtendClipPath', Level.LEVEL0, (): void => {
      let testInstance = new ExtendClipPath();
      expect(testInstance instanceof ExtendClipPath).assertTrue();
    });
    it('test_bindAnimValid', Level.LEVEL0, (): void => {
      let testInstance = new ExtendClipPath();
      let test = testInstance.bindAnimValid(true);
      expect(test instanceof ExtendClipPath).assertTrue();
    });
    it('test_isClipAnimValid', Level.LEVEL0, (): void => {
      let testInstance = new ExtendClipPath();
      (testInstance as object)['isAnimValid'] = true
      let test = testInstance.isClipAnimValid();
      expect(test).assertTrue();
    });
    it('test_multiply', Level.LEVEL0, (): void => {
      let testInstance = new ExtendClipPath();
      let test = testInstance.multiply(10);
      expect(test instanceof ExtendClipPath).assertTrue();
    });
  });

}

export function ExtendClipPathTest_two() {
  describe('ComponentAnimStateTest_two', (): void => {
    it('test_initComponentAnimState', Level.LEVEL0, (): void => {
      let testInstance = new ComponentAnimState('test');
      expect(testInstance instanceof ComponentAnimState).assertTrue();
    });
    it('test_getComponentName', Level.LEVEL0, (): void => {
      let testInstance = new ComponentAnimState('test');
      let name = testInstance.getComponentName();
      expect(name).assertEqual('test');
    });
    it('test_setClip', Level.LEVEL0, (): void => {
      let testInstance = new ComponentAnimState('test');
      let res = testInstance.setClip(true);
      expect(res instanceof ComponentAnimState).assertTrue();
    });
    it('test_clearRadius', Level.LEVEL0, (): void => {
      let testInstance = new ComponentAnimState('test');
      let res = testInstance.clearRadius();
      expect(res instanceof ComponentAnimState).assertTrue();
    });
    it('test_clearClipPath', Level.LEVEL0, (): void => {
      let testInstance = new ComponentAnimState('test');
      let res = testInstance.clearClipPath();
      expect(res instanceof ComponentAnimState).assertTrue();
    });
  });
}